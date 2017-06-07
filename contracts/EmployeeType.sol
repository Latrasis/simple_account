pragma solidity ^0.4.8;

import "./SalaryType.sol";

/// An Employee
library EmployeeType {
  using SalaryType for SalaryType.Self;

  struct Self {
    /// Array of Token Salaries
    SalaryType.Self[] allowedTokens;
    // Defined in USD
    uint256 totalDailySalary;
  }


}