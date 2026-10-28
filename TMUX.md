# Working in tmux

A coding agent next to a shell, in the directory I am standing in, with an
editor one keystroke away.

```
+----------------+----------------+
|      bash      |   coding cli   |
|      $PWD      |  the agent     |
+----------------+----------------+
|             editor              |   prefix + e or prefix + v
+---------------------------------+
```

The agent runs with my own configuration and my own credentials: nothing is
handed to it and nothing is prepared for it. A benchmark run is a different
thing and has its own workstation, described in
[the benchmark's own TMUX.md](https://github.com/bilardi/coding-agents-benchmark/blob/master/docs/TMUX.md).

## The script and its aliases

[bin/tmux-dev](bin/tmux-dev) takes the agent to open, names the session after
the current directory plus a two letter suffix, and reattaches instead of
opening a second one when it is already there.

| alias | agent | session suffix | command it launches |
|---|---|---|---|
| `tmuxoc` | opencode | `-oc` | `opencode` |
| `tmuxcc` | Claude Code | `-cc` | `claude` |
| `tmuxpi` | pi | `-pi` | `pi` |
| `tmuxoh` | OpenHands | `-oh` | `openhands` |
| `tmuxki` | Kiro | `-ki` | `kiro-cli chat` |

Kiro is the only one whose command is not its own name.

The aliases are in [.bash_aliases](.bash_aliases), and `tmuxa` beside them
attaches to session `0`, which is the one tmux opens by itself.

Each pane is started through a login shell. A pane inherits the environment of
the tmux server, which was set when the server first started and can be days
old; a login shell reads the profile instead, and finds the same PATH and the
same variables I would.

### Leaving a session

`prefix + d` detaches and leaves everything running, which is usually what I
want.

`exit` closes the pane it is typed in, not the session: a pane ends when its
command ends, a window when its last pane ends, and the session when its last
window ends.

The script reattaches to an existing session without rebuilding what was closed.
If only one pane is left behind, that is what comes back.

## Key bindings

In [.tmux.conf](.tmux.conf):

```tmux
bind-key e split-window -v -f -c "#{pane_current_path}" "emacs -nw"
bind-key v split-window -v -f -c "#{pane_current_path}" "nvim"
```

Two bindings so the workstation is not tied to a single editor: neither is
required, an editor I do not install is simply a key I do not press.

| keys | action |
|---|---|
| `prefix + e` | open the editor pane below, full width, with `emacs -nw` |
| `prefix + v` | open the editor pane below, full width, with `nvim` |
| `prefix + z` | zoom the current pane to full screen, press again to restore |
| `prefix + x` | close the current pane |

The last two come with tmux and are here because they are what I reach for
next. `e` and `v` are free in a default tmux: `E` is bound, `e` and `v` are not.

The configuration is read top to bottom and the last binding on a key wins, so
my own bindings belong at the end, after anything that loads a plugin.

## Editors

Emacs runs in the terminal with `emacs -nw`, which is what the binding uses.

Neovim needs its configuration linked where it looks for it:

```sh
ln -s ~/github/nvim ~/.config/nvim
```
