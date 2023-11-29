# tent

tent is cli tool for auto play youtube videos.

### Nighty URLs

- [Pplay](https://nightly.link/satler-git/tent/workflows/buildpy.yaml/master/Pplay.zip)
- [Tent](https://nightly.link/satler-git/tent/workflows/buildcr.yaml/master/Tent.zip)

## Installation

tent is needing [mpv](https://github.com/mpv-player/mpv).

### buld

Download Lib(dll)

Visual Studio command prompt
```cmd
cd sqlite
lib /def:sqlite3.def /machine:x64
```

```bash
git clone https://github.com/satler-git/tent.git
cd tent
shards install
crystal build ./src/tent.cr --release --no-debug --static
cd py_api
pipenv install --dev
pipenv build
```

## Usage

TODO: Write usage instructions here

## Development

```bash
git clone https://github.com/satler-git/tent.git
cd tent
shards install
```

## Contributing

1. Fork it (<https://github.com/satler-git/tent/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [satler-git](https://github.com/satler-git) - creator and maintainer
