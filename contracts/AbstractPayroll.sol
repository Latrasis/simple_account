pragma solidity ^0.4.11;

import "zeppelin/ownership/Ownable.sol";

/// AbstractPayroll
/// Defines a base contract that handles a daily payroll of employees
contract AbstractPayroll {
  
  // Employee
  mapping (address => Employee) public employeeOf;
  uint256 public employeeCount;

  // Tokens
  mapping (address => uint256) public tokenUSDValueOf;

  // Oracle
  address public oracle;

  event UpdateExchangeRate(address token, uint256 USDrate, address oracle, uint256 timestamp);
  event NewEmployee(address accountAddress, uint256 timestamp);
  event RemovedEmployee(address accountAddress, uint256 timestamp);

  /// A Token Salary
  struct Salary {
    /// An ERC20 basic token
    address token;
    /// A daily salary of that specific token
    uint256 dailySalary;
    /// Total Salary Spent
    uint256 lastPayDay;
  }

  /// Defines an Employee Salary
  struct Employee {
    /// Array of Token Salaries
    Salary[] allowedTokens;
    // Defined in USD
    uint256 totalDailySalary;
  }

  modifier onlyEmployee() {
    if (employeeOf[msg.sender].totalDailySalary == 0) {
      throw;
    }
    _;
  }

  modifier onlyOracle() {
    if (msg.sender == oracle) {
      throw;
    }
    _;
  }

  /* PAYABLE */

  /// Used primarily by owner to refill 
  function () payable;

  /* PUBLIC */
  function getSalaryOf(address eAddress) constant returns (uint256);
  function calculatePayrollBurnrate() constant returns (uint256); // Monthly usd amount spent in salaries
  function calculatePayrollRunway() constant returns (uint256); // Days until the contract can run out of funds
  
  // /* OWNER ONLY */

  /// Given a daily salary in USD, tokens and a corresponding distributions for each
  /// determine daily token amount
  function addEmployee(address eAddress, address[] allowedTokens, uint256[] distribution, uint256 dailySalary);
  function setEmployeeSalary(address eAddress, uint256 dailySalary);

  /// TODO: Check if Employee still is owed?
  function removeEmployee(address eAddress);
  function setOracle(address oracle);

  /* EMPLOYEE ONLY */

  /// Allow the Employee to set his/her daily token salary
  /// Given a token ERC20 address and ratio at corresponding index.
  /// Should find exchange value for each token based on USD and ratio
  function setAllocation(address[] tokens, uint256[] distribution);

  /// Withdraw owed daily token amounts to Employee
  /// Payment is implementation independant
  function payday();

  /* ORACLE ONLY */
  /// Set exchange rate for token (assume USD)
  function setExchangeRate(address[] tokens, uint256[] usdExchangeRates) external; // uses decimals from token
}
