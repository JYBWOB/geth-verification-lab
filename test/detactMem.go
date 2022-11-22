package main 

import (
	"github.com/shirou/gopsutil/mem"
	"fmt"
)

func main() {
	info, _ := mem.VirtualMemory()
	fmt.Println(info)
	info2, _ := mem.SwapMemory()
	fmt.Println(info2)
}