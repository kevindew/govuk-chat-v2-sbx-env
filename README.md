# GOV.UK Chat v2 SBX env

**⚠️ Experimental**

An [sbx env](https://docs.docker.com/reference/cli/sbx/env/) for working with
[GOV.UK Chat v2](https://github.com/govuk-once/govuk-chat-v2) on
[Docker sandboxes](https://docs.docker.com/ai/sandboxes/) with
[Claude Code](https://claude.com/product/claude-code).

## Technical documentation

### Prerequisites

- Docker Sandboxes [installed](https://docs.docker.com/ai/sandboxes/install/).
- GDS AI Engineering Claude Code configured at `~/.claude`.
- Git configured on your host machine
- [GDS CLI](https://github.com/alphagov/gds-cli) for AWS credentials

### Usage

- `scripts/setup.sh` to get set up.
- `sbx env run` to start the sandbox.
- `scripts/setup-aws-credentials.sh` to refresh the sandbox's AWS credentials.
- `sbx env rm` to delete the sandbox.

### Development

You need [mise](https://mise.jdx.dev/). Then:

- `mise install` for Node, pnpm and ShellCheck.
- `pnpm install` for dependencies.
- `scripts/format.sh` to format files.
- `scripts/shellcheck.sh` to lint the shell scripts.
- `scripts/validate-kits.sh` to check each kit builds.

### Known Issues

#### Dependencies are shared between the host and sandbox

The `govuk-chat-v2` workspace is shared between the host and the sandbox,
so `node_modules` and `.venv` are too. These only work on the system that
installed them, so after the sandbox starts you'll need to run
`pnpm install` and `uv sync --all-packages --dev` again on the host. A fix
would be excluding these directories from the workspace, see
[docker/sbx-releases#40](https://github.com/docker/sbx-releases/issues/40).

## Licence

[MIT License](LICENCE)
