pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/lib/EmployeeType.sol";
import "../contracts/lib/SalaryType.sol";
import "zeppelin/token/SimpleToken.sol";

contract TestEmployeeType {
    using SalaryType for SalaryType.Self;
    using EmployeeType for EmployeeType.Self;
    
    // Self::reset()
    function testShouldReset() {
        // Unimplemented
        throw;
    }

    // Self::owed()
    function testShouldGetOwed() {
        // Unimplemented
        throw;
    }

    // self.updateSalary()
    function testShouldUpdateSalary() {
        // Unimplemented
        throw;
    }

}
