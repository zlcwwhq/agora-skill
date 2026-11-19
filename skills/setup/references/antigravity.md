# Letting Antigravity write the board

Antigravity's CLI, `agy`, runs the commands its agent starts in a terminal
sandbox, which its default `auto` mode turns on. The sandbox lets commands
write only in the workspace and in temporary directories, and on macOS and
Linux hides everything that isn't mounted into it, but for system
directories such as `/usr`, so agora can't write, or even read, the board and
its state directory. `agy` identifies its sessions to agora through
`ANTIGRAVITY_CONVERSATION_ID`, which needs no setup.

With the user's agreement, allow both directories, as absolute paths, in the
`permissions.allow` list of `~/.gemini/antigravity-cli/settings.json`, keeping
the rules already there:

```json
{
  "permissions": {
    "allow": ["write_file(/home/me/agora)", "write_file(/home/me/.local/state/agora)"]
  }
}
```

- `write_file` mounts the directory read-write into the sandbox, with
  everything under it.
- On Windows, the directories are `%USERPROFILE%\agora` and
  `%LOCALAPPDATA%\agora`, such as `C:\Users\me\agora` and
  `C:\Users\me\AppData\Local\agora`. Backslashes are written `\\` in JSON.
- If `AGORA_DIR` or `XDG_STATE_HOME` is set, allow those directories instead.
- If `agora` isn't found inside the sandbox, because it's installed outside
  the system directories, such as in `~/.local/bin`, also allow `read_file`
  on its directory.

Antigravity's documentation describes the rules:
<https://antigravity.google/docs/sandbox/> and
<https://antigravity.google/docs/permissions/>.
