pragma solidity 0.5.8;

contract WourdCount {

    function find(string memory s) public pure returns (int ret){
        string memory p = "is";
        string memory q = "it";
        string memory r = "of";
        uint i = 0;
        while (i + 1 < bytes(s).length){
            if (bytes(p)[0] == bytes(s)[i] && bytes(p)[1] == bytes(s)[i+1]){
                ret = ret + 1;
            }
            if (bytes(q)[0] == bytes(s)[i] && bytes(q)[1] == bytes(s)[i+1]){
                ret = ret + 1;
            }
            if (bytes(r)[0] == bytes(s)[i] && bytes(r)[1] == bytes(s)[i+1]){
                ret = ret + 1;
            }
            i = i + 1;
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