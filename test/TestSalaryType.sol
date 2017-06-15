pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/lib/SalaryType.sol";
import "zeppelin/token/SimpleToken.sol";

contract TestSalaryType {
    using SalaryType for SalaryType.Self;

    SalaryType.Self sample_salary;

    // Self::reset()
    function testShouldReset() {
        var sample_token = new SimpleToken();
        sample_salary = SalaryType.Self(address(sample_token),1,1, 0);
        
        sample_salary.reset();

        Assert.equal(sample_salary.amount, 0, "should reset amount");
        Assert.equal(sample_salary.allocation, 0, "should reset allocation");
        Assert.equal(sample_salary.lastPaycheckDay, now / 1 days, "should set lastPayDay to current day");
    }

    // Self::paychecksOwed()
    function testShouldGetPaychecksOwed() {

        // Set One Week
        var owed_days = 7;
        var prev_day = (now / 1 days) - owed_days;
        
        var sample_token = new SimpleToken();
        sample_salary = SalaryType.Self(address(sample_token),1,1,prev_day);

        // Set One Day Payment Period
        var paychecks_owed = sample_salary.paychecksOwed(1);
        Assert.equal(paychecks_owed, owed_days, "should provide paychecks owed");
    }

    // Self::allocationOwed()
    function testShouldGetAllocationOwed() {

        // Set One Week
        var owed_days = 7;
        var prev_day = (now / 1 days) - owed_days;
        // Set Allocation of 10
        var allocation = 10;

        var sample_token = new SimpleToken();
        sample_salary = SalaryType.Self(address(sample_token),1,allocation,prev_day);

        // Set One Day Payment Period
        var allocation_owed = sample_salary.allocationOwed(1);
        Assert.equal(allocation_owed, owed_days*allocation, "should provide total allocation");
    }
    
    // self.updateValue()
    function testShouldUpdateValue() {
        // Unimplemented
        throw;
    }

    // self.issuePaycheck()
    function shouldIssuePaycheck() {
        // Unimplemented
        throw;
    }

}
