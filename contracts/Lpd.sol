pragma solidity ^0.5.8;

contract Lpd
{
    // uint256 prime = 98554799767;
    uint256 prime = 645191; // 769*839
    // uint256 prime = 18607; // 23*809
    uint256 x;
    uint256 y;


    uint _memory = 4096;


    function setPrime(uint256 num) public{
        prime = num;
    }

    function exec() public view returns(uint[2] memory) {
        return exec_part(2, prime);
    }

    function sqrt(uint256 _x) public pure returns(uint) {
      return _x / 2;
      // uint z = (x + 1 ) / 2;
      // uint y = z;
      // while(z < y){
      //   y = z;
      //   z = ( x / z + z ) / 2;
      // }
      // return y;
    }

    function is_prime(uint256 _x) public pure returns(bool) {
      for(uint k = 2; k <= sqrt(_x); k++) {
        if(_x % k == 0) {
          return false;
        }
      }
      return true;
    }


    function exec_part(uint256 start, uint256 end) public view returns(uint256[2] memory res) {
        for(uint256 i = start; i < end; i++) {
            if(!is_prime(i)) {
              continue;
            }
            if(prime % i != 0) {
              continue;
            }
            uint256 j = prime / i;
            if(is_prime(j)) {
              res[0] = i;
              res[1] = j;
              break;
            }
        }
    }
}