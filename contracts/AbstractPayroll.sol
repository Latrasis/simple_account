pragma solidity ^0.4.11;

import "zeppelin/ownership/Ownable.sol";

// For the sake of simplicity lets asume USD is a ERC20 token
// Also lets asume we can 100% trust the exchange rate oracle
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

  struct Salary {
    address token;
    uint256 dailySalary;
  }

  struct Employee {
    Salary[] allowedTokens;
    uint256 dailySalary;
  }

  modifier onlyEmployee() {
    if (employeeOf[msg.sender].dailySalary == 0) {
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
  function () payable;

  /* PUBLIC */
  // function getSalaryOf(address eAddress) constant returns (uint256);
  function calculatePayrollBurnrate() constant returns (uint256); // Monthly usd amount spent in salaries
  function calculatePayrollRunway() constant returns (uint256); // Days until the contract can run out of funds
  
  // /* OWNER ONLY */
  function addEmployee(address eAddress, address[] allowedTokens, uint256[] distribution, uint256 dailySalary);
  function setEmployeeSalary(address eAddress, uint256 dailySalary);
  function removeEmployee(address eAddress);
  function setOracle(address oracle);

  /* EMPLOYEE ONLY */
  function setAllocation(address[] tokens, uint256[] distribution); // only callable once every 6 months
  function payday(); // only callable once a month

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate); // uses decimals from token
}
