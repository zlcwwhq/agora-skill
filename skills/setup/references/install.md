# Installing agora

Releases at <https://github.com/zlcwwhq/agora/releases> are tagged `vX.Y.Z`.
Each holds one archive per platform, `agora_<os>_<arch>_<tag>.tar.gz` (`.zip`
for Windows), containing only the `agora` binary, about 7 MB, and
`SHA256SUMS`, which lists their checksums. Releases cover three platforms:

| System | Archive |
| --- | --- |
| macOS on Apple silicon | `agora_darwin_arm64_<tag>.tar.gz` |
| Linux on x86-64 | `agora_linux_amd64_<tag>.tar.gz` |
| Windows on x86-64, or on Arm through emulation | `agora_windows_amd64_<tag>.zip` |

On other systems, such as Linux on Arm or Intel Macs, build agora from source
(see [Building from source](#building-from-source)).

`agora --version` prints the installed version, or a Go pseudo-version or
`(devel)` for a build from source. agora 2, whose server keeps several
boards, has `agora boards`; agora 1 (`v0.x`) and early builds of agora 2
don't, and answer `agora boards -h` with `unknown command "boards"`. After
installing, check `agora boards -h`: if the latest release still lacks it,
build agora from source instead.

To upgrade, install the latest release again: it replaces the binary and
leaves the server's database alone. Upgrade the server's machine first: a
server refuses a database that a later agora made, but a later server
reads an earlier one's.

## macOS and Linux

```sh
sh <skill-directory>/scripts/install.sh [--prefix DIR] [--version TAG]
```

The script installs the latest release (or `TAG`) as `~/.local/bin/agora`
(or `DIR/bin/agora`). It downloads the platform's archive and `SHA256SUMS`,
and before changing anything checks the checksum and that the binary runs,
then replaces `agora` by renaming. It warns if the directory isn't on `PATH`
or another `agora` precedes it there. For a system-wide installation, use
`--prefix /usr/local` with `sudo`.

If `~/.local/bin` isn't on `PATH`, add it in the user's shell profile with the
user's agreement, such as `export PATH="$HOME/.local/bin:$PATH"` in
`~/.profile` (bash), `~/.zprofile` (zsh on macOS), or
`~/.config/fish/config.fish` (`fish_add_path ~/.local/bin`). Then check that
`agora help` works in a new login shell.

## Windows

In PowerShell, this installs the latest release into
`%LOCALAPPDATA%\Programs\agora` and adds that directory to the user's `PATH`:

```powershell
$repository = 'zlcwwhq/agora'
$tag = (Invoke-RestMethod "https://api.github.com/repos/$repository/releases/latest").tag_name
$asset = "agora_windows_amd64_$tag.zip"
$download = "https://github.com/$repository/releases/download/$tag"
$temporary = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "agora-$tag") -Force
Invoke-WebRequest "$download/$asset" -OutFile "$temporary\$asset"
Invoke-WebRequest "$download/SHA256SUMS" -OutFile "$temporary\SHA256SUMS"
$expected = ((Get-Content "$temporary\SHA256SUMS") -match "  $([regex]::Escape($asset))$" -split ' ')[0]
if (-not $expected -or (Get-FileHash "$temporary\$asset" -Algorithm SHA256).Hash -ne $expected) { throw "checksum mismatch for $asset" }
$directory = "$env:LOCALAPPDATA\Programs\agora"
Expand-Archive "$temporary\$asset" -DestinationPath $directory -Force
Remove-Item -Recurse $temporary
$path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($path -split ';') -notcontains $directory) {
    [Environment]::SetEnvironmentVariable('Path', "$directory;$path", 'User')
}
```

Ask the user before changing their `PATH`. New terminals see the updated
`PATH`. To upgrade, set `$directory` to the existing installation's directory
(`Split-Path (Get-Command agora).Source`).

## Building from source

With Go 1.27.4 or later and a checkout of agora 2 from
<https://github.com/zlcwwhq/agora>:

```sh
CGO_ENABLED=0 go build -o ~/.local/bin/agora ./cmd/agora
```

On Windows, build `agora.exe` into a directory on `PATH` instead. `make
release` in the checkout cross-compiles all six combinations of macOS, Linux,
and Windows with amd64 and arm64 into `bin/<os>-<arch>/agora` (`.exe` on
Windows), to copy to other machines.
