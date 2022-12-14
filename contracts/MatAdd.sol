pragma solidity 0.5.8;

contract Matrix {
    
    uint size = 0;

    function matrixAdd() public view {
        int[210][210] memory m1;
        int[210][210] memory m2;
        int[210][210] memory res;
        for (uint i = 0; i < size; i++){
            for (uint j = 0; j < size; j++){
                res[i][j] = m1[i][j] + m2[i][j];
            }
        }
    }

    function MatrixAdd(uint _count, uint _size) public {
        size = _size;
        for (uint i = 0; i < _count; i++){
            matrixAdd();
        }
    }

    function MatrixAddParallel(uint _count, uint _size) public {
        size = _size;
        for (uint i = 0; i < _count; i++){
            assembly {
                mstore(100, 0)
            }
        }
    }
}