
const Payroll = artifacts.require('./Payroll.sol')

contract('Payroll', function (accounts) {

    describe('constructor', async function () {
        let payroll = await Payroll.deployed();  
        let owner = await payroll.owner.call(accounts[0])      
        assert.equal(owner, accounts[0]);
    })

    describe('Payable Calls', function () {
        describe('Default', function () {
            it('should receive tokens', async function () {
                let payroll = await Payroll.deployed();
                return payroll.send(100).then(() => {
                    let balance = web3.eth.getBalance(payroll.address).toNumber();
                    assert.equal(balance, 100);
                })
            })           
        })
        describe('.addFunds() payable', function () {
            it('should pass')
        });
    })
    describe('Public Calls', function () {
        describe('.getEmployeeCount() constant returns (uint256)', function () {
            it('should pass')
        });
        describe('.getEmployee(uint256 employeeId) constant returns (address employee)', function () {
            it('should pass')
        });
        describe('.calculatePayrollBurnrate() constant returns (uint256)', function () {
            it('should pass')
        });
        describe('.calculatePayrollRunway() constant returns (uint256)', function () {
            it('should pass')
        }); 

    })

    describe('Employer Calls', function () {
        describe('addEmployee(address accountAddress, address[] allowedTokens, uint256 initialYearlyUSDSalary)', function () {
            it('should pass')
        });
        describe('setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary)', function () {
            it('should pass')
        });
        describe('removeEmployee(uint256 employeeId)', function () {
            it('should pass')
        });
        describe('setOracle(address oracle)', function () {
            it('should pass')
        });
    })

    describe('Employee Calls', function () {
        describe('determineAllocation(address[] tokens, uint256[] distribution)', function () {
            it('should pass')
        });
        describe('payday(); // only callable once a month', function () {
            it('should pass')
        });
    })

    describe('Oracle Calls', function () {
        describe('setExchangeRate(address token, uint256 usdExchangeRate)', function () {
            it('should pass')
        })
    })

})
