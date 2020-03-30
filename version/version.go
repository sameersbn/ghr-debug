package version

import "fmt"

var (
	Tag string = "unknown"
	Commit  string = "unknown"
)

func Show() string {
    return fmt.Sprintf("tag: %s, commit: %s", Tag, Commit)
}