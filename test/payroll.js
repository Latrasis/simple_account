var SimpleToken = artifacts.require("zeppelin/token/SimpleToken.sol");
const Payroll = artifacts.require('./Payroll.sol')

contract('Payroll', function (accounts) {

    describe('constructor', async function () {     
        let payroll = await Payroll.deployed();  
        let owner = await payroll.owner.call(accounts[0])      
        assert.equal(owner, accounts[0]);
    })

    describe('Payable Calls', function () {
        describe('Fallback', function () {
            it('should receive tokens', async function () {
                let payroll = await Payroll.deployed();
                return payroll.send(100).then(() => {
                    let balance = Payroll.web3.eth.getBalance(payroll.address);
                    assert.equal(balance, 100);
                })
            })           
        })
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
        describe('addEmployee(address accountAddress, address[] allowedTokens, uint256 dailySalary)', function () {
            it('should add employee iff owner', async function () {
                let payroll = await Payroll.deployed()
                let token = await SimpleToken.new()
                let employee = accounts[1]
                
                return payroll.addEmployee(employee, [token.address], 100)
                    .then(() => payroll.getSalaryOf.call(employee))
                    .then(salary => {
                        assert.equal(salary.toNumber(), 100)
                    })

            })
        });
        describe('setEmployeeSalary(uint256 employeeId, uint256 yearlyUSDSalary)', function () {
            it('should set employee salary employee iff owner', async function () {
                
            })
        });
        describe('removeEmployee(uint256 employeeId)', function () {
            it('should remove employee iff owner', async function () {
                
            })
        });
        describe('setOracle(address oracle)', function () {
            it('should set oracle iff owner', async function () {
                
            })
        });
    })

    describe('Employee Calls', function () {
        describe('determineAllocation(address[] tokens, uint256[] distribution)', function () {
            it('should set a 50%A/50%B allocation if given 1A/1B for a token pair')
            it('should set a 100%A/0%B allocation if given XA/0B for a token pair')
            it('should set a 33%/33%/33% allocation if given 1A/1B/1C for a 3 token tuple')        
        });
        describe('payday()', function () {
            it('should allow to withdraw any token iff is employee')
            describe('if daily limit is $10 with 1A=$1 and 100%A', function () {
                it('should withdraw 0A tokens if less than a day passed')
                it('should withdraw 10A tokens if 1 day passed')
                it('should withdraw 70A tokens if 7 days passed')                
            })
            describe('if daily limit is $10 with 1B=$5 and 100%B', function () {
                it('should withdraw 0B tokens if less than a day passed')
                it('should withdraw 2B tokens if 1 day passed')
                it('should withdraw 14B tokens if 7 days passed')                
            })
            describe('if daily limit is $10 with 1A=$6, 1B=$2, and 50%A/50%B', function () {
                it('should withdraw 0A,0B tokens if less than a day passed')
                it('should withdraw 1A, 2B tokens if 1 day passed')
                it('should withdraw 7A, 14B tokens if 7 days passed')              
            })
        });
    })

    describe('Oracle Calls', function () {
        describe('setExchangeRate(address token, uint256 usdExchangeRate)', function () {
            it('should pass')
        })
    })

})
