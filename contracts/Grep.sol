pragma solidity 0.5.8;

contract Grep {

    function find(string memory s) public pure returns (bool){
        string memory partten = "a*c";
        uint i = 0;
        uint j = 0;
        while (i < bytes(s).length){
            if(bytes(partten)[0] == bytes(s)[i])
            {
                for(j = i + 1; j < bytes(s).length; j++) 
                {
                    if (bytes(s)[j] == bytes(partten)[0]) 
                    {
                        continue;
                    }
                    else if (bytes(s)[j] == bytes(partten)[2])
                    {
                        return true;
                    }
                    else 
                    {
                        break;
                    }
                }
                i = j + 1;
            }
            else
            {
                i = i + 1;
            }
        }
        return false;
    }
    
    function main_serial(uint _size) public pure {
        // Length of s_repeat is 26.
        string memory s_repeat = "aaaaaaaaaaaaaaaaabaaaaaaaaaaabbbbcdapaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaeaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaacc";

        for (uint i = 0; i < _size; i++){
            find(s_repeat);
        }
    }
    
}