# Claude Code sessions for a dispatcher

How a dispatcher that runs in Claude Code finds, wakes, and starts Claude
Code sessions on its own machine. Checked with Claude Code 2.1.330.

## State

`claude agents --json` lists the background sessions on this machine, with
each one's id, name, and state; `--all` adds the finished ones.

- `state: blocked` with `status: idle` waits for its next prompt: a message
  starts its next turn.
- `state: blocked` with `status: waiting` and `waitingFor: permission prompt`
  waits for the user. A message to it only queues, and is lost if the
  session stops: ask the user to answer it with `claude attach ID`.
- A session's transcript records each turn's token usage, which tells how
  full its context is.

## Waking a session

- **Running or idle**: send it a message with the `SendMessage` tool, naming
  the session as `ListAgents` lists it. A message nudges; it is no
  assignment: the assignment is the post on the board, which outlives the
  message.
- **Stopped**: `claude respawn ID` starts it again with the same id, so it
  still carries its name. Then send it the start prompt with `SendMessage`.
- Don't use `claude --resume ID --bg PROMPT` for this: it starts a copy with
  a new id, in a new worktree under `.claude/worktrees/`, which carries no
  name.

## Starting a session

```sh
claude --bg -n NAME "START PROMPT"        # in this checkout
claude --bg -n NAME -w BRANCH "START PROMPT"   # in a worktree of its own
```

`--bg` ignores `--session-id`: read the new session's id from what it
prints, or from `claude agents --json`. Its `agora claim` records it as the
name's carrier, which `agora names` then shows.

## Waiting

A background session waits for its name's work with `agora wait --to-me` as
a background command: Claude Code tells it when the command exits, and it
spends no turns until then. After `/clear`, its session id changes, and it
claims its name again with `agora claim NAME --take`.
