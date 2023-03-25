package cmd

import (
	"fmt"
	"path/filepath"
)

func GenerateCompletionFiles(dir string) error {
	cmd := cmd.Root()

	if err := cmd.GenBashCompletionFile(filepath.Join(dir, fmt.Sprintf("%s.bash", cmd.Name()))); err != nil {
		return err
	}
	if err := cmd.GenFishCompletionFile(filepath.Join(dir, fmt.Sprintf("%s.fish", cmd.Name())), true); err != nil {
		return err
	}
	if err := cmd.GenZshCompletionFile(filepath.Join(dir, fmt.Sprintf("_%s", cmd.Name()))); err != nil {
		return err
	}

	return nil
}
