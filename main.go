package main

import (
	"fmt"

	"github.com/sameersbn/shaout/version"
	"rsc.io/quote"
)

func main() {
	quote.Go()
	fmt.Println(version.Show())
}
