pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/lib/AllocationType.sol";
import "zeppelin/token/SimpleToken.sol";
import "zeppelin/token/StandardToken.sol";

contract TestAllocationType {
    using AllocationType for AllocationType.Self;

    AllocationType.Self sample_salary;

    // Self::reset()
    function testShouldReset() {
        var sample_token = new SimpleToken();
        sample_salary = AllocationType.Self(address(sample_token),1, 0);
        
        sample_salary.reset();

        Assert.equal(sample_salary.allocation, 0, "should reset allocation");
        Assert.equal(sample_salary.lastPaycheckDay, now / 1 days, "should set lastPayDay to current day");
    }

    // Self::paychecksOwed()
    function testShouldGetPaychecksOwed() {

        // Set One Week
        var owed_days = 7;
        var prev_day = (now / 1 days) - owed_days;

        var sample_token = new SimpleToken();
        sample_salary = AllocationType.Self(address(sample_token),1,prev_day);

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
        sample_salary = AllocationType.Self(address(sample_token),allocation,prev_day);

        // Set One Day Payment Period
        var allocation_owed = sample_salary.allocationOwed(1);
        Assert.equal(allocation_owed, owed_days*allocation, "should provide total allocation");
    }
    
    // self.updateValue()
    function testShouldGetValue() {
        var sample_token = new SimpleToken();
        sample_salary = AllocationType.Self(address(sample_token), 100, 0);
        
        // Assume 1 Token is 40 BaseToken
        var sample_value = 40;
        var (err, amount) = sample_salary.getTokenAmount(sample_value, 0);

        Assert.equal(amount, 4000, "should set updated token amount by allocation");
    }

    // self.issuePaycheck()
    function testShouldIssuePaycheck() {

        // Simple Token creates 10000 for sender
        var sample_token = new SimpleToken();
        address sample_employee = 0x123;

        // Set 1 Owed Day
        var owed_days = 1;
        var prev_day = (now / 1 days) - owed_days;

        sample_salary = AllocationType.Self(address(sample_token), 100, prev_day);

        // Assume 1 Token is 1 BaseToken
        uint sample_value = 1;
        uint8 decimals = 0;
        // Assume 1 Day pay period
        uint sample_payperiod = 1;

        var err1 = sample_salary.issuePaycheck(sample_employee, sample_payperiod, sample_value, decimals);
        Assert.equal(err1, false, "Should Issue Paycheck");

        // Check Balance of Employer and Employee
        var allocated_payment = sample_token.allowance(address(this), sample_employee);
        Assert.equal(allocated_payment, 100, "Should allocate token to employee");
    }

}
