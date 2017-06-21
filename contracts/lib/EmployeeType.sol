pragma solidity ^0.4.8;

import "./SalaryType.sol";


/// An Employee
library EmployeeType {
  using SalaryType for SalaryType.Self;
  using EmployeeType for EmployeeType.Self;

  struct Self {
    // Employee Address
    address employee;
    // Base Token Address
    address baseToken;
    // Total salary per period
    uint256 totalSalary;
    // Defined in USD
    uint256 paymentPeriod;
    // Employment Date
    uint256 startTime;
    // Allocation in Tokens Total
    uint256 totalAllocation;
    // Array of other Token Salaries
    SalaryType.Self[] tokenSalaries;
  }

  /// Reset Self
  function reset(Self storage self) internal {
      self.tokenSalaries.length = 0;
      self.totalSalary = 0;
      self.paymentPeriod = 0;
      self.startTime = today();
  }

  /// Init Self + Creates Base Token Salary
  function init(Self storage self, address employee, uint256 totalSalary, uint256 paymentPeriod) internal {
    self.reset();

    self.employee = employee;
    self.totalSalary = totalSalary;
    self.paymentPeriod = paymentPeriod;
    self.startTime = today();
  }

  /// Add Salary
  function addSalary(Self storage self, SalaryType.Self memory salary) internal {
    self.tokenSalaries[self.tokenSalaries.length++] = salary;
  }

  /// Allocate a Token Salary
  function allocate(Self storage self, address token, uint256 allocation) internal returns (bool error) {

    // Total token allocations must be within totalSalary, also check for overflows
    var newTotal = self.totalAllocation + allocation;
    if (newTotal > self.totalSalary || newTotal < self.totalAllocation) return true;

    // Otherwise we can add this token salary
    self.totalAllocation = newTotal;
    self.tokenSalaries[self.tokenSalaries.length++] = SalaryType.Self(token, allocation, today());

    return false;
  }
  
  /// Check how much in base salary (USD) is owed in total
  function totalOwed(Self storage self) internal constant returns (uint owedPayments) {
      for (uint i = 0; i < self.tokenSalaries.length; i++) {
          owedPayments += self.tokenSalaries[i].allocationOwed(self.paymentPeriod);
      }
  }

  // determines today's index.
  function today() private constant returns (uint) {
    return now / 1 days;
  }

}