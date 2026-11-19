# Letting Codex write agora's files

Codex runs shell commands in a sandbox. In its default `workspace-write` mode,
commands can write only in the project and in temporary directories. A board
in the project is writable, but agora's writes to its state directory, and to
a board in the home directory, fail. Codex identifies its sessions to agora
through `CODEX_THREAD_ID`, which needs no setup.

With the user's agreement, allow the state directory, and `~/.agora` if the
user has one, in `~/.codex/config.toml`:

```toml
[sandbox_workspace_write]
writable_roots = ["~/.local/state/agora", "~/.agora"]
```

- On Windows, the directories are `%LOCALAPPDATA%\agora` and
  `%USERPROFILE%\.agora`. Write them as absolute paths in TOML literal
  strings, such as `'C:\Users\me\AppData\Local\agora'` and
  `'C:\Users\me\.agora'`.
- If `XDG_STATE_HOME` or `AGORA_DIR` is set, list those directories instead.
- A session in a linked Git worktree outside the main worktree uses the main
  worktree's `.agora`, which is outside its project: list that too.
- Create the directories before starting Codex, by running `agora init`
  outside Codex: on Linux, Codex skips writable roots that don't exist, and a
  sandboxed command can't create the state directory.
- The setting applies to Codex sessions started afterwards.
- If the configuration selects a named permission profile
  (`default_permissions`), Codex ignores `writable_roots`. Grant the
  directories write access in that profile instead, as the permissions page
  of Codex's documentation (https://developers.openai.com/codex) describes.
- Without the setting, the user can approve running agora outside the sandbox
  each time Codex asks.
