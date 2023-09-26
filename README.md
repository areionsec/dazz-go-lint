# dazz-go-lint

`dazz-go-lint-lint` is a pre-commit hook, which can be used to run `golangci-lint`
with a centralized, unified `.golangci.yml`; in addition, it also runs `go mod tidy`.

## Default params

If not provided the hook uses `https://raw.githubusercontent.com/areionsec/dazz-go-lint/master/.golangci.yml`
as remote config URL, and `v1.54.2` version of `golangci-lint`.

## Usage
To add it to your repository, add the following to your `.pre-commit-config.yaml` file:
```yaml
repos:
  - repo: https://github.com/areionsec/dazz-go-lint
    rev: v2.0.0
    hooks:
      - id: dazz-go-lint
        args: [
          https://raw.githubusercontent.com/path/to/private/.golangci.yml, # Remote .golangci.yml URL.
          v1.54.2 # golangci-lint version
        ]
```

**Note:** When providing a URL to a private `.golangci.yml`, `dazz-go-lint` 
requires a `GITHUB_TOKEN` env param, in order to fetch the private yml. The
env param is not needed when using the default public `.golangci.yml` mentioned
above, or when providing a URL to a publicly accessible yml.

Then, to run the pre-commit hook command before each commit, run:
```bash
pre-commit install
```
