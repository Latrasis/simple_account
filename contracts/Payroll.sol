pragma solidity ^0.4.11;

import "zeppelin/lifecycle/TokenDestructible.sol";
import "./AbstractPayroll.sol";

contract Payroll is AbstractPayroll, TokenDestructible {

  function Payroll(address _oracle) {
    oracle = _oracle;
  }

  /* PUBLIC */

  // Fallback 
  function () payable {}

  // Salary Accessor
  function getSalaryOf(address eAddress) constant returns (uint256) {
      return employeeOf[eAddress].dailySalary;
  }

  // Monthly usd amount spent in salaries
  function calculatePayrollBurnrate() constant returns (uint256) {
      return 0;
  }
  // Days until the contract can run out of funds
  function calculatePayrollRunway() constant returns (uint256) {
      return 0;
  }
  
  /* OWNER ONLY */

  
  function addEmployee(address eAddress, address[] allowedTokens, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.dailySalary > 0) throw;
    if (allowedTokens.length == 0) throw;
    
    employee.allowedTokens = allowedTokens;
    employee.dailySalary = dailySalary;

    NewEmployee(eAddress, now);
  }
  function setEmployeeSalary(address eAddress, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.dailySalary == 0) throw;
    employee.dailySalary = dailySalary;
  }
  function removeEmployee(address eAddress) onlyOwner {
    var employee = employeeOf[eAddress]
    employee.dailySalary = 0;
    employee.allowedTokens.length = 0;
    employee.distribution.length = 0;

    RemovedEmployee(eAddress, now);
  }
  function setOracle(address oracle) onlyOwner {}

  /* EMPLOYEE ONLY */
  function setAllocation(address[] tokens, uint256[] distribution) onlyEmployee {}
  function payday() onlyEmployee {}

  /* ORACLE ONLY */
  function setExchangeRate(address token, uint256 usdExchangeRate) onlyOracle {} // uses decimals from token

}