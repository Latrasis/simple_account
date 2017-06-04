pragma solidity ^0.4.11;

import "zeppelin/lifecycle/TokenDestructible.sol";
import "./AbstractPayroll.sol";
import "zeppelin/SafeMath.sol";

contract Payroll is AbstractPayroll, TokenDestructible {
  using SafeMath for uint;

  function Payroll(address _oracle) {
    oracle = _oracle;
  }

  /* PUBLIC */

  // Fallback 
  function () payable {}

  // Salary Accessor
  function getSalaryOf(address eAddress) constant returns (uint256) {
      return employeeOf[eAddress].totalDailySalary;
  }

  // Finds Allocation of an Employee (Very Dirty)
  function getAllocationOf(address eAddress, address token) constant returns (bool, uint256) {
      var employee = employeeOf[eAddress];
      if (employee.allowedTokens.length == 0) {
          return (true, 0);
      }

      for (uint i = 0; i < employee.allowedTokens.length; i++) {
          var salary = employee.allowedTokens[i];
          if (salary.token == token) {
            return (false, salary.dailySalary);
          }
      }
      
      return (true, 0);
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

  function addEmployee(address eAddress, address[] allowedTokens, uint256[] distribution, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.totalDailySalary > 0) throw;
    if (allowedTokens.length == 0 || allowedTokens.length != distribution.length) throw;
    
    // Set Salary
    employee.totalDailySalary = dailySalary;

     // First Find Ratio
    uint256 total = 0;
    // Assume each index must match, otherwise throw
    for (uint x = 0; x < allowedTokens.length; x++) {
        total += distribution[x];
    }

    // Set Token Salary
    employee.allowedTokens.length = allowedTokens.length;
    for (uint i = 0; i < allowedTokens.length; i++) {
        // Check that token has exchange value
        var token = allowedTokens[i];
        var currentValue = tokenUSDValueOf[token];
        if (currentValue == 0) throw;

        // Given DailyLimit 'n', get ratio of 'n' for token 'i'
        var amountInUSD = dailySalary.mul(distribution[i]).div(total);
        var amountInToken = amountInUSD.div(currentValue);

        // Update Token Salary
        var newTokenSalary = employee.allowedTokens[i];
        newTokenSalary.token = token;
        newTokenSalary.dailySalary = amountInToken;
    }

    NewEmployee(eAddress, now);
  }

  function setEmployeeSalary(address eAddress, uint256 dailySalary) onlyOwner {
    var employee = employeeOf[eAddress];
    if (employee.totalDailySalary == 0) throw;
    employee.totalDailySalary = dailySalary;
  }
  function removeEmployee(address eAddress) onlyOwner {
    var employee = employeeOf[eAddress];
    employee.totalDailySalary = 0;
    employee.allowedTokens.length = 0;

    RemovedEmployee(eAddress, now);
  }
  function setOracle(address newOracle) onlyOwner {
    oracle = newOracle;
  }

  /* EMPLOYEE ONLY */
  function setAllocation(address[] tokens, uint256[] distribution) onlyEmployee {
    var employee = employeeOf[msg.sender];
    if (tokens.length == 0 || tokens.length != distribution.length || tokens.length != employee.allowedTokens.length) throw;

    // First Find Ratio
    uint256 total = 0;
    // Assume each index must match, otherwise throw
    for (uint x = 0; x < tokens.length; x++) {
        total += distribution[x];
    }

    // Find Value
    // Assume each index must match, otherwise throw
    // TODO: How to deal with token value less than 1
    for (uint i = 0; i < tokens.length; i++) {
        // Check that tokens match by index and has exchange value
        var prevSalary = employee.allowedTokens[i];
        var currentValue = tokenUSDValueOf[prevSalary.token];
        if (tokens[i] != prevSalary.token || currentValue == 0) throw;

        // Given DailyLimit 'n', get ratio of 'n' for token 'i'
        var amountInUSD = employee.totalDailySalary.mul(distribution[i]).div(total);
        var amountInToken = amountInUSD.div(currentValue);

        // Update Token Salary
        prevSalary.dailySalary = amountInToken;
    }
  }
  function payday() onlyEmployee {}

  /* ORACLE ONLY */
  function setExchangeRate(address[] tokens, uint256[] usdExchangeRates) external onlyOracle {}

}