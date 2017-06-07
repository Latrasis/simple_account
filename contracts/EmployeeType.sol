pragma solidity ^0.4.8;

import "./SalaryType.sol";


/// An Employee
library EmployeeType {
  using SalaryType for SalaryType.Self;
  using EmployeeType for EmployeeType.Self;

  struct Self {
    // Employee Address
    address employee;
    // Total salary per period
    uint256 totalSalary;
    // Defined in USD
    uint256 paymentPeriod;
    // Employment Date
    uint256 startTime;
    // Array of Token Salaries
    SalaryType.Self[] tokenSalaries;
  }

  /// Reset Self
  function reset(Self storage self) internal {
      self.tokenSalaries.length = 0;
      self.totalSalary = 0;
      self.paymentPeriod = 0;
      self.startTime = today();
  }
  
  function owed(Self storage self) internal constant returns (uint owedPayments) {
      for (uint i = 0; i < self.tokenSalaries.length; i++) {
          owedPayments += self.tokenSalaries[i].allocationOwed(self.paymentPeriod);
      }
  }

  /// Update Salary
  /// tokens: List of ERC20 token addresses, must correlate with tokenSalary index
  /// allocations: Correlated by index, amount in base token, where sum of all allocations = totalSalary
  /// totalSalary: Total salary per period
  /// paymentPeriod: Period of days per salary
  function updateSalary(Self storage self, address[] tokens, uint256[] allocations, uint256 totalSalary, uint256 paymentPeriod) internal returns (bool error) {
    // Check params
    if (tokens.length != allocations.length || totalSalary == 0 || paymentPeriod == 0) return true;

    // Check if any salary is still owed
    if (self.owed() > 0) return true;
    // Clear Data
    self.reset();

    // Prepare Array
    self.tokenSalaries.length = tokens.length;
    // Prepare Sum Check
    uint256 sumCheck = 0;
    for (uint256 i = 0; i < tokens.length; i++) {
        // Check for overflows, but return error
        var nextSum = sumCheck + allocations[i];
        if (nextSum < sumCheck) return true;
        sumCheck = nextSum;

        self.tokenSalaries[i] = SalaryType.Self(tokens[i], 0, allocations[i], today());
    }

    // If SumCheck does not equal totalSalary, this is an invalid Salary
    if (sumCheck != totalSalary) return true;

    // At this point we can update the rest
    self.totalSalary = totalSalary;
    self.paymentPeriod = paymentPeriod;

    return false;
  }

  // determines today's index.
  function today() private constant returns (uint) {
    return now / 1 days;
  }



}