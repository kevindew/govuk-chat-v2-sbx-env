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

- `scripts/setup.sh` to get set up.
- `sbx env run` to start the sandbox.
- `sbx env rm` to delete it.

### Development

You need the Node version in [`.nvmrc`](.nvmrc) and the pnpm version in
[`package.json`](package.json). [nvm](https://github.com/nvm-sh/nvm) or
[mise](https://mise.jdx.dev/) can install them. Then:

- `pnpm install` for dependencies.
- `scripts/format.sh` to format files.
- `scripts/validate-kits.sh` to check each kit builds.

### Known Issues

#### CDK Synth fails in the sandbox

Running CDK Synth fails due to a dependency on a Python dependency on
the private repo: `govuk-chat-v2-private`. The bundling runs in a Docker
container, and the container's git requests don't get the sandbox proxy's
credential substitution, so GitHub receives the placeholder token instead
of a real one.

## Licence

[MIT License](LICENCE)
