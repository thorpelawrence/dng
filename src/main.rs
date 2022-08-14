mod cli;
mod datarootdir;
mod options;
mod wine;

use clap::Parser;
use log::{debug, error};
use std::process::exit;

/// Log error and exit
macro_rules! fatal {
    (code: $code:expr, $($arg:tt)+) => {
        error!($($arg)+);
        exit($code);
    };
    ($($arg:tt)+) => {
        error!($($arg)+);
        exit(1);
    };
}

fn main() {
    env_logger::builder().format_timestamp(None).init();

    let args = cli::DNG::parse();
    let options = match options::from(&args) {
        Ok(options) => options,
        Err(e) => {
            fatal!("failed parsing options: {}", e);
        }
    };

    let mut wine_paths: Vec<String> = Vec::with_capacity(args.files.len());

    for file in &args.files {
        // let path = match file.as_path().canonicalize() {
        //     Ok(path) => path,
        //     Err(e) => {
        //         fatal!("{}: {}", file.display(), e);
        //     }
        // };

        let wine_path = match wine::path(&file) {
            Ok(path) => path,
            Err(e) => {
                fatal!("failed getting winepath: {}", e);
            }
        };
        debug!("file {}", wine_path);
        wine_paths.push(wine_path);
    }

    let err = wine::dng(options, wine_paths);
    fatal!("unexpected error launching wine: {}", err);
}
