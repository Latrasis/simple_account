pragma solidity ^0.4.8;

import "zeppelin/token/ERC20.sol";

/// A Token Salary
library SalaryType {
  using SalaryType for SalaryType.Self;
  struct Self {
    // An ERC20 basic token
    address token;
    // Allocation in Base Token
    uint allocation;
    // Time since last paycheck
    uint lastPaycheckDay;
  }

  /// Reset Self
  function reset(Self storage self) internal {
      self.allocation = 0;
      self.lastPaycheckDay = today();
  }

  /// Get Token Amount by Exchange Value
  /// Exchange value must be set in denominations of 7 decimal places
  function getTokenAmount(Self storage self, uint256 exchangeValue) internal returns (bool error, uint256 amount) {
    // Checks for Token address and valid params
    error = self.token == 0 || exchangeValue == 0;
    // Exchange value must be set in denominations of 7 decimal places
    amount = (exchangeValue * self.allocation) / (10 << 7);
  }

  /// Check how many paychecks owed
  function paychecksOwed(Self storage self, uint paymentPeriod) internal constant returns (uint) {
    // Get Time Passed, throw if minimum paymentPeriod hasn't passed
    var timePassed = today() - self.lastPaycheckDay;

    // TODO, manage possible overflow
    // timePassed = self.lastPaycheckDay > today() ? (0-1) - timePassed : timePassed;
    if (timePassed < paymentPeriod) return 0;

    // Amount of owed paychecks
    return timePassed / paymentPeriod;
  }

  // Check how much in base salary (USD) is owed
  function allocationOwed(Self storage self, uint paymentPeriod) internal constant returns (uint) {
    return self.paychecksOwed(paymentPeriod) * self.allocation;
  }

  /// Issue paycheck based on days passed
  /// employee: address to send paycheck to
  /// paymentPeriod: minimum period of days between paychecks
  function issuePaycheck(Self storage self, address employee, uint paymentPeriod, uint exchangeValue) internal returns (bool error) {

    // Get Value
    var (err, amount) = self.getTokenAmount(exchangeValue);
    if (err) return true;

    // Check paychecks owed
    var paymentsOwed = self.paychecksOwed(paymentPeriod);
    if (paymentsOwed == 0) return true;

    // Exchange Value is Denominated 
    var sumOwed = 0 * paymentsOwed;

    // Get Token
    var token = ERC20(self.token);
    // Update Payday
    self.lastPaycheckDay = today();
    // Get Current Allowance
    var current = token.allowance(this, employee);
    // Update Allowance
    token.approve(employee, sumOwed + current);

    return false;
  }

  // determines today's index.
  function today() private constant returns (uint) {
    return now / 1 days;
  }

}