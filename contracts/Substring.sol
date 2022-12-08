pragma solidity 0.8.12;

contract Substring {

    uint T = 0;

    function find(string memory p, string memory s) public returns (int ret){
        uint i = 0;
        while (i + 2 < bytes(s).length){
            if (bytes(p)[0] == bytes(s)[i] && bytes(p)[1] == bytes(s)[i+1] && bytes(p)[2] == bytes(s)[i+2]){
                ret = ret + 1;
            }
            i = i + 1;
        }
        return ret;
    }

    function sub_func() public {
        string memory p = "xxx";
        // Length of s_repeat is 26.
        string memory s_repeat = "abcdefghijklmnopqrstuvwxxx";
        // parallel here
        for (uint i = 0; i < T; i++) {
            find(p, s_repeat);
        }
    }

    function main_parallel(uint _size, uint _thread) public {
        // parallel here!
        T = _size / _thread;
        for(uint i = 0; i < _thread; i++) {
            assembly {
                mstore(100, 0)
            }
        }
    }

    function main_serial(uint _size) public {
        string memory p = "xxx";
        // Length of s_repeat is 26.
        string memory s_repeat = "abcdefghijklmnopqrstuvwxxx";

        for (uint i = 0; i < _size; i++){
            find(p, s_repeat);
        }
    }
    
}