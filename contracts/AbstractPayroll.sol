pragma solidity ^0.4.11;

import "zeppelin/ownership/Ownable.sol";

// For the sake of simplicity lets asume USD is a ERC20 token
// Also lets asume we can 100% trust the exchange rate oracle
contract AbstractPayroll is Ownable {
  
  // Employee
  mapping (address => Employee) public employeeOf;
  uint256 public employeeCount;

  // Tokens
  mapping (address => uint256) public tokenUSDValueOf;

  // Oracle
  address oracle;

  event UpdateExchangeRate(address token, uint256 USDrate, address oracle, uint256 timestamp);
  event NewEmployee(address accountAddress, uint256 timestamp);
  event RemovedEmployee(address accountAddress, uint256 timestamp);

  struct Employee {
    address[] allowedTokens;
    uint256 dailySalary;
  }

  modifier onlyEmployee() {
    if (employeeOf[msg.sender].dailySalary == 0) {
      throw;
    }
    _;
  }

  /* PAYABLE */
  function () payable;

  /* PUBLIC */
  function calculatePayrollBurnrate() constant returns (uint256); // Monthly usd amount spent in salaries
  function calculatePayrollRunway() constant returns (uint256); // Days until the contract can run out of funds
  
  // /* OWNER ONLY */
  function addEmployee(address eAddress, address[] allowedTokens, uint256 dailySalary);
  function setEmployeeSalary(uint256 employeeId, uint256 dailySalary);
  function removeEmployee(uint256 employeeId);
  function setOracle(address oracle);

  /* EMPLOYEE ONLY */
  function determineAllocation(address[] tokens, uint256[] distribution); // only callable once every 6 months
  function payday(); // only callable once a month

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate); // uses decimals from token
}
