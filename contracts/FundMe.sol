// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    AggregatorV3Interface internal priceFeed;

    address public owner;

    uint256 minimumAmount;

    address[] public funders;

    mapping(address => uint256) public addressToAmountFunded;

    constructor(){
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }
    modifier onlyOwner{
       require(msg.sender == owner);
        _;
    }
    function fund() public payable {
        minimumAmount = 50 *10 **18;
        require(msg.value >= minimumAmount, "You need to deposit  more ether");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);

    }
        //function to get the version of the chainlink pricefeed
    function getVersion() public view returns (uint256){
        
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256) {
        (,int answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10 **10 );
    }
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
    function withdraw() payable onlyOwner public {
        // only owner modifier
        payable(msg.sender).transfer(address(this).balance);
        // msg.sender.transfer(address.(this).balance);
        
        for (uint256 fundersIndex = 0 ; fundersIndex< funders.length; fundersIndex ++ ){
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }

         //funders array will be initialized to 0
        funders = new address[](0);

    }
}