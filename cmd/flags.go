package cmd

import "github.com/spf13/pflag"

var flags struct {
	compressed        *bool
	uncompressed      *bool
	linear            *bool
	embed             *bool
	jpeg_preview_size pflag.Value

	directory *string
}

/*
/// Output compressed DNG files
#[clap(short)]
pub compressed: bool,

/// Output uncompressed DNG files
#[clap(short)]
pub uncompressed: bool,

/// Output linear DNG files
#[clap(short)]
pub linear: bool,

/// Embed original raw file inside DNG files
#[clap(short)]
pub embed: bool,

/// Set JPEG preview size
#[clap(short, value_enum)]
pub jpeg_preview_size: Option<JPEGPreviewSize>,

/// Embed fast load data
#[clap(long = "fl")]
pub fast_load: bool,

/// Specify lossy compression. Defaults to preserve pixel count.
/// Specify a long-side pixels or megapixels limit with optional -side or -count.
/// Valid for Camera Raw compatibility 6.6 or later
#[clap(long = "lossy")]
pub lossy: bool,

/// Specify a long-side pixels value from 32 to 65000 pixels
#[clap(long = "side", value_parser = clap::value_parser!(u32).range(32..65000))]
pub side: Option<u32>,

/// Specify a megapixels limit of 1024 (1MB) or greater
#[clap(long = "count", value_parser = clap::value_parser!(u32).range(1024..))]
pub count: Option<u32>,

/// Set Camera Raw minimum compatibility
#[clap(long = "cr", possible_values = ["2.4", "4.1", "4.6", "5.4", "6.6", "7.1"])]
pub camera_raw_compatibility: Option<f32>,

/// Set DNG backward version
#[clap(long = "dng", possible_values = ["1.1", "1.3", "1.4"])]
pub dng_version: Option<f32>,

/// Extract original embedded raw file(s) from source file argument(s).
/// Overrides options above
#[clap(short = 'x')]
pub extract: bool,

/// Output converted or extracted files to the specified directory.
/// Default to the parent directory of the input file.
/// In the case of multiple input files, it defaults to the parent directory of each file
#[clap(short, value_hint = ValueHint::DirPath)]
pub directory: Option<std::path::PathBuf>,

/// Specify the name of the output DNG file.
/// Default is the name of the input file with the extension changed to ".dng".
/// When converting multiple files with a single command, output files will use this as a base name and will be numbered sequentially.
/// Ignored when using -x option
#[clap(short, value_hint = ValueHint::Other)]
pub output: Option<std::path::PathBuf>,

/// Source file(s)
#[clap(value_hint = ValueHint::FilePath)]
pub files: Vec<std::path::PathBuf>,
*/
