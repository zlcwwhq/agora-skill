#!/bin/sh
# Install agora from a GitHub release on macOS (Apple silicon) or Linux
# (x86-64), after checking the archive against the release's SHA256SUMS.
#
# usage: install.sh [--prefix DIR] [--version TAG]
#
#   --prefix DIR   install DIR/bin/agora (default: ~/.local)
#   --version TAG  install release TAG, such as v0.1.0 (default: the latest
#                  release)
set -eu

repository=zlcwwhq/agora
prefix=$HOME/.local
tag=

die() {
	echo "install.sh: $*" >&2
	exit 1
}

while [ $# -gt 0 ]; do
	case $1 in
	--prefix) [ $# -ge 2 ] || die "--prefix needs a directory"; prefix=$2; shift 2 ;;
	--version) [ $# -ge 2 ] || die "--version needs a tag"; tag=$2; shift 2 ;;
	-h | --help) sed -n '2,10s/^# \{0,1\}//p' "$0"; exit 0 ;;
	*) die "unknown argument: $1" ;;
	esac
done

for command in curl tar awk; do
	command -v "$command" >/dev/null 2>&1 || die "$command is required"
done

case "$(uname -s)/$(uname -m)" in
Darwin/arm64) platform=darwin_arm64 ;;
Linux/x86_64 | Linux/amd64) platform=linux_amd64 ;;
*) die "no release for $(uname -s)/$(uname -m): build agora from source" ;;
esac

# The latest release's URL redirects to its tag, which avoids the
# rate-limited API.
if [ -z "$tag" ]; then
	latest=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$repository/releases/latest") ||
		die "unable to determine the latest release"
	tag=${latest##*/}
	case $tag in v*) ;; *) die "unable to determine the latest release" ;; esac
fi

asset=agora_${platform}_$tag.tar.gz
download=https://github.com/$repository/releases/download/$tag
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

curl -fsSL -o "$temporary/SHA256SUMS" "$download/SHA256SUMS" || die "unable to download $download/SHA256SUMS"
curl -fsSL -o "$temporary/$asset" "$download/$asset" || die "unable to download $download/$asset"
expected=$(awk -v name="$asset" '$2 == name || $2 == "*" name { print $1 }' "$temporary/SHA256SUMS")
[ -n "$expected" ] || die "$asset isn't listed in SHA256SUMS"
if command -v sha256sum >/dev/null 2>&1; then
	actual=$(sha256sum "$temporary/$asset" | awk '{ print $1 }')
else
	actual=$(shasum -a 256 "$temporary/$asset" | awk '{ print $1 }')
fi
[ "$actual" = "$expected" ] || die "checksum mismatch for $asset"

tar -xzf "$temporary/$asset" -C "$temporary" agora
"$temporary/agora" help >/dev/null || die "the downloaded agora doesn't run"
mkdir -p "$prefix/bin"
# Replace the binary by renaming, so that running agora processes keep theirs.
cp "$temporary/agora" "$prefix/bin/.agora.new"
chmod 755 "$prefix/bin/.agora.new"
mv -f "$prefix/bin/.agora.new" "$prefix/bin/agora"
echo "installed agora $tag as $prefix/bin/agora"

found=$(command -v agora 2>/dev/null || true)
if [ "$found" != "$prefix/bin/agora" ]; then
	if [ -n "$found" ]; then
		echo "warning: $found precedes it on PATH" >&2
	else
		echo "warning: $prefix/bin isn't on PATH" >&2
	fi
fi
