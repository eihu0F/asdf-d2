#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/d2lang/d2"

fail() {
	echo "asdf-d2: $*" >&2
	exit 1
}

curl_opts=(-fsSL)
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts+=(-H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n |
		awk '{print $2}'
}

list_all_versions() {
	git ls-remote --tags --refs "$GH_REPO" |
		sed -nE 's|.*refs/tags/v?([0-9][^/]*)$|\1|p'
}

get_platform() {
	case "$(uname -s)" in
	Darwin) printf '%s\n' macos ;;
	Linux) printf '%s\n' linux ;;
	*) fail "Unsupported operating system: $(uname -s)" ;;
	esac
}

get_arch() {
	case "$(uname -m)" in
	x86_64 | amd64) printf '%s\n' amd64 ;;
	aarch64 | arm64) printf '%s\n' arm64 ;;
	*) fail "Unsupported architecture: $(uname -m)" ;;
	esac
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	url="$GH_REPO/releases/download/v${version}/d2-v${version}-$(get_platform)-$(get_arch).tar.gz"

	echo "* Downloading D2 release $version..."
	curl "${curl_opts[@]}" -o "$filename" "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"
	local release_dir="$ASDF_DOWNLOAD_PATH/d2-v${version}"

	if [ "$install_type" != "version" ]; then
		fail "asdf-d2 supports release installs only"
	fi

	test -x "$release_dir/bin/d2" || fail "Expected executable $release_dir/bin/d2 was not found"
	test -f "$release_dir/Makefile" || fail "Expected Makefile in $release_dir was not found"
	make -sC "$release_dir" install PREFIX="$install_path" || fail "Could not install D2 $version"
	echo "D2 $version installation was successful!"
}
