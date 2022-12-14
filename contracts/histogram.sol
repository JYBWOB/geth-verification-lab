pragma solidity 0.8.12;

contract Histogram {

    uint T = 0;

    function find(uint8[10] memory arr, uint s, uint e) public returns (int ret){
        ret = 0;
        for(uint i = 0; i < arr.length; i++) {
            if (arr[i] >= s && arr[i] < e) {
                ret += 1;
            }
        }
        return ret;
    }

    function sub_func() public {
        uint8[10] memory arr = [9, 0, 8, 1, 7, 2, 6, 3, 5, 4];

        for (uint i = 0; i < T; i++){
            find(arr, 4, 7);
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
        uint8[10] memory arr = [9, 0, 8, 1, 7, 2, 6, 3, 5, 4];

        for (uint i = 0; i < _size; i++){
            find(arr, 4, 7);
        }
    }
    
}