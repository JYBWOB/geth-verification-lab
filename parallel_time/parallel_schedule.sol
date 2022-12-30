pragma solidity ^0.5.8;

contract Schedule
{
    // most fit
    // function scheduleByIndex(uint _size, uint s, uint e) public pure {
    //     uint16[10] memory taskList = [1945, 1492, 1839, 1957, 1315, 2010, 1592, 1090, 1959, 1250];
    //     uint16[10] memory resourceList = [929, 2746, 2534, 3431, 954, 1016, 3747, 2277, 2435, 3225];

    //     for(uint i = s; i < e; i++) 
    //     {
    //       uint mini = 0xffffffff;
    //       uint tvalue = taskList[i % 10];
    //       for(uint j = 0; j < 2 * _size; j++)
    //       {
    //         uint rvalue = resourceList[j % 10];
    //         if(rvalue >= tvalue && rvalue < mini)
    //         {
    //           mini = rvalue;
    //         }
    //       }
    //     }
    // }

    // fitst fit
    // function scheduleByIndex(uint _size, uint s, uint e) public pure {
    //     uint16[10] memory taskList = [1945, 1492, 1839, 1957, 1315, 2010, 1592, 1090, 1959, 1250];
    //     uint16[10] memory resourceList = [929, 2746, 2534, 3431, 954, 1016, 3747, 2277, 2435, 3225];

    //     for(uint i = s; i < e; i++) 
    //     {
    //       uint tvalue = taskList[i % 10];
    //       uint count = 0;
    //       for(uint j = 0; j < 2 * _size; j++)
    //       {
    //         uint rvalue = resourceList[j % 10];
    //         if(rvalue >= tvalue)
    //         {
    //           count += 1;
    //           if(count == i) 
    //           {
    //             break;
    //           }
    //         }
    //       }
    //     }
    // }


    // worst fit
    function scheduleByIndex(uint _size, uint s, uint e) public pure {
        uint16[10] memory taskList = [1945, 1492, 1839, 1957, 1315, 2010, 1592, 1090, 1959, 1250];
        uint16[10] memory resourceList = [929, 2746, 2534, 3431, 954, 1016, 3747, 2277, 2435, 3225];

        for(uint i = s; i < e; i++) 
        {
          uint maxi = 0;
          uint tvalue = taskList[i % 10];
          for(uint j = 0; j < 2 * _size; j++)
          {
            uint rvalue = resourceList[j % 10];
            if(rvalue >= tvalue && rvalue < maxi)
            {
              maxi = rvalue;
            }
          }
        }
    }
    

    function scheduleParallel(uint _size, uint threads) public pure {
        uint step = _size / threads;
        for (uint i = 0; i < threads; i++) {
            uint s = step * i;
            uint e = s + step;
            assembly {
                mstore(600, _size)
                mstore(700, s)
                mstore(800, e)
                mstore(100, 0)
            }
        }
    }
}