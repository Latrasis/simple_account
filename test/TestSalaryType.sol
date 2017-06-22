pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/lib/SalaryType.sol";
import "../contracts/lib/AllocationType.sol";
import "zeppelin/token/SimpleToken.sol";

contract TestSalaryType {
    using AllocationType for AllocationType.Self;
    using SalaryType for SalaryType.Self;
    
    SalaryType.Self sample_employee;
    AllocationType.Self[] sample_salaries;

    // Self::reset()
    function testShouldInitialize() {

        // New Sample Salary
        var sample_token = new SimpleToken();
        var sample_salary = AllocationType.Self(address(sample_token), 100, 0);

        // Init Sample Employee
        sample_employee.init(address(0x123), 1000, 30);

        Assert.equal(sample_employee.totalSalary, 1000, "should set totalSalary");
        Assert.equal(sample_employee.paymentPeriod, 30, "should set paymentPeriod");
        Assert.equal(sample_employee.startTime, now / 1 days, "should set startTime");
        Assert.equal(sample_employee.tokenSalaries.length, 0, "should set empty tokenSalaries");
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
