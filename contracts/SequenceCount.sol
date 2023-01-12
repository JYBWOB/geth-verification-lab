pragma solidity 0.5.8;

contract SequenceCount {

    function find(string memory s) public pure returns (int ret){
        string memory p = "the";
        string memory q = "freshness";
        string memory r = "of";
        ret = 0;
        uint i = 0;
        uint base = 0;
        while (base + 17 <= bytes(s).length){
            i = base;
            bool flag = true;
            for(uint j = 0; flag && j < 3; j++) {
                if (bytes(p)[j] != bytes(s)[i + j]) {
                    flag = false;
                }
            }
            i = i + 4;
            for(uint j = 0; flag && j < 9; j++) {
                if (bytes(q)[j] != bytes(s)[i + j]) {
                    flag = false;
                }
            }
            i = i + 10;
            for(uint j = 0; flag && j < 2; j++) {
                if (bytes(r)[j] != bytes(s)[i + j]) {
                    flag = false;
                }
            }
            i = i + 3;
            if(flag) {
                ret = 1;
                break;
            }
            base = base + 1;
        }
        return ret;
    }
    
    function main_serial(uint _size) public pure {
        // Length of s_repeat is 26.
        string memory s_repeat = "Youth is not a time of life; it is a state of mind; it is not a matter of rosy cheeks, red lips and supple knees; it is a matter of the will, a quality of the imagination, a vigor of the emotions; it is the freshness of the deep springs of life.";

        for (uint i = 0; i < _size; i++){
            find(s_repeat);
        }
    }
    
}