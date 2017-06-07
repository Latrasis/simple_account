pragma solidity ^0.4.8;

import "zeppelin/token/ERC20Basic.sol";

/// A Token Salary
library SalaryType {
  using SalaryType for SalaryType.Self;
  struct Self {
    // An ERC20 basic token
    address token;
    // Token Salary
    uint amount;
    // Allocation in Base Token
    uint allocation;
    // Time since last paycheck
    uint lastPaycheckDay;
  }

  /// Reset Self
  function reset(Self storage self) internal {
      self.amount = 0;
      self.allocation = 0;
      self.lastPaycheckDay = today();
  } 

  /// Update Token Salary given:
  /// exchangeValue: where exchangeValue * allocation = Self.amount
  function updateValue(Self storage self, uint256 exchangeValue) internal returns (bool error) {
    // Checks for Token address and valid params
    if (self.token == 0) return true;
    // If allocation or exchange value equal zero, assume zero amount
    if (self.allocation == 0 || exchangeValue == 0) {
        self.amount = 0;
    }

    // TODO: Need to handle conversion checks for accuracy
    self.amount = exchangeValue * self.allocation;
    return false;
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

    // Update Value
    self.updateValue(exchangeValue);

    // Check paychecks owed
    var paymentsOwed = self.paychecksOwed(paymentPeriod);
    if (paymentsOwed == 0) return true;

    var sumOwed = self.amount * paymentsOwed;

    var token = ERC20Basic(self.token);
    // Check Balance of Employer
    var employerBalance = token.balanceOf(address(this));
    // If Employer is unable to pay, throw
    if (employerBalance < sumOwed) return true;

    // If able, first update self
    self.lastPaycheckDay = today();
    // Then send paycheck
    token.transfer(employee, sumOwed);

    return false;
  }

  // determines today's index.
  function today() private constant returns (uint) {
    return now / 1 days;
  }


}