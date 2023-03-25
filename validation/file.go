package validation

import (
	"fmt"
	"os"
)

func ValidateFile(name string) error {
	f, err := os.Stat(name)
	if os.IsNotExist(err) {
		return fmt.Errorf("'%s': %w", name, err)
	}
	if !f.Mode().IsRegular() {
		return fmt.Errorf("'%s' is not a file", name)
	}

	return nil
}
