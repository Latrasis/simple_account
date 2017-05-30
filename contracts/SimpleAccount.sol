pragma solidity ^0.4.8;


import "zeppelin/token/ERC20Basic.sol";
import "zeppelin/lifecycle/TokenDestructible.sol";
import "zeppelin/ownership/Ownable.sol";

/// A Very Simple Account for Managing Eth and Token Payments
contract SimpleAccount is TokenDestructible {
    
    //// Events
    event Paycheck(address sender, uint amount, uint timestamp);
    event Withdrawal(address receiver, uint amount, uint timestamp);

    //// External
    function () payable {
        Paycheck(msg.sender, msg.value, now);
    }

    /// @dev Transfer ERC20 Token
    function transfer(address token, address to, uint value) external onlyOwner {
        ERC20Basic(token).transfer(to, value);
    }

    /// @dev Withdraw Eth to Owner
    function withdraw(uint amount) external onlyOwner {
        if (this.balance < amount) throw;
        owner.transfer(amount);
        Withdrawal(owner, amount, now);
    }

}