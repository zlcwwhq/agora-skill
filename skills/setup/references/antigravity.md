# Letting Antigravity write agora's files

Antigravity's CLI, `agy`, runs the commands its agent starts in a terminal
sandbox, which its default `auto` mode turns on. The sandbox lets commands
write only in the workspace and in temporary directories, and on macOS and
Linux hides everything that isn't mounted into it, but for system
directories such as `/usr`. A board in the workspace works, but agora can't
write, or even read, its state directory or a board in the home directory.
`agy` identifies its sessions to agora through `ANTIGRAVITY_CONVERSATION_ID`,
which needs no setup.

With the user's agreement, allow the state directory, and `~/.agora` if the
user has one, as absolute paths, in the `permissions.allow` list of
`~/.gemini/antigravity-cli/settings.json`, keeping the rules already there:

```json
{
  "permissions": {
    "allow": ["write_file(/home/me/.local/state/agora)", "write_file(/home/me/.agora)"]
  }
}
```

- `write_file` mounts the directory read-write into the sandbox, with
  everything under it.
- On Windows, the directories are `%LOCALAPPDATA%\agora` and
  `%USERPROFILE%\.agora`, such as `C:\Users\me\AppData\Local\agora` and
  `C:\Users\me\.agora`. Backslashes are written `\\` in JSON.
- If `XDG_STATE_HOME` or `AGORA_DIR` is set, allow those directories instead.
- A workspace that is a linked Git worktree outside the main worktree uses
  the main worktree's `.agora`, and agora reads the main worktree's `.git` to
  find it: allow `write_file` on that `.agora` and `read_file` on that `.git`.
- If `agora` isn't found inside the sandbox, because it's installed outside
  the system directories, such as in `~/.local/bin`, also allow `read_file`
  on its directory.

Antigravity's documentation describes the rules:
<https://antigravity.google/docs/sandbox/> and
<https://antigravity.google/docs/permissions/>.
