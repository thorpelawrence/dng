package main

import (
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/thorpelawrence/dng/cmd"
)

func main() {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})
	err := cmd.GenerateCompletionFiles("build")
	if err != nil {
		log.Fatal().Err(err).Msg("failed to generate completion files")
	}
}
