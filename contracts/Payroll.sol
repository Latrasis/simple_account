pragma solidity ^0.4.11;

import "zeppelin/lifecycle/TokenDestructible.sol";
import "./AbstractPayroll.sol";

contract Payroll is AbstractPayroll, TokenDestructible {

  function Payroll(address _oracle) {
    oracle = _oracle;
  }

  // External Calls
  function () payable {}

  /* OWNER ONLY */

  /// @dev Adds An Employee
  function addEmployee(address eAddress, address[] allowedTokens, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.dailySalary > 0) throw;
    if (allowedTokens.length == 0) throw;

    employee.allowedTokens = allowedTokens;
    employee.dailySalary = dailySalary;
    NewEmployee(eAddress, now);
  }

  /// @dev Sets An Employee
  function setEmployeeSalary(address eAddress, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.dailySalary == 0) throw;

    employee.dailySalary = dailySalary;
  }

  /// @dev Removes An Employee
  function removeEmployee(address eAddress) onlyOwner {
        employeeOf[eAddress].dailySalary = 0;
        employeeOf[eAddress].allowedTokens.length = 0;
        RemovedEmployee(eAddress, now);
  }





}