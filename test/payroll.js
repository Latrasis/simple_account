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

    describe.skip('Public Calls', function () {
        describe('.getEmployeeCount() constant returns (uint256)', function () {
            it('should give count of employees')
        })
        describe('.getEmployee(uint256 employeeId) constant returns (address employee)', function () {
            it('should get employee by address')
        });
        describe('.calculatePayrollBurnrate() constant returns (uint256)', function () {
            it('should give sum of daily salaries')
        });
        describe('.calculatePayrollRunway() constant returns (uint256)', function () {
            it('should give sum of payed salaries')
        }); 

    })

    describe('Employer Calls', function () {
        describe('addEmployee(address accountAddress, address[] allowedTokens, uint256 dailySalary)', function () {
            it('should add employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]
                
                try {
                    await payroll.addEmployee(employee, [token.address], 100)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 100)
                }
            })
        });
        describe('setEmployeeSalary(address eAddress, uint256 dailySalary)', function () {
            it('should set employee salary employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]

                try {
                    await payroll.addEmployee(employee, [token.address], 100)
                    await payroll.setEmployeeSalary(employee, 172)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 172)
                }
            })
        });
        describe('removeEmployee(address eAddress)', function () {
            it('should remove employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]

                try {
                    await payroll.addEmployee(employee, [token.address], 100)
                    await payroll.setEmployeeSalary(employee, 172)
                    await payroll.removeEmployee(employee)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 0)
                }
            })
        });
        describe('setOracle(address oracle)', function () {
            it('should set oracle iff owner', async function () {
                let payroll = await Payroll.new()
                let oracle = accounts[3]
                try {
                    await payroll.setOracle(oracle)
                } finally {
                    let oracleAddress = await payroll.oracle.call()
                    assert.equal(oracle, oracleAddress)
                }
            })
        });
    })

    describe('Employee Calls', function () {
        describe('setAllocation(address[] tokens, uint256[] distribution)', async function () {

            const payroll = await Payroll.new()
            const tokenA = await SimpleToken.new()
            const tokenB = await SimpleToken.new()
            const employee = accounts[1]

            before( async function() {
                return payroll.addEmployee(employee, [tokenA.address, tokenB.address], 100)
            })

            it('with 100 daily, should set a 50A/50B allocation if given 1A/1B ratio')
            it('with 100 daily, should set a 100A/0%B allocation if given XA/0B ratio')
            it('with 100 daily, should set a 33A/33B/33C allocation if given 1A/1B/1C ratio')
            it('with 10000 daily, should set a 3333A/3333B/3333C allocation if given 1A/1B/1C ratio')       
                   
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
            it('should change exchange rate for a token iff oracle')
        })
    })

})
