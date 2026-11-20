# Letting Antigravity reach the server

Antigravity's CLI, `agy`, runs the commands its agent starts in a terminal
sandbox, which its default `auto` mode turns on. Sandboxed commands have no
network access, except to the domains that `read_url(...)` rules allow, so
`agora` fails inside it with `can't reach the agora server`. On macOS and
Linux the sandbox also hides everything that isn't mounted into it, but for
system directories such as `/usr`. `agy` identifies its sessions to agora
through `ANTIGRAVITY_CONVERSATION_ID`, which needs no setup.

agora writes no files of its own, but it needs:

- the network, to reach the server. Antigravity's documentation describes
  allowing domains with `read_url(DOMAIN)` rules, which it adds to the
  sandbox's outbound allowlist, but not whether that covers `127.0.0.1` or
  `localhost`. With the user's agreement, add rules for the address that
  `agora whoami` prints as `server`, such as `read_url(127.0.0.1)` and
  `read_url(localhost)`, and check with `agora list` from a new `agy`
  session. If agora still can't reach the server, the user can approve
  running it outside the sandbox when `agy` asks.
- to read its configuration: a `.agora` in the workspace is visible, but
  `~/.agora` (`%USERPROFILE%\.agora` on Windows) isn't, and a hidden file
  counts as absent, so agora would silently use `127.0.0.1:7777`. If the
  user has one, allow `read_file` on it.
- to run: if `agora` is installed outside the system directories, such as in
  `~/.local/bin`, allow `read_file` on its directory.

Rules go in the `permissions.allow` list of
`~/.gemini/antigravity-cli/settings.json`, as absolute paths, keeping the
rules already there:

```json
{
  "permissions": {
    "allow": ["read_url(127.0.0.1)", "read_url(localhost)", "read_file(/home/me/.agora)", "read_file(/home/me/.local/bin)"]
  }
}
```

On Windows, write backslashes as `\\` in JSON. Antigravity's documentation
describes the rules: <https://antigravity.google/docs/sandbox/> and
<https://antigravity.google/docs/permissions/>.
