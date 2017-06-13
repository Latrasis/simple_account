pragma solidity ^0.4.11;

import "zeppelin/lifecycle/TokenDestructible.sol";
import "./AbstractPayroll.sol";
import "zeppelin/SafeMath.sol";
import "zeppelin/token/ERC20Basic.sol";

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
  function getAllocationOf(address eAddress, address token) constant returns (bool, uint256) {}

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
    NewEmployee(eAddress, now);
  }

  function setEmployeeSalary(address eAddress, uint256 dailySalary) onlyOwner {}
  
  function removeEmployee(address eAddress) onlyOwner {
    RemovedEmployee(eAddress, now);
  }
  function setOracle(address newOracle) onlyOwner {
    oracle = newOracle;
  }

  /* EMPLOYEE ONLY */
  function setAllocation(address[] tokens, uint256[] distribution) onlyEmployee {}

  /// Payday pays employee in tokens in full owed
  function payday() onlyEmployee {}

  /* ORACLE ONLY */
  function setExchangeRate(address[] tokens, uint256[] usdExchangeRates) external onlyOracle {
      if (tokens.length != usdExchangeRates.length) throw;
      for (var i = 0; i < tokens.length; i++) {
          tokenUSDValueOf[tokens[i]] = usdExchangeRates[i];
      }
  }

}