# dwarf-fortress-0.47.05-linux-x86_64-packaging

Debian packaging for the official Dwarf Fortress 0.47.05 Linux x86_64
release.

This repository contains only packaging metadata, maintainer scripts, launchers,
and the fixed source archive submodule. The packaged game files come from the
pinned
[Dwarf Fortress 0.47.05 Linux x86_64 archive](https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-archive)
submodule at `upstream/dwarf-fortress-0.47.05-linux-x86_64-archive` and are
installed under:

```text
/opt/dwarf-fortress-0.47.05
```

## Quick Start

Install from the shared APT repository:

```sh
curl -fsSL https://utah27397.github.io/dwarf-fortress-0.47.05-apt-repository/df04705-packaging.sources \
  -o /tmp/df04705-packaging.sources
sudo install -o root -g root -m 0644 /tmp/df04705-packaging.sources \
  /etc/apt/sources.list.d/df04705-packaging.sources
rm /tmp/df04705-packaging.sources
sudo apt-get update
sudo apt-get install dwarf-fortress-0.47.05
```

Alternatively, download and install the latest release directly:

```sh
curl -LO 'https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-packaging/releases/latest/download/dwarf-fortress-0.47.05_0.47.05-1df04705.2_amd64.deb'
sudo apt install './dwarf-fortress-0.47.05_0.47.05-1df04705.2_amd64.deb'
```

Run the game:

```sh
dwarffortress
```

Build locally instead:

```sh
git clone --recursive https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-packaging.git
cd dwarf-fortress-0.47.05-linux-x86_64-packaging
make build
sudo apt install '../dwarf-fortress-0.47.05_0.47.05-1df04705.2_amd64.deb'
```

Build the package:

```sh
git submodule update --init
make build
```

The default output path is:

```text
../dwarf-fortress-0.47.05_0.47.05-1df04705.2_amd64.deb
```

Runtime data and raws are copied into the user's data tree on first launch and
linked into a runtime tree by the launcher.

## Latest Release

Download the current Debian package from the
[latest GitHub release](https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-packaging/releases/latest).

## Related Repositories

- [Dwarf Fortress 0.47.05 Linux x86_64 packaging](https://github.com/utah27397/dwarf-fortress-0.47.05-linux-x86_64-packaging)
- [DFHack 0.47.05-r8 Linux x86_64 packaging](https://github.com/utah27397/dfhack-0.47.05r8-linux-x86_64-packaging)
- [DFHack scripts backport Linux packaging](https://github.com/utah27397/dfhack-scripts-backport-0.47.05r8-linux-packaging)
- [Dwarf Therapist v41.2.5 Linux x86_64 packaging](https://github.com/utah27397/dwarf-therapist-v41.2.5-linux-x86_64-packaging)
