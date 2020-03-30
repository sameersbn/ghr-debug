package main

import (
	"fmt"

	"rsc.io/quote"
	"github.com/sameersbn/shaout/version"
)

func main() {
	quote.Go()
	fmt.Println(version.Show())
}
