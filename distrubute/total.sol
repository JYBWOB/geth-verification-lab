pragma solidity ^0.5.8;

interface ExecContract {
    function exec() external view returns(uint256[2] memory); 
    function exec_part(uint start, uint end) external view returns(uint256[2] memory); 
    // function exec() external; 
    // function exec_part(uint start, uint end) external; 
    function reduction() external;
    function Resource() external view returns(uint); 
}

// contract MatMul is ExecContract
// {
//     uint[100] A = [1,2,3,
//                    4,5,6,
//                    7,8,9];
//     uint[100] B = [9,8,7,
//                    6,5,4,
//                    3,2,1];
//     uint[100] result = [0,0,0,0,0,0,0,0,0];
//     uint N = 3;


//     uint _memory = 4096;
//     uint maxiSplit = 9;

//     function getResult() view public returns(uint[100] memory res) {
//         res = result;
//         return res;
//     }

//     function exec() public {
//         exec_part(0, N * N);
//     }


//     function exec_part(uint start, uint end) public {
//         for(uint i = start; i < end; i++) {
//             uint x = i / N;
//             uint y = i % N;
//             for(uint k = 0; k < N; k++) {
//                 result[i] = result[i] + A[N * x + k] * B[N * k + y];
//             }
//         }
//     }

//     function reduction() public {
//         return;
//     }

//     function Resource() public view returns(uint) {
//         return _memory;
//     }
// }


contract Lpd is ExecContract
{
    // uint256 prime = 98554799767;
    // uint256 prime = 645191; // 769*839
    uint256 prime = 18607; // 23*809
    uint256 x;
    uint256 y;


    uint _memory = 4096;


    function setPrime(uint256 num) public{
        prime = num;
    }

    function exec() public view returns(uint[2] memory) {
        return exec_part(2, prime);
    }

    function sqrt(uint256 x) public pure returns(uint) {
      return x / 2;
      // uint z = (x + 1 ) / 2;
      // uint y = z;
      // while(z < y){
      //   y = z;
      //   z = ( x / z + z ) / 2;
      // }
      // return y;
    }

    function is_prime(uint256 x) public pure returns(bool) {
      for(uint k = 2; k <= sqrt(x); k++) {
        if(x % k == 0) {
          return false;
        }
      }
      return true;
    }


    function exec_part(uint256 start, uint256 end) public view returns(uint256[2] memory res) {
        for(uint256 i = start; i < end; i++) {
            if(!is_prime(i)) {
              continue;
            }
            if(prime % i != 0) {
              continue;
            }
            uint256 j = prime / i;
            if(is_prime(j)) {
              res[0] = i;
              res[1] = j;
              break;
            }
        }
    }

    function reduction() public {
        return;
    }

    function Resource() public view returns(uint) {
        return _memory;
    }
}


library IterableMapInt
{
  struct itmap
  {
    mapping(address => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex; uint value; uint[9] placeholder;}
  struct KeyFlag { address key; bool deleted; }
  function insert(itmap storage self, address key, uint value) public returns (bool replaced)
  {
    uint keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  function remove(itmap storage self, address key) public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
    return true;
  }
  function contains(itmap storage self, address key) public view returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self) public view returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex) public view returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex) public view returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex) view public returns (address key, uint value)
  {
    key = self.keys[keyIndex].key;
    value = self.data[key].value;
  }
}


library IterableMapAddr
{
  struct itmap
  {
    mapping(address => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex; address value; }
  struct KeyFlag { address key; bool deleted; }
  function insert(itmap storage self, address key, address value) public returns (bool replaced)
  {
    uint keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  function remove(itmap storage self, address key) public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
    return true;
  }
  function contains(itmap storage self, address key) public view returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self) public view returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex) public view returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex) public view returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex) view public returns (address key, address value)
  {
    key = self.keys[keyIndex].key;  
    value = self.data[key].value;
  }
  function iterate_get_by_key(itmap storage self, address key) view public returns (address value)
  {
    value = self.data[key].value;
  }
}

library IterableMapTask
{
  struct itmap
  {
    mapping(address => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct TaskParam
  {
    address task;
    uint value;
    uint start;
    uint end;
  }
  struct IndexValue { uint keyIndex; TaskParam param; }
  struct KeyFlag { address key; bool deleted; }
  function insert(itmap storage self, address key, address task, uint value, uint start, uint end) public returns (bool replaced)
  {
    uint keyIndex = self.data[key].keyIndex;
    if(task == address(0)) {
      task = key;
    }
    self.data[key].param = TaskParam(task, value, start, end);
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  function remove(itmap storage self, address key) public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
    return true;
  }
  function contains(itmap storage self, address key) public view returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self) public view returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex) public view returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex) public view returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex) view public returns (address key, address task, uint value, uint start, uint end)
  {
    key = self.keys[keyIndex].key;
    task = self.data[key].param.task;
    value = self.data[key].param.value;
    start = self.data[key].param.start;
    end = self.data[key].param.end;
  }

  function iterate_get_by_key(itmap storage self, address key) view public returns (address task, uint value, uint start, uint end)
  {
    task = self.data[key].param.task;
    value = self.data[key].param.value;
    start = self.data[key].param.start;
    end = self.data[key].param.end;
  }
}

library IterableMapAddrList
{
  struct itmap
  {
    mapping(address => IndexValue) data;
    KeyFlag[] keys;
    uint size;
  }
  struct IndexValue { uint keyIndex; address[10] value; }
  struct KeyFlag { address key; bool deleted; }
  function insert(itmap storage self, address key, address[10] memory value) public returns (bool replaced)
  {
    uint keyIndex = self.data[key].keyIndex;
    for(uint i = 0; i < 10; i++) {
      self.data[key].value[i] = value[i];
    }
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  function remove(itmap storage self, address key) public returns (bool success)
  {
    uint keyIndex = self.data[key].keyIndex;
    if (keyIndex == 0)
      return false;
    delete self.data[key];
    self.keys[keyIndex - 1].deleted = true;
    self.size --;
    return true;
  }
  function contains(itmap storage self, address key) public view returns (bool)
  {
    return self.data[key].keyIndex > 0;
  }
  function iterate_start(itmap storage self) public view returns (uint keyIndex)
  {
    return iterate_next(self, uint(-1));
  }
  function iterate_valid(itmap storage self, uint keyIndex) public view returns (bool)
  {
    return keyIndex < self.keys.length;
  }
  function iterate_next(itmap storage self, uint keyIndex) public view returns (uint r_keyIndex)
  {
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  function iterate_get(itmap storage self, uint keyIndex) view public returns (address key, address[10] memory value)
  {
    key = self.keys[keyIndex].key;  
    for(uint i = 0; i < 10; i++) {
      value[i] = self.data[key].value[i];
    }
  }
  function iterate_get_by_key(itmap storage self, address key) view public returns (address[10] memory value)
  {
    for(uint i = 0; i < 10; i++) {
      value[i] = self.data[key].value[i];
    }
  }
}


contract Schedule
{
    IterableMapTask.itmap tasks;

    IterableMapInt.itmap resources;
    
    IterableMapAddrList.itmap pending;

    IterableMapTask.itmap distrubute;

    function getResourceAddr() public view returns (address[5] memory keys, uint[5] memory values) {
        uint index = 0;
        for (uint i = IterableMapInt.iterate_start(resources); IterableMapInt.iterate_valid(resources, i); i = IterableMapInt.iterate_next(resources, i))
        {
            (address key, uint256 value) = IterableMapInt.iterate_get(resources, i);
            keys[index] = key;
            values[index] = value;
            index = index + 1;
            if(index == 5) {
                break;
            }
        }
    }

    function getTaskAddr() public view returns (address[5] memory keys, uint[5] memory values, uint[5] memory starts, uint[5] memory ends) {
        uint index = 0;
        for (uint i = IterableMapTask.iterate_start(tasks); IterableMapTask.iterate_valid(tasks, i); i = IterableMapTask.iterate_next(tasks, i))
        {
            (address key, address task, uint value, uint start, uint end)  = IterableMapTask.iterate_get(tasks, i);
            keys[index] = key;
            values[index] = value;
            starts[index] = start;
            ends[index] = end;
            index = index + 1;
            if(index == 5) {
                break;
            }
        }
    }

    function getSchedule(address cs) public view returns (address _addr, uint _memory, uint start, uint end) {
        (_addr, _memory, start, end) = IterableMapTask.iterate_get_by_key(distrubute, cs);
    }

    function schedule() public {
        for (uint i = IterableMapTask.iterate_start(tasks); IterableMapTask.iterate_valid(tasks, i); i = IterableMapTask.iterate_next(tasks, i))
        {
            (address tkey, address taddr, uint tvalue, uint start, uint end) = IterableMapTask.iterate_get(tasks, i);
            if(tvalue == 0) 
            {
                continue;
            }
            address[10] memory distributeList;
            uint[10] memory valueList;
            uint[10] memory startList;
            uint[10] memory endList;
            uint index = 0;
            uint len = end - start;
            for (uint j = IterableMapInt.iterate_start(resources); IterableMapInt.iterate_valid(resources, j); j = IterableMapInt.iterate_next(resources, j))
            {
                (address rkey, uint256 rvalue) = IterableMapInt.iterate_get(resources, j);
                if(rvalue == 0) 
                {
                    continue;
                }
                uint callen = len * rvalue / tvalue;
                if(start + callen > end)
                {
                  callen = end - start;
                }
                distributeList[index] = rkey;
                valueList[index] = callen * tvalue / len;
                startList[index] = start;
                endList[index] = start + callen;
                index += 1;
                start += callen;
                if(start == end) {
                  break;
                }
            }
            if(start == end) {
              for(uint j = 0; j < index; j++) {
                IterableMapTask.insert(distrubute, distributeList[j], taddr, valueList[j], startList[j], endList[j]);
                IterableMapInt.insert(resources, distributeList[j], 0);
              }
              IterableMapAddrList.insert(pending, taddr, distributeList);
              IterableMapTask.insert(tasks, tkey, tkey, 0, end, end);
            }
        }
    }


    function addResource(address cs, uint _memory) public {
        IterableMapInt.insert(resources, cs, _memory);
    }

    function requests(address addr, uint _memory, uint start, uint end) public {
        IterableMapTask.insert(tasks, addr, addr, _memory, start, end);
    }
    
    function done(address cs, address taddr) public {
        // 资源信息
        IterableMapInt.remove(resources, cs);
        // 删除为CS分配的任务信息
        IterableMapTask.remove(distrubute, cs);
        // taddr任务的执行者列表，删除其中的cs
        address[10] memory distributeList = IterableMapAddrList.iterate_get_by_key(pending, taddr);
        if(distributeList[9] == cs) {
          distributeList[0] == address(0);
        }
        else {
          uint j = 0;
          for(j = 0; j < 9; j++) {
            if(distributeList[j] == cs) {
              break;
            }
          }
          for(; j < 8; j++) {
            distributeList[j] = distributeList[j + 1];
          }
          IterableMapAddrList.insert(pending, taddr, distributeList);
        }
        // 如果执行者列表为空，则删除任务信息
        if(distributeList[0] == address(0)) {
          IterableMapTask.remove(tasks, taddr);
        }
    }

}


// contract CServer {
//     IterableMapInt.itmap resources;
//     IterableMapAddr.itmap distrubute;
//     Schedule sc;
        
//     function addResource(address cc, uint _memory) public{
//         IterableMapInt.insert(resources, cc, _memory);
//         joinToGlobal(sc);
//     }
    
//     function joinToGlobal(Schedule _sc) public {
//         sc = _sc;
//         uint sumMem = 0;
//         for (uint i = IterableMapInt.iterate_start(resources); IterableMapInt.iterate_valid(resources, i); i = IterableMapInt.iterate_next(resources, i))
//         {
//             (address key, uint256 value)  = IterableMapInt.iterate_get(resources, i);
//             sumMem += value;
//         }
//         sc.addResource(address(this), sumMem);
//     }
    
//     function schedule() public {
//         if (sc == Schedule(0x0))
//             return;
//         address task = sc.getSchedule(address(this));
//         if (task == address(0x0))
//             return;
//         ExecContract execContract = ExecContract(task);
//         uint _memory = execContract.Resource();
//         for (uint i = IterableMapInt.iterate_start(resources); IterableMapInt.iterate_valid(resources, i); i = IterableMapInt.iterate_next(resources, i))
//         {
//             (address rkey, uint256 rvalue)  = IterableMapInt.iterate_get(resources, i);
//             if(rvalue > _memory) {
//                 IterableMapAddr.insert(distrubute, rkey, task);
//                 IterableMapInt.insert(resources, rkey, 0);
//                 break;
//             }
//         }
//     }
    
//     function getSchedule(address cc) public view returns (address) {
//         return IterableMapAddr.iterate_get_by_key(distrubute, cc);
//     }
    
//     function done(address cc) public {
//         address taddr = IterableMapAddr.iterate_get_by_key(distrubute, cc);
//         IterableMapInt.remove(resources, cc);
//         IterableMapAddr.remove(distrubute, cc);
//         sc.done(address(this), taddr);
//         joinToGlobal(sc);
//     }
    
//     function getTaskAddr() public view returns (address[5] memory keys, address[5] memory values) {
//         uint index = 0;
//         for (uint i = IterableMapAddr.iterate_start(distrubute); IterableMapAddr.iterate_valid(distrubute, i); i = IterableMapAddr.iterate_next(distrubute, i))
//         {
//             (address key, address value) = IterableMapAddr.iterate_get(distrubute, i);
//             keys[index] = key;
//             values[index] = value;
//             index = index + 1;
//             if(index == 5) {
//                 break;
//             }
//         }
//     }

//     // function getTaskAddr() public view returns (address[1] memory keys, uint[1] memory values) {
//     //     keys[0] = sc.getSchedule(address(this));
//     //     ExecContract execContract = ExecContract(keys[0]);
//     //     values[0] = execContract.Resource();
//     // }
    
//     function getResourceAddr() public view returns (address[5] memory keys, uint[5] memory values) {
//         uint index = 0;
//         for (uint i = IterableMapInt.iterate_start(resources); IterableMapInt.iterate_valid(resources, i); i = IterableMapInt.iterate_next(resources, i))
//         {
//             (address key, uint256 value) = IterableMapInt.iterate_get(resources, i);
//             keys[index] = key;
//             values[index] = value;
//             index = index + 1;
//             if(index == 5) {
//                 break;
//             }
//         }
//     }
// }


contract ResourceDetect
{
    function getRestResource() public view returns (uint p) {
        assembly {
            let t := mload(0x40)
            if iszero(staticcall(9999999, 0x13, t, 0x00, t, 0x20)) {
                revert(0,0)
            }
            p := mload(t)
            p := 0x1000
        }
    }
}