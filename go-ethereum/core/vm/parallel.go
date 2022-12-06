// Copyright 2014 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package vm

import(
	"fmt"
	// "sync/atomic"
	"github.com/ethereum/go-ethereum/common/math"
)

func paraRun(contract *Contract, pc uint64, input []byte, in *EVMInterpreter) {
	/*
	parallelGroup := in.parallelGroup
	var myPtr uint64
	for {
		// if unlock
		if parallelGroup.lock == 0 {
			// require lock
			parallelGroup.lock = 1
			// do something
			parallelGroup.group[parallelGroup.ptr] = 1
			myPtr = parallelGroup.ptr
			parallelGroup.ptr = parallelGroup.ptr + 1
			// release lock
			parallelGroup.lock = 0
			break
		}
	}*/
	
	defer in.wg.Done()

	// atomic.AddInt32(&in.output_flag, 1)
	
	//fmt.Println("Sub thread input is ", input)

	var (
		op          OpCode        // current opcode
		mem = NewMemory()
		stack = newstack()
		callContext = &ScopeContext{
			Memory:   mem,
			Stack:    stack,
			Contract: contract,
		}
		// For optimisation reason we're using uint64 as the program counter.
		// It's theoretically possible to go above 2^64. The YP defines the PC
		// to be uint256. Practically much less so feasible.
		err error
		res     []byte // result of the opcode execution function
		//pc = uint64(0)
	)
	
	contract.Input = input
	
	for {
	
		op = contract.GetOp(pc)
		operation := in.cfg.JumpTable[op]

		if operation.dynamicGas != nil {
			// All ops with a dynamic memory usage also has a dynamic gas cost.
			var memorySize uint64
			// calculate the new memory size and expand the memory to fit
			// the operation
			// Memory check needs to be done prior to evaluating the dynamic gas portion,
			// to detect calculation overflows
			if operation.memorySize != nil {
				memSize, overflow := operation.memorySize(stack)
				if overflow {
					fmt.Println("1 overflow!")
				}
				// memory is expanded in words of 32 bytes. Gas
				// is also calculated in words.
				if memorySize, overflow = math.SafeMul(toWordSize(memSize), 32); overflow {
					fmt.Println("2 overflow!")
				}
			}
			// Consume the gas and return an error if not enough gas is available.
			// cost is explicitly set so that the capture state defer method can get the proper cost
			/*
			var dynamicCost uint64
			dynamicCost, err = operation.dynamicGas(in.evm, contract, stack, mem, memorySize)
			if err != nil || !contract.UseGas(dynamicCost) {
				fmt.Println("3 out of gas!")
			}*/
			if memorySize > 0 {
				mem.Resize(memorySize)
			}
		}

		res, err = operation.execute(&pc, in, callContext)
		_ = res
		if err != nil {
			break
		}
		pc++
	}
	if err == errStopToken {
		err = nil // clear stop token error
	}

	//fmt.Println("Sub thread result is ", res)
}