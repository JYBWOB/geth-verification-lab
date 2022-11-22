package main

import (
	"encoding/json"
	"fmt"
	"os"
)

/**
json解码为go
*/
func main() {
	data, err := os.ReadFile("./config.json")
	if err != nil {
		fmt.Println("json 文件打开失败")
	}

	mMap := make(map[string][]int)
	err = json.Unmarshal(data, &mMap)
	if err != nil {
		fmt.Println("json Unmarshal 失败")
	}
	fmt.Println(mMap["thread"])
	fmt.Println(mMap["step"])
}

