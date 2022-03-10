// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{

    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }
    function sfStore(uint256 _index, uint256 _number) public {
        SimpleStorage(address(simpleStorageArray[_index])).store(_number);
    }
    function stGet(uint256 _index) public view returns(uint256){
        return SimpleStorage(address(simpleStorageArray[_index])).retrieve();
    }
}