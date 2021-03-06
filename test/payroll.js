const debug = require('debug')
const assert = require('assert')

const SimpleToken = artifacts.require("zeppelin/token/SimpleToken.sol");
const Payroll = artifacts.require('./Payroll.sol')
const testDebug = debug('test:payroll')

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
        describe('.addEmployee(address accountAddress, address[] allowedTokens, uint256[] distribution, uint256 dailySalary)', function () {
            it('should add employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]
                
                try {
                    await payroll.addEmployee(employee, [token.address], [1], 100)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 100)
                }
            })
        });
        describe('.setEmployeeSalary(address eAddress, uint256 dailySalary)', function () {
            it('should set employee salary employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]

                try {
                    await payroll.addEmployee(employee, [token.address], [1], 100)
                    await payroll.setEmployeeSalary(employee, 172)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 172)
                }
            })
        });
        describe('.removeEmployee(address eAddress)', function () {
            it('should remove employee iff owner', async function () {
                let payroll = await Payroll.new()
                let token = await SimpleToken.new()
                let employee = accounts[1]

                try {
                    await payroll.addEmployee(employee, [token.address], [1], 100)
                    await payroll.setEmployeeSalary(employee, 172)
                    await payroll.removeEmployee(employee)
                } finally {
                    let salary = await payroll.getSalaryOf.call(employee)
                    assert.equal(salary.toNumber(), 0)
                }
            })
        });
        describe('.setOracle(address oracle)', function () {
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
        describe('.setAllocation(address[] tokens, uint256[] distribution)', function () {

            let payroll = false
            let tokenA = false
            let tokenB = false
            let tokenC = false            
            let employee = accounts[1]

            before(async function() {
                payroll = await Payroll.new()
                tokenA = await SimpleToken.new()
                tokenB = await SimpleToken.new()
                tokenC = await SimpleToken.new()                
                return payroll.addEmployee(employee, [tokenA.address, tokenB.address], [1, 1], 100)
            })
            
            it('with 100 daily, should set a 50A/50B allocation if given 1A/1B ratio', async function () {
                try {
                    await payroll.setAllocation([tokenA.address, tokenB.address], [1, 1], {from: employee})
                } finally {
                    let [,salaryA] = await payroll.getAllocationOf.call(employee, tokenA.address)
                    let [,salaryB] = await payroll.getAllocationOf.call(employee, tokenB.address)

                    assert.equal(salaryA.toNumber(), 50)
                    assert.equal(salaryB.toNumber(), 50)
                }
            })
            it('with 100 daily, should set a 100A/0%B allocation if given XA/0B ratio', async function () {
                try {
                    await payroll.setAllocation([tokenA.address, tokenB.address], [1, 0], {from: employee})
                } finally {
                    let [,salaryA] = await payroll.getAllocationOf.call(employee, tokenA.address)
                    let [,salaryB] = await payroll.getAllocationOf.call(employee, tokenB.address)

                    assert.equal(salaryA.toNumber(), 100)
                    assert.equal(salaryB.toNumber(), 0)
                }
            })
            it('with 100 daily, should set a 33A/33B/33C allocation if given 1A/1B/1C ratio', async function () {
                try {
                    await payroll.setAllocation([tokenA.address, tokenB.address, tokenC.address], [1, 1, 1], {from: employee})
                } finally {
                    let [,salaryA] = await payroll.getAllocationOf.call(employee, tokenA.address)
                    let [,salaryB] = await payroll.getAllocationOf.call(employee, tokenB.address)
                    let [,salaryC] = await payroll.getAllocationOf.call(employee, tokenC.address)
                    
                    assert.equal(salaryA.toNumber(), 33)
                    assert.equal(salaryB.toNumber(), 33)
                    assert.equal(salaryC.toNumber(), 33)
                    
                }
            })
            it('with 10000 daily, should set a 3333A/3333B/3333C allocation if given 1A/1B/1C ratio', async function () {
                try {
                    await payroll.setEmployeeSalary(employee, 10000)
                    await payroll.setAllocation([tokenA.address, tokenB.address, tokenC.address], [1, 1, 1], {from: employee})
                } finally {
                    let [,salaryA] = await payroll.getAllocationOf.call(employee, tokenA.address)
                    let [,salaryB] = await payroll.getAllocationOf.call(employee, tokenB.address)
                    let [,salaryC] = await payroll.getAllocationOf.call(employee, tokenC.address)
                    
                    assert.equal(salaryA.toNumber(), 3333)
                    assert.equal(salaryB.toNumber(), 3333)
                    assert.equal(salaryC.toNumber(), 3333)
                    
                }
            })       
                   
        });
    })

    describe('Oracle Calls', function () {
        describe('setExchangeRate(address token, uint256 usdExchangeRate)', function () {
            let payroll = false
            let tokenA = false
            let tokenB = false
            let tokenC = false            
            let employee = accounts[1]

            before(async function() {
                payroll = await Payroll.new()
                tokenA = await SimpleToken.new()
                tokenB = await SimpleToken.new()
                tokenC = await SimpleToken.new()                
                return payroll.setOracle(employee)
            })

            it('should change exchange rate for a token iff oracle', async function() {
                try {
                    await payroll.setExchangeRate([tokenA.address, tokenB.address], [3,4], {from: oracle})
                } finally {
                    let valueOfA = await payroll.tokenUSDValueOf.call(tokenA.address)
                    let valueOfB = await payroll.tokenUSDValueOf.call(tokenB.address)
                    assert.equal(valueOfA, 3)
                    assert.eqaual(valueOfB, 4)
                }
            })
        })
    })

})
