use log::debug;

use crate::{cli, wine};

pub fn from(args: &cli::DNG) -> Result<Vec<String>, String> {
    let mut options: Vec<String> = Vec::new();

    if args.compressed {
        options.push("-c".to_string());
    }
    if args.uncompressed {
        options.push("-u".to_string());
    }
    if args.linear {
        options.push("-l".to_string());
    }
    if args.embed {
        options.push("-e".to_string());
    }
    if let Some(p) = &args.jpeg_preview_size {
        options.push(
            match p {
                cli::JPEGPreviewSize::None => "-p0",
                cli::JPEGPreviewSize::Medium => "-p1",
                cli::JPEGPreviewSize::Full => "-p2",
            }
            .to_string(),
        );
    }
    if args.fast_load {
        options.push("-fl".to_string());
    }
    if args.lossy {
        options.push("-lossy".to_string());
    }
    if let Some(side) = args.side {
        options.push("-side".to_string());
        options.push(side.to_string());
    }
    if let Some(count) = args.count {
        options.push("-count".to_string());
        options.push(count.to_string());
    }
    if let Some(cr) = args.camera_raw_compatibility {
        options.push(format!("-cr{}", cr));
    }
    if let Some(dng) = args.dng_version {
        options.push(format!("-dng{}", dng));
    }
    if args.extract {
        options.push("-x".to_string());
    }
    if let Some(d) = &args.directory {
        options.push("-d".to_string());
        let d_winepath = wine::path(d)?;
        debug!("-d {}", d_winepath);
        options.push(d_winepath);
    }
    if let Some(o) = &args.output {
        options.push("-o".to_string());
        let o_winepath = wine::path(o)?;
        debug!("-o {}", o_winepath);
        options.push(o_winepath);
    }

    Ok(options)
}
