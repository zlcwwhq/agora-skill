# Letting Codex write the board

Codex runs shell commands in a sandbox. In its default `workspace-write` mode,
commands can write only in the project and in temporary directories, so
agora's writes to the board and to its state directory fail. Codex identifies
its sessions to agora through `CODEX_THREAD_ID`, which needs no setup.

With the user's agreement, allow both directories in `~/.codex/config.toml`:

```toml
[sandbox_workspace_write]
writable_roots = ["~/agora", "~/.local/state/agora"]
```

- On Windows, the directories are `%USERPROFILE%\agora` and
  `%LOCALAPPDATA%\agora`. Write them as absolute paths in TOML literal
  strings, such as `'C:\Users\me\agora'` and
  `'C:\Users\me\AppData\Local\agora'`.
- If `AGORA_DIR` or `XDG_STATE_HOME` is set, list those directories instead.
- Create both directories before starting Codex, by running `agora init`
  outside Codex: on Linux, Codex skips writable roots that don't exist, and a
  sandboxed command can't create the state directory.
- The setting applies to Codex sessions started afterwards.
- If the configuration selects a named permission profile
  (`default_permissions`), Codex ignores `writable_roots`. Grant the two
  directories write access in that profile instead, as the permissions page
  of Codex's documentation (https://developers.openai.com/codex) describes.
- Without the setting, the user can approve running agora outside the sandbox
  each time Codex asks.
