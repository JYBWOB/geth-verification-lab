pragma solidity 0.5.8;

contract Matrix {
    
    uint size = 0;

    function matrixMul() public view {
        int[200][200] memory m1;
        int[200][200] memory m2;
        int[200][200] memory res;
        for (uint i = 0; i < size; i++){
            for (uint j = 0; j < size; j++){
                for (uint k = 0; k < size; k++){
                    res[i][j] = m1[i][k] * m2[k][j];
                }
            }
        }
    }

    function MatrixMul(uint _count, uint _size) public {
        size = _size;
        for (uint i = 0; i < _count; i++){
            matrixMul();
        }
    }

    function MatrixMulParallel(uint _count, uint _size) public {
        size = _size;
        for (uint i = 0; i < _count; i++){
            assembly {
                mstore(100, 0)
            }
        }
    }
}