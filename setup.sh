#!/bin/bash

if ! command -v wine &>/dev/null; then
    echo 'wine executable could not be found, make sure to install it first' >&2
    exit 1
fi

checksum_file="AdobeDNGConverter_x64_13_4.exe.sha1"
if ! shasum -c "$checksum_file"; then
    echo "Checksum match for '$checksum_file' failed, make sure you have downloaded the correct version" >&2
    exit 1
fi

WINEPREFIX="$HOME/.wine-dng" wine64 reg add "HKLM\\System\\CurrentControlSet\\Control\\ProductOptions" /v ProductType /d "WinNT" /f

set_winver_path="$(winepath -w set-winver.reg)"
WINEPREFIX="$HOME/.wine-dng" wine regedit /S "$set_winver_path"
WINEPREFIX="$HOME/.wine-dng" wine64 regedit /S "$set_winver_path"

WINEPREFIX="$HOME/.wine-dng" wine64 "AdobeDNGConverter_x64_13_4.exe" '/SILENT'
