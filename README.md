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
- Git configured on your host machine

### Usage

- `scripts/setup.sh` to get set up.
- `sbx env run` to start the sandbox.
- `sbx env rm` to delete it.

### Development

You need [mise](https://mise.jdx.dev/). Then:

- `mise install` for Node, pnpm and ShellCheck.
- `pnpm install` for dependencies.
- `scripts/format.sh` to format files.
- `scripts/shellcheck.sh` to lint the shell scripts.
- `scripts/validate-kits.sh` to check each kit builds.

## Licence

[MIT License](LICENCE)
