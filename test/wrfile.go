package main

import (
	"os"
	"fmt"
	"bufio"
	"io"
)

func main() {
    //创建一个新文件，写入内容
    filePath := "./output.txt"
    writer, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE, 0666)
    if err != nil {
        fmt.Printf("打开文件错误= %v \n", err)
        return
    }
    //写入时，使用带缓存的 *Writer
	writer.WriteString("10, 15\n")
	writer.WriteString("20, 25\n")
	writer.Close()


	rfile, err := os.Open("./output.txt")
    if err != nil {
        fmt.Println("文件打开失败 = ", err)
    }
	defer rfile.Close()
    //创建一个 *Reader ， 是带缓冲的
    reader := bufio.NewReader(rfile)
    //创建一个 *Reader ， 是带缓冲的
    for {
        str, err := reader.ReadString('\n') //读到一个换行就结束
        if err == io.EOF {                  //io.EOF 表示文件的末尾
            break
        }
        fmt.Print(str)
    }
    fmt.Println("文件读取结束...")
}