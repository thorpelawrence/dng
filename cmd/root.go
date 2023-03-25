package cmd

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/adrg/xdg"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/thorpelawrence/dng/flagtype"
	"github.com/thorpelawrence/dng/validation"
)

var cmd = &cobra.Command{
	Use:   "dng",
	Short: "A brief description of your application",
	Long: `A longer description that spans multiple lines and likely contains
examples and usage of using your application. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Args: func(cmd *cobra.Command, args []string) error {
		if len(args) < 1 {
			return errors.New("requires at least one source file")
		}

		for _, arg := range args {
			if err := validation.ValidateFile(arg); err != nil {
				return err
			}
		}

		return nil
	},
	// TODO don't need to check for files in completion, as should be able to tab complete thru dirs to files, as it currently works
	PreRunE: func(cmd *cobra.Command, args []string) error {
		log.Debug().Msg(strings.Join(args, ":"))
		dir := flags.directory
		if dir == nil {
			log.Info().Msg("dir is nil")
		}
		log.Debug().Msg(*dir)

		return fmt.Errorf("failed to validate something")
	},
	Run: func(cmd *cobra.Command, args []string) {
		log.Debug().Msg(filepath.Join(xdg.DataHome, "dng"))
	},
	// ValidArgsFunction: func(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
	// return []string{}, cobra.ShellCompDirectiveDefault
	// if len(args) != 0 {
	// 	return nil, cobra.ShellCompDirectiveNoFileComp
	// }
	// theOptions := []string{"aaa", "bbb", "ccc", "ddd", "abc", "def", "hij"}
	// result := make([]string, 0)
	// for _, o := range theOptions {
	// 	if strings.HasPrefix(o, toComplete) {
	// 		result = append(result, o)
	// 	}
	// }
	// return result, cobra.ShellCompDirectiveNoFileComp
	// },
}

func Execute() {
	err := cmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	flags.compressed = cmd.Flags().BoolP("compressed", "c", true, "Output compressed DNG files")
	flags.directory = cmd.Flags().StringP("dir", "d", "", `Output converted or extracted files to the specified directory.
Default to the parent directory of the input file.
In the case of multiple input files, it defaults to the parent directory of each file`)
	flags.jpeg_preview_size = flagtype.NewOneOf("medium", []string{"none", "medium", "full"})
	cmd.Flags().VarP(flags.jpeg_preview_size, "jpeg-preview-size", "j", "jpeg preview size")
	cmd.MarkFlagDirname("dir")
}
