pragma solidity ^0.5.8;

contract KVstore {

  mapping(string=>string) store;

  function get(string memory key, int getNumber) public returns(string memory) {
    string memory temp = "";
    for (int i = 0; i < getNumber; i++){
        temp = store[key];
    }
    store[key] = temp;
    return temp;
  }

  function set(string memory key, string memory value, int setNumber) public {
    for (int i = 0; i < setNumber; i++){
        store[key] = value;
    }
  }
}
