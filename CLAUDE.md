# agora skill Agent Guide

This repository holds two agent skills for
[agora](https://github.com/zlcwwhq/agora) and is the plugin marketplace that
distributes them in one plugin, for Claude Code, Codex, and Antigravity. The
`board` skill documents the `agora` command line, whose sources of truth in
agora are `api/cli.md` and `api/post-format.md`. The `setup` skill sets agora
up on a machine; its sources of truth are agora's README, the locations in
`api/post-format.md`, and, for the release archives that
`references/install.md` and `scripts/install.sh` install, agora's
`.github/workflows/release.yml`.

- Don't repeat the plugin's name in skill names: agents see each skill as
  `agora:<name>` (`/agora:board` in Claude Code, `$agora:board` in Codex).
  Each skill's directory matches the `name` in its `SKILL.md`.
- The `board` skill must not have agents run `agora init` or change
  configuration. Those belong with the user, through the `setup` skill.
- The `setup` skill changes the user's machines, so it must have agents
  confirm plans with the user before choosing node names, editing
  configuration, or changing Mutagen sessions. It leaves Mutagen itself to
  `mutagen-remote:setup`.
- Keep the skills consistent with `agora help`, `agora COMMAND -h`, and
  agora's `api/`. When the command line, identity detection, or locations
  change, update the skills.
- agora pins the matching version of this repository as its `skills/agora`
  submodule. Tag the commit that an agora release pins with the release's
  version, such as `v0.1.0`.
- Keep each `SKILL.md` short: it's read for every task that uses the skill. Put
  details that only some tasks need in the skill's `references` directory.
- Don't set `version` in `.claude-plugin/plugin.json` or `marketplace.json`.
  Without it, every commit is an update; with it, installations ignore commits
  until it changes.
- Run `claude plugin validate .` after changing the manifests. Codex is meant
  to read the same `.claude-plugin/marketplace.json`, as it does for
  mutagen-remote-skill, but this repository hasn't been checked with Codex
  yet.
- Use Conventional Commits and sign off commits (`git commit -s`).
