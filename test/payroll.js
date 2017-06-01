var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {

    describe('constructor', function () {
        return Payroll.deployed()
            .then(function (payroll) {
                return payroll.owner.call(accounts[0]);
            }).then(function (owner) {
                assert.equal(owner, accounts[0]);
            });
    })

    describe('Payable Calls', function () {
        describe('Default', function () {
            it('should receive tokens', async function () {
                let payroll = await Payroll.deployed();
                await payroll.send(100);
                
                let balance = web3.eth.getBalance(payroll.address).toNumber();
                assert.equal(balance, 100);
            })           
        })
        describe('.addFunds() payable', function () {
            throw new Error('Unimplemented')
        });
    })
    describe('Public Calls', function () {
        describe('.getEmployeeCount() constant returns (uint256)', function () {
            throw new Error('Unimplemented')
        });
        describe('.getEmployee(uint256 employeeId) constant returns (address employee)', function () {
            throw new Error('Unimplemented')
        });
        describe('.calculatePayrollBurnrate() constant returns (uint256)', function () {
            throw new Error('Unimplemented')
        });
        describe('.calculatePayrollRunway() constant returns (uint256)', function () {
            throw new Error('Unimplemented')
        }); 

    })

    describe('Employer Calls', function () {
        describe('addEmployee(address accountAddress, address[] allowedTokens, uint256 initialYearlyUSDSalary)', function () {
            throw new Error('Unimplemented')
        });
        describe('setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary)', function () {
            throw new Error('Unimplemented')
        });
        describe('removeEmployee(uint256 employeeId)', function () {
            throw new Error('Unimplemented')
        });
        describe('setOracle(address oracle)', function () {
            throw new Error('Unimplemented')
        });
    })

    describe('Employee Calls', function () {
        describe('determineAllocation(address[] tokens, uint256[] distribution)', function () {
            throw new Error('Unimplemented')
        });
        describe('payday(); // only callable once a month', function () {
            throw new Error('Unimplemented')
        });
    })

    describe('Oracle Calls', function () {
        describe('setExchangeRate(address token, uint256 usdExchangeRate)', function () {
            throw new Error('Unimplemented')
        })
    })

})
