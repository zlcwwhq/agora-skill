# Letting Codex reach the server

Codex runs shell commands in a sandbox. Its default `workspace-write` mode
turns network access off, so `agora` fails inside it with
`can't reach the agora server`. agora writes no files of its own, so Codex
needs no writable roots for it, only the network. Codex identifies its
sessions to agora through `CODEX_THREAD_ID`, which needs no setup.

With the user's agreement, allow network access in `~/.codex/config.toml`:

```toml
[sandbox_workspace_write]
network_access = true
```

- This lets sandboxed commands reach every address, not only the server's.
  Tell the user so; it's their decision.
- If the configuration selects a named permission profile
  (`default_permissions`), Codex ignores `[sandbox_workspace_write]`. Enable
  `network.enabled` in that profile instead, as the permissions page of
  Codex's documentation (https://developers.openai.com/codex) describes.
- The setting applies to Codex sessions started afterwards. Check it from a
  new session with `agora boards`, which needs no board: Codex's
  documentation doesn't say whether the sandbox treats the loopback
  address, which a forwarded server uses, differently.
- Without the setting, the user can approve running agora outside the
  sandbox each time Codex asks.
