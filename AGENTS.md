# AGENTS.md

This repo is a [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/)
environment for working on
[GOV.UK Chat v2](https://github.com/govuk-once/govuk-chat-v2).
`govuk-chat-v2/` is a gitignored clone of that repo, used as the sandbox
workspace. It has its own Git history, so leave it alone when working on this
repo.

## Conventions

Follow the GOV.UK Chat v2 [AGENTS.md](./govuk-chat-v2/AGENTS.md) where it
applies, or the
[GitHub copy](https://github.com/govuk-once/govuk-chat-v2/blob/main/AGENTS.md)
if the clone is missing. Always read it before working with Git or pull
requests. This file takes precedence where the two differ. Ask if you're not
sure whether something applies.

The points that matter most, so you don't need to read it for every task:

- **This is a public repo.** Never commit anything sensitive, and keep comments
  and Git messages professional.
- **Favour simple, idiomatic solutions** that humans can maintain, not just
  ones that work. If an approach needs a complex bash script, explore and
  suggest alternatives, starting with whether a
  [kit](https://docs.docker.com/ai/sandboxes/customize/) can help.
- **Only add comments that explain something the code doesn't.** Most code and
  configuration is obvious, so save them for anything surprising or hard to
  follow.
- **Write for humans.** Make what you write inviting to read and avoid AI
  writing clichés. Be brief but not terse; lists often work better than
  paragraphs.
