var SimpleAccount = artifacts.require("./SimpleAccount.sol");
var SimpleToken = artifacts.require("zeppelin/token/SimpleToken.sol");

contract('SimpleAccount', function (accounts) {

    describe('constructor', function () {
        return SimpleAccount.deployed()
            .then(function (simpleAccount) {
                return simpleAccount.owner.call(accounts[0]);
            }).then(function (owner) {
                assert.equal(owner, accounts[0]);
            });
    })

    describe('.transfer(address token, address to, uint amount)', function () {

        it('should transfer token iff owner', function () {
            return Promise.all([SimpleToken.new(), SimpleAccount.deployed()])
                .then(([token, simpleAccount]) => {

                    // Transfer 100 Tokens To Simple Account
                    let start = token.transfer(simpleAccount.address, 100)
                        // Check Token Balance
                        .then(() => token.balanceOf.call(simpleAccount.address))
                        .then(balance => {
                            assert.equal(balance, 100)
                        });

                    // Transfer Token to Account 2
                    let transfer = start.then(() => simpleAccount.transfer(token.address, accounts[1], 90))

                    // Then get Balance and Check
                    return transfer
                        .then(() => Promise.all([
                            token.balanceOf.call(simpleAccount.address),
                            token.balanceOf.call(accounts[1])
                        ]))
                        .then(([balance_10, balance_90]) => {
                            assert.equal(balance_10, 10)
                            assert.equal(balance_90, 90)
                        })
                })
        })
        it('should not transfer token, if not owner', function () {
            return Promise.all([SimpleToken.new({from: accounts[0]}), SimpleAccount.deployed()])
                .then(([token, simpleAccount]) => {
                    // Transfer 100 Tokens To Simple Account
                    let start = token.transfer(simpleAccount.address, 100, { from: accounts[0] })
                        // Check Token Balance
                        .then(() => token.balanceOf.call(simpleAccount.address))
                        .then(balance => {
                            assert.equal(balance, 100)
                        });

                    // Try to Transfer Token to Account 2 by Non-Owner
                    let transfer = start.then(() => simpleAccount.transfer.call(token.address, accounts[2], 90), { from: accounts[2] })

                    // Then get Balance and Check
                    return transfer
                        .then(() => Promise.all([
                            token.balanceOf.call(simpleAccount.address),
                            token.balanceOf.call(accounts[2])
                        ]))
                        .then(([balance_100, balance_0]) => {
                            assert.equal(balance_100, 100)
                            assert.equal(balance_0, 0)
                        })

                })

        })
    })

    describe('.withdraw(uint amount)', function () {

        it('should withdraw to owner', function () {
            return SimpleAccount.new()
                .then(simpleAccount => {
                    // Send 1 Ether To Simple Contract
                    let start = simpleAccount.send(100)

                    // Withdraw 10 Wei to owner
                    let afterTransfer = start.then(() => simpleAccount.withdraw(10))

                    // Check
                    return afterTransfer.then(() => {
                        let balance_90 = web3.eth.getBalance(simpleAccount.address).toNumber()
                        assert.equal(balance_90, 90)
                    })

                })
        })
        it('should not withdraw if not owner', function () {
            return SimpleAccount.deployed()
                .then(simpleAccount => {
                    // Send 1 Ether To Simple Contract
                    let start = simpleAccount.send(100)

                    // Try to Invalidly Withdraw 10 Wei to owner
                    let afterTransfer = start.then(() => simpleAccount.withdraw.call(10, {from: accounts[1]}))

                    // Check
                    return afterTransfer.catch(err => {
                        let balance_100 = web3.eth.getBalance(simpleAccount.address).toNumber()
                        assert.equal(balance_100, 100)
                    })
                })
        })

    })

})
