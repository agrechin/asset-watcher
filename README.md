# asset-watcher

A command-line utility to fetch a list of IP addresses across a Google Cloud organization through Google Asset API.

[![license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/andreygrechin/asset-watcher/blob/main/LICENSE)

## Features

- Collect `compute.googleapis.com/Address` assets.
- Filter by projects and a status.
- Output in a JSON or table format.

## Installation

### go install

```shell
go install github.com/andreygrechin/asset-watcher@latest
```

### Homebrew tap

You may also install the latest version of `asset-watcher` using the Homebrew tap:

```shell
brew install andreygrechin/tap/asset-watcher

# to update, run
brew update
brew upgrade asset-watcher
```

### Manually

Download the pre-compiled binaries from [the releases page](https://github.com/andreygrechin/asset-watcher/releases/) and copy them to a desired location.

## Required permissions

```shell
gcloud services enable cloudasset.googleapis.com
gcloud config set project <your-project-id-where-asset-api-is-enabled>
# set quota project
```

To run the tool, you need to have the following permissions:

- `resourcemanager.projects.get`
- `resourcemanager.projects.list`

## Usage

### Run as a binary

```shell
gcloud auth application-default login
export ASSET_WATCHER_ORG_ID=012345678912345
export ASSET_WATCHER_DEBUG=[true|false]
export ASSET_WATCHER_OUTPUT_FORMAT=[table|json]
export ASSET_WATCHER_EXCLUDE_RESERVED=[true|false]
export ASSET_WATCHER_EXCLUDE_PROJECTS=project-id-1,project-id-2
export ASSET_WATCHER_INCLUDE_PROJECTS=project-id-3,project-id-4
./asset-watcher
```

### Run in a local Docker container

```shell
task docker:build
docker run -it --rm \
  -e ASSET_WATCHER_ORG_ID=012345678912345 \
  -e ASSET_WATCHER_DEBUG=true \
  -e ASSET_WATCHER_OUTPUT_FORMAT=table \
  -e ASSET_WATCHER_EXCLUDE_RESERVED=true \
  -e ASSET_WATCHER_EXCLUDE_PROJECTS=project-id-1,project-id-2 \
  -e ASSET_WATCHER_INCLUDE_PROJECTS=project-id-3,project-id-4 \
  -v $HOME/.config/gcloud/application_default_credentials.json:/root/.config/gcloud/application_default_credentials.json \
  asset-watcher:latest
```

## Development

Install [Task](https://taskfile.dev/installation/), the Go toolchain declared in
`go.mod`, [golangci-lint](https://golangci-lint.run/docs/welcome/install/) v2.15.0,
and [govulncheck](https://go.dev/doc/security/vuln/). Docker and GoReleaser are
needed only for their respective tasks. Go uses its default shared caches.

```shell
task                  # Format, lint, test, and build
task check            # Full CI gate: lint, unit/race tests, security, build
task hooks:install    # Run the same gate before each push
task --list-all       # Discover build, coverage, container, and release tasks
```

The binary is written to `.build/bin/asset-watcher`; coverage and release
artifacts also live under `.build/`. Task loads `.env` when present, and every
Go command uses the exact toolchain version from `go.mod`.

`task security` runs gosec through golangci-lint and govulncheck for every
GoReleaser archive/container target: macOS amd64/arm64, Linux amd64/arm64, and
Windows amd64. GitHub Actions runs `task check` on pull requests, pushes to
`main`, version tags, and a weekly schedule. Gitleaks and dependency review
remain separate workflows.

Use `task release:check` to validate GoReleaser and `task release:snapshot` to
build snapshot archives without publishing or requiring Docker.

Push a signed `v*` tag on `main` to publish a release through
`.github/workflows/release.yml`. The hosted runner runs `task check`, builds the
archives and SBOMs, publishes Linux amd64/arm64 container images to
`ghcr.io/agrechin/asset-watcher`, and publishes the completed GitHub release.
The generated Homebrew formula is saved as the `homebrew-formula` workflow
artifact for a tap update PR; the repository token cannot write to the tap.
`task release` is a local fallback that creates a release draft and requires
the release credentials and Syft on `PATH`.

## License

This project is licensed under the [MIT License](LICENSE).

`SPDX-License-Identifier: MIT`
