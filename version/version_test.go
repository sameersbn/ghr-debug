package version

import "testing"

func TestShow(t *testing.T) {
	want := "tag: unknown, commit: unknown"
	if got := Show(); got != want {
		t.Errorf("Show() = %q, want %q", got, want)
	}
}
