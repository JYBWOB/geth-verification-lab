pragma solidity 0.5.8;

contract InvertedIndex {

    function find(string memory s) public pure returns(bool) {
        string memory p = "freshness";
        uint i = 0;
        while (i + 8 < bytes(s).length){
			bool flag = true;
			for (uint j = 0; j < 9; j++) {
				if (bytes(p)[j] != bytes(s)[i + j]) {
					flag = false;
					break;
				}
			}
			if (flag) {
				return true;
			}
            i = i + 1;
        }
        return false;
    }
    
    function main_serial(uint _size) public pure {
        string memory s_repeat = "Youth is not a time of life; it is a state of mind; it is not a matter of rosy cheeks, red lips and supple knees; it is a matter of the will, a quality of the imagination, a vigor of the emotions; it is the freshness of the deep springs of life.";

        for (uint i = 0; i < _size; i++){
            find(s_repeat);
        }
    }
    
}