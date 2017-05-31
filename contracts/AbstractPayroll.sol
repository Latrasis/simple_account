pragma solidity ^0.4.11;

import "zeppelin/lifecycle/TokenDestructible.sol";
import "zeppelin/ownership/Ownable.sol";

// For the sake of simplicity lets asume USD is a ERC20 token
// Also lets asume we can 100% trust the exchange rate oracle
contract AbstractPayroll is Ownable {

  struct Employee {
    address[] allowedTokens;
    uint256 dailyLimit;
  }

  modifier onlyEmployee() {
    if (employeeOf[msg.sender].dailyLimit == 0) {
      throw;
    }
    _;
  }

  mapping (address => Employee) public employeeOf;
  address oracle;

  /* PUBLIC */
  function getEmployeeCount() constant returns (uint256);
  function getEmployee(uint256 employeeId) constant returns (address employee); // Return all important info too

  function calculatePayrollBurnrate() constant returns (uint256); // Monthly usd amount spent in salaries
  function calculatePayrollRunway() constant returns (uint256); // Days until the contract can run out of funds
  
  function addFunds() payable;

  // /* OWNER ONLY */
  function addEmployee(address accountAddress, address[] allowedTokens, uint256 initialYearlyUSDSalary);
  function setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary);
  function removeEmployee(uint256 employeeId);
  function setOracle(address oracle);

  /* EMPLOYEE ONLY */
  function determineAllocation(address[] tokens, uint256[] distribution); // only callable once every 6 months
  function payday(); // only callable once a month

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate); // uses decimals from token
}

// contract Payroll is PayrollInterface, TokenDestructible {};
