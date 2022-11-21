pragma solidity ^0.5.8;

contract Sorter {

    uint succeed = 0;
    
    function sort(uint size) public {
        uint[] memory data = new uint[](size);
        for (uint x = 0; x < data.length; x++) {
            data[x] = size-x;
        }
        
        for(uint i = 1; i < size; i++) {
            for(uint j = 0; j < size - i; j++) {
                if(data[j] > data[j + 1]) {
                    (data[j], data[j + 1]) = (data[j + 1], data[j]);
                }
            }
        }

        succeed = 1;
    }

}
