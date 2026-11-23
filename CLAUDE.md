# agora skill Agent Guide

This repository holds three agent skills for
[agora](https://github.com/zlcwwhq/agora) and is the plugin marketplace that
distributes them in one plugin, for Claude Code, Codex, and Antigravity. The
`board` skill documents the `agora` command line, whose sources of truth in
agora are `api/cli.md` and `api/config.md`. The `dispatch` skill builds on
`board` to hand a board's work to the names that should do it; its sources
of truth are the same, and, for how it wakes and starts sessions, each
harness's own command line, such as `claude --help`. The `setup` skill sets agora up;
its sources of truth are agora's README, `api/config.md`, `agora serve` in
`api/cli.md`, the `Host` rule in `api/http.md`, and, for the release archives
that
`references/install.md` and `scripts/install.sh` install, agora's
`.github/workflows/release.yml`.

- Don't repeat the plugin's name in skill names: agents see each skill as
  `agora:<name>` (`/agora:board` in Claude Code, `$agora:board` in Codex).
  Each skill's directory matches the `name` in its `SKILL.md`.
- The `board` skill must not have agents run `agora init`, `agora serve`, or
  `agora boards create`, or change configuration. Those belong with the user, through the `setup`
  skill.
- The `dispatch` skill posts, wakes, and starts sessions only for a plan
  that the user confirmed in its terminal, starts or wakes only sessions of
  its own harness on its own machine, and never drives another harness's
  command line, such as `agy -p`: for those, it gives the user a prompt.
- The `setup` skill changes the user's machines, so it must have agents
  confirm plans with the user before installing agora, starting a server,
  forwarding ports, creating boards, editing configuration, or moving old
  boards. It leaves
  Mutagen itself to `mutagen-remote:setup`.
- Keep the skills consistent with `agora help`, `agora COMMAND -h`, and
  agora's `api/`. When the command line, identity detection, or locations
  change, update the skills.
- agora doesn't include this repository, as a submodule or otherwise, so no
  release of agora pins a version of the skills: `main` describes agora's
  `main`. Tag the commit that describes an agora release with the release's
  version, such as `v0.5.0`.
- The `old` branch holds the skills for agora v0.4 and earlier, whose boards
  were synchronized directories, and which is no longer developed. Don't
  change it, and don't carry its commands or locations back into `main`.
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
