use clap::CommandFactory;
use clap_complete::{
    generate_to,
    shells::{Bash, Fish, Zsh},
    Generator,
};
use std::path::PathBuf;

#[path = "src/cli.rs"]
mod cli;

fn generate_man(out_dir: &PathBuf) -> std::io::Result<()> {
    let man = clap_mangen::Man::new(cli::DNG::command());
    let mut buffer: Vec<u8> = Default::default();
    man.render(&mut buffer)?;

    let path = out_dir.join("dng.1");

    std::fs::write(&path, buffer)?;

    println!("cargo:warning=man file is generated: {:?}", path);

    Ok(())
}

fn generate_completion<G>(gen: G, out_dir: &PathBuf) -> std::io::Result<()>
where
    G: Generator,
{
    let path = generate_to(gen, &mut cli::DNG::command(), "dng", out_dir)?;

    println!("cargo:warning=completion file is generated: {:?}", path);

    Ok(())
}

fn main() -> std::io::Result<()> {
    println!("cargo:rerun-if-changed=src/cli.rs");

    let out_dir = std::path::PathBuf::from(
        std::env::var_os("OUT_DIR").ok_or_else(|| std::io::ErrorKind::NotFound)?,
    );

    generate_man(&out_dir)?;

    generate_completion(Bash, &out_dir)?;
    generate_completion(Fish, &out_dir)?;
    generate_completion(Zsh, &out_dir)?;

    Ok(())
}
