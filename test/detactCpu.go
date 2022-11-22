package main 

import (
	"github.com/shirou/gopsutil/v3/cpu"
	"fmt"
)

func main() {
	count, _ := cpu.Counts(true)
	fmt.Println(count)
	percent, _ := cpu.Percent(0, true)
	fmt.Println(percent)
}