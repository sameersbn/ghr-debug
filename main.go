package main

import "fmt"
import "github.com/sameersbn/shaout/version"

func main() {
	fmt.Println("tag   :", version.Tag)
	fmt.Println("commit:", version.Commit)
}
