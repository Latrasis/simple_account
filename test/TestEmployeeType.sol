pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/lib/EmployeeType.sol";
import "../contracts/lib/SalaryType.sol";
import "zeppelin/token/SimpleToken.sol";

contract TestEmployeeType {
    using SalaryType for SalaryType.Self;
    using EmployeeType for EmployeeType.Self;
    
    EmployeeType.Self sample_employee;
    SalaryType.Self[] sample_salaries;

    // Self::reset()
    function testShouldInitialize() {

        // New Sample Salary
        var sample_token = new SimpleToken();
        var sample_salary = SalaryType.Self(address(sample_token), 100, 0);

        // Init Sample Employee
        sample_employee.init(address(0x123), 1000, 30);
        sample_employee.addSalary(sample_salary);

        Assert.equal(sample_employee.totalSalary, 1000, "should set totalSalary");
        Assert.equal(sample_employee.paymentPeriod, 30, "should set paymentPeriod");
        Assert.equal(sample_employee.startTime, now / 1 days, "should set startTime");
        Assert.equal(sample_employee.tokenSalaries.length, 1, "should set tokenSalaries");
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
