pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleAccount.sol";
import "zeppelin/token/SimpleToken.sol";

contract TestSimpleAccount {

  function testTransferToken() {
    SimpleAccount account = new SimpleAccount();
    SimpleToken token = new SimpleToken();

    // Transfer 100 tokens to Account
    token.transfer(address(account), 100);
    Assert.equal(token.balanceOf(address(account)), 100, "Account should have 100 Tokens");

    // Transfer 10 Tokens from Account to Sample Address (msg.sender)
    account.transfer(address(token), msg.sender, 10);
    Assert.equal(token.balanceOf(address(account)), 90, "Account should have 90 Tokens");

  }

}
