# Agent guidance

- Discover development commands with `task --list-all`; run `task check` as
  the CI and pre-push verification gate. `task format` applies Go formatting
  and linter fixes; verification tasks must not rewrite source files.
- `go.mod` is the source of truth for the Go toolchain. Use the default shared
  Go and golangci-lint caches. Generated artifacts belong under `.build/`.
- Build metadata is injected into `main.Version`, `main.Commit`, and
  `main.BuildTime`; keep Task, Docker, and GoReleaser flags aligned.
- Configuration comes from the `ASSET_WATCHER_*` environment variables in
  `config.go`. Project inclusion and exclusion are mutually exclusive.
- Tests use local fakes for Google APIs. Running the application contacts
  Google Cloud and requires an organization ID and Application Default
  Credentials; do not treat a live run as a unit-test prerequisite.
- Keep the existing JSON field names and Cloud Logging attribute mapping.
- Snapshot releases must not publish. Publishing releases, tags, container
  images, or Homebrew updates requires an explicit user request.
