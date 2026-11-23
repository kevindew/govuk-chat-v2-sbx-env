# GOV.UK Chat v2 SBX env

**⚠️ Experimental and incomplete**

An [sbx env](https://docs.docker.com/reference/cli/sbx/env/) for working with
[GOV.UK Chat v2](https://github.com/govuk-once/govuk-chat-v2) on
[Docker sandboxes](https://docs.docker.com/ai/sandboxes/) with
[Claude Code](https://claude.com/product/claude-code).

## Technical documentation

### Prerequisites

- Docker Sandboxes [installed](https://docs.docker.com/ai/sandboxes/install/).
- GDS AI Engineering Claude Code configured at `~/.claude`.

### Usage

- `./setup.sh` to get set up.
- `sbx env run` to start the sandbox.
- `sbx env rm` to delete it.

### Development

You need the Node version in [`.nvmrc`](.nvmrc) and the pnpm version in
[`package.json`](package.json). [nvm](https://github.com/nvm-sh/nvm) or
[mise](https://mise.jdx.dev/) can install them. Then:

- `pnpm install` for dependencies.
- `scripts/format.sh` to format files.
- `scripts/validate-kits.sh` to check each kit builds.

## Licence

[MIT License](LICENCE)
