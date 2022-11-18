pragma solidity ^0.5.8;

contract Fib
{

    uint256 [300]result;  

    function exec(uint thread, uint256 n) public{
        if(n == 0 || n == 1) {
          result[thread] = 1;
          return;
        }
        uint256 x = 1;
        uint256 y = 1;
        uint256 z = 0;
        for(uint256 i = 2; i < n; i++) {
          z = x + y;
          x = y;
          y = z;
        }
        result[thread] = z;
        return;
    }
}
