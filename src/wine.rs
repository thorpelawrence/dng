use home::home_dir;
use log::{debug, info};
use std::ffi::OsStr;
use std::fs;
use std::io::Error;
use std::io::{self, ErrorKind};
use std::os::unix::{self, process::CommandExt};
use std::path::PathBuf;
use std::process::{Command, Stdio};

use crate::datarootdir::DATAROOTDIR;

const WINE64: &'static str = "wine64";
const WINE: &'static str = "wine";
const WINEPATH: &'static str = "winepath";
const WINEBOOT: &'static str = "wineboot";

fn program() -> &'static str {
    if !cfg!(target_pointer_width = "64") {
        return WINE;
    }

    match Command::new(WINE64)
        .arg("--version")
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
    {
        Err(e) => {
            if e.kind() != ErrorKind::NotFound {
                debug!("unexpected error checking for wine64: {}", e)
            }
            WINE
        }
        Ok(_) => WINE64,
    }
}

fn init_prefix(prefix: &PathBuf) -> std::io::Result<()> {
    info!(
        "initialising WINEPREFIX '{}', this should only happen once",
        prefix.to_string_lossy()
    );
    fs::create_dir_all(prefix)?;
    Command::new(WINEBOOT)
        .env("WINEPREFIX", prefix.to_string_lossy().to_string())
        .env("WINEDEBUG", "-all")
        .arg("-u")
        .status()?;
    let original = format!("{}/dng/commonappdata/Adobe", DATAROOTDIR);
    let link = prefix.join("drive_c").join("ProgramData/Adobe");
    unix::fs::symlink(&original, &link)?;
    debug!("ln -s {} -> {}", &link.to_string_lossy(), &original);

    Ok(())
}

fn prefix() -> Result<String, String> {
    let prefix = &match home_dir() {
        Some(home) => home.join(".dng").join("wine"),
        None => return Err("failed to get home directory path".to_string()),
    };

    if !prefix.exists() {
        if let Err(e) = init_prefix(prefix) {
            return Err(format!("failed to init WINEPREFIX: {}", e));
        }
    }

    Ok(prefix.to_string_lossy().to_string())
}

pub fn path(p: &PathBuf) -> Result<String, String> {
    let prefix = match prefix() {
        Ok(prefix) => prefix,
        Err(e) => return Err(format!("failed to get WINEPREFIX: {}", e)),
    };

    let wine_path_output = match Command::new(WINEPATH)
        .env("WINEPREFIX", prefix)
        .env("WINEDEBUG", "-all")
        .arg("-w")
        .arg(p.to_string_lossy().to_string())
        .output()
    {
        Ok(output) => output,
        Err(e) => {
            return Err(format!("failed to execute {}: {}", WINEPATH, e));
        }
    };

    if !wine_path_output.status.success() {
        let stderr = String::from_utf8(wine_path_output.stderr).unwrap_or_default();
        return Err(format!("failed executing winepath:\n{}", stderr));
    }

    match String::from_utf8(wine_path_output.stdout) {
        Ok(path) => Ok(path.trim_end().to_string()),
        Err(e) => Err(format!("failed getting winepath output: {}", e)),
    }
}

pub fn dng<I, S>(options: I, files: I) -> io::Error
where
    I: IntoIterator<Item = S>,
    S: AsRef<OsStr>,
{
    let prefix = match prefix() {
        Ok(prefix) => prefix,
        Err(e) => return Error::new(ErrorKind::NotFound, e),
    };

    Command::new(program())
        .env("WINEPREFIX", prefix)
        .env("WINEDEBUG", "-all")
        .arg(format!("{}/dng/app/Adobe DNG Converter.exe", DATAROOTDIR))
        .args(options)
        .args(files)
        .exec()
}
