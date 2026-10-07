# asdf-d2

[D2](https://github.com/d2lang/d2) plugin for the [asdf version manager](https://asdf-vm.com).

## Requirements

- `git`, `curl`, and `tar`
- Linux or macOS on `amd64` or `arm64`

## Installation

Add this plugin and install a D2 version:

```shell
asdf plugin add d2 https://github.com/eihu0F/asdf-d2.git
asdf list-all d2
asdf install d2 latest
asdf set -u d2 latest
```

To select a version for the current project instead, run `asdf set d2 <version>`.
Then use D2 as usual:

```shell
d2 --version
```

See the [D2 documentation](https://d2lang.com/) for usage instructions and the
[asdf documentation](https://asdf-vm.com/guide/getting-started.html) for more
information about managing tool versions.

## License

This plugin is distributed under the [MIT License](LICENSE).
