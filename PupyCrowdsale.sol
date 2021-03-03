pragma solidity ^0.5.5;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract PupperCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    using SafeMath for uint;

    constructor(
        uint rate,            // rate, in TKNbits
        address payable wallet,  // wallet to send Ether
        ERC20 token, 
        uint goal,
        uint cap,             // total cap, in wei
        uint openingTime,     // opening time in unix epoch seconds
        uint closingTime      // closing time in unix epoch seconds
    )
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        Crowdsale(rate, wallet, token)
        RefundableCrowdsale(goal)
        public
    {
        
        // nice, we just created a crowdsale that's only open
        // for a certain amount of time
        // and stops accepting contributions once it reaches `cap`
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    uint goal = 500;
    uint cap = 5000;

    constructor(string memory name, string memory symbol, address payable wallet) public {
        PupperCoin token = new PupperCoin (name, symbol, 0);
        token_address = address(token);

        PupperCoinCrowdsale puppercoinsale = new PupperCoinCrowdsale(1, wallet, token, goal, cap, now, now + 4 minutes);
        token_sale_address = address(puppercoinsale);
        
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}