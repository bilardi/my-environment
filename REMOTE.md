# Working from the mini PC

The home Fedora stays always on and does all the work: coding agents, git,
Jekyll, the browser. The mini PC, an old netbook with 2 GB of RAM, only shows
it: the text console over ssh, and the Firefox of the home Fedora through xpra,
full screen on a bare X with matchbox.

```
      mini PC (Fedora minimal)                    home Fedora (always on)
+--------------------------------+          +--------------------------------+
| text console --- ssh ------------------------> tmux, claude, git, jekyll    |
| X + matchbox                   |          |                                |
|   xpra ------ xpra over ssh -----------------> Firefox, Keeper, localhost  |
+--------------------------------+          +--------------------------------+
                      \__________ tailscale, from any network _________/
```

No browser runs on the mini PC: Brave and Firefox are already too heavy for it.
Running at home, Firefox sees the real `localhost`, so a Jekyll site served
there needs no tunnel.

## Why xpra

xpra brings a single window, Firefox, onto the mini PC. The session lives on the
home Fedora and survives disconnections: detach, attach again from anywhere, the
tabs are still there. It runs over ssh, so it needs nothing else open.

A Firefox profile can be open in one instance only, so Firefox runs either
inside the xpra session or on the home desktop, never in both: the switch is in
[Every day](#every-day).

## Why matchbox

Without a window manager, Firefox cannot go full screen and its dialogs, the
Keeper popup among them, open where they happen to. matchbox keeps every window
full screen, one at a time, which is what a 10 inch screen at 1024x600 needs. It
grabs no key combination, so all of them reach Firefox: ratpoison, as small,
takes Ctrl+T for itself.

## Why tailscale

The mini PC has to reach home from other networks. Tailscale joins both machines
to the same private network, with the home Fedora reachable as `fedora` from
anywhere: no port opened on the router, and it works behind the carrier grade
NAT of many providers, where a port forward would not.

Tailscale has no accounts of its own: it logs in with an existing identity,
GitHub, Google, Microsoft, Apple or a passkey. A personal one, as a work Google
account ties the network to the company domain. Both machines log in with the
same identity, and the free personal plan is enough.

## The USB stick

The mini PC gets Fedora minimal, the same release as the home Fedora, so that
the xpra client and server are the same version. Its download is the
Everything network installer, listed on
[fedoraproject.org/misc](https://fedoraproject.org/misc/#everything), whose
files are in
[releases/44/Everything/x86_64/iso](https://download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/iso/)
together with the `CHECKSUM` file.

```sh
sha256sum -c --ignore-missing Fedora-Everything-44-*-x86_64-CHECKSUM
```

Writing it erases the whole stick. Fedora Media Writer (`dnf install
mediawriter`, then "Select .iso file") picks the device from a list, which is
safer than `dd`, where a wrong device name erases a disk. GNOME mounts the stick
as soon as it is plugged in, and again after writing it:

```sh
lsblk  # find the stick, for instance /dev/sdb, never a partition like /dev/sdb1
sudo umount /dev/sdX?*  # only when lsblk shows mount points
sudo dd if=Fedora-Everything-netinst-x86_64-44-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
sync
udisksctl power-off -b /dev/sdX
```

Written correctly, the stick shows three partitions: the installer, labelled
`Fedora-E-dvd-x86_64-44`, a small EFI one and a tiny one for the BIOS boot.

## Booting from it

An old BIOS, without UEFI, may not boot from the stick even with "Removable
Dev." first:

- it lists a USB stick among the hard disks, not among the removable devices:
  under "Boot", "Hard Disk Drives", set the stick as "1st Drive" above the
  internal disk, then "Hard Disk" first in "Boot Device Priority"
- it looks for USB devices only at power on: plug the stick in before, and power
  off, not just restart, when moving it to another port
- a fast boot option, "Boot Booster" on the Asus netbooks, skips the boot
  devices altogether and has to be disabled

After the installation, the internal disk goes back to "1st Drive".

## Installing the mini PC

The text installer, as the graphical one runs out of memory with 2 GB: it
stalled on a grey screen, and once more overnight. On the boot menu press `e`,
add these at the end of the `linux` line and start with Ctrl+X:

```
inst.text inst.disklabel=mbr
```

`inst.disklabel=mbr` because Fedora uses a GPT disk even without UEFI, and an
old BIOS may stop on a blinking cursor in front of it. "Booting a command list"
followed by a minute of black screen is the kernel loading from the stick.

The installer runs in tmux: Ctrl+B 2 is a shell, Ctrl+B 1 the installer. It has
no wifi screen, so the wifi comes first, from that shell:

```sh
nmcli device wifi list
nmcli device wifi connect "<network>" password "<password>"
```

The keyboard is the US one until the first boot: a password made of letters and
digits only is typed the same on an Italian keyboard, where `/` is on the `-`
key and `_` on Shift and the `'` key. Then, by name, as the numbers change:

- "Language settings": left as it is
- "Time settings": Europe/Rome, or later with `timedatectl`
- "Installation source": the network, "Closest mirror", or `https://` with
  `download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/`
  as "Repository URL". The stick holds no packages, so a source on the stick
  fails to download the metadata. Then `r` until it is set up. The default
  versions, not the updates, as the updates add metadata the installer has to
  hold in memory
- "Software selection": "Fedora Custom Operating System", the minimal one, with
  "Common NetworkManager Submodules", which has the wifi support the installed
  system needs at the first boot, and "Standard"
- "Installation destination": the internal disk, "Use All Space", automatic
  partitioning. It erases the whole disk
- "Network configuration": only "Set host name", a name of its own as in step 2
  of [Setting it up](#setting-it-up-in-this-order)
- "Root password": disabled
- "User creation": `bilardi`, as an administrator

`b` begins. "Configuring systemd-udev" takes many minutes on an old CPU. At
"Installation complete", Enter reboots: the stick comes out only then, during
the reboot, since the installer itself runs from it.

## First boot

1. The Italian keyboard, then the real password:
   ```sh
   sudo localectl set-keymap it
   sudo localectl set-x11-keymap it
   passwd
   sudo timedatectl set-timezone Europe/Rome
   ```
2. The network, before anything is downloaded: `nmcli device status` has to show
   the wifi as `connected`, and `ping -c 3 fedoraproject.org` has to answer
3. What is not installed is not upgraded either, so first
   [bin/remote-slim](bin/remote-slim), one step at a time, reading what `dnf`
   lists before answering:
   ```sh
   bash remote-slim weak-deps
   bash remote-slim firmware
   bash remote-slim services
   bash remote-slim extras
   sudo dnf upgrade
   sudo reboot
   ```
   On this netbook it went from 616 packages to 416. `polkit` goes away with
   them, so `nmcli` changes, `reboot` and the `*ctl` settings need `sudo`

## Setting it up, in this order

1. On the home Fedora:
   ```sh
   bash bin/remote-server
   ```
   It installs xpra, enables sshd, masks the sleep targets and joins tailscale.
   The GNOME settings under "never suspend" in [IMPORT.md](IMPORT.md) are not
   enough on their own, since the login screen suspends regardless of them
2. On the mini PC, first a name of its own, for instance `eeepc`: left to the
   default it is `fedora` too, and tailscale, where names are unique, would
   call it `fedora-1`, too close to the home Fedora it has to reach
   ```sh
   sudo hostnamectl set-hostname <name>
   sudo dnf install git
   git clone https://github.com/bilardi/my-environment
   bash my-environment/bin/remote-client
   ```
   It refuses to run while the name is still `fedora`. It installs X, matchbox,
   git, xpra with the GTK pieces its package does not declare, and the wifi
   support, offers `nmtui` for the wifi, joins tailscale, creates a key of its
   own and copies it to the home Fedora, then writes `Host fedora` in
   `~/.ssh/config` and the xpra session in `~/.xinitrc`, only when they are
   missing. The tailscale login link comes as a QR code too, for the phone. The
   key keeps its default name, `id_ed25519`: ssh does not try other names
3. On the mini PC, on another console (Ctrl+Alt+F3), check the key: `ssh fedora`
   has to log in without asking for a password. Keep this session open
4. On the home Fedora:
   ```sh
   bash bin/remote-harden
   ```
   It installs [01-no-password.conf](bin/etc/ssh/sshd_config.d/01-no-password.conf),
   checks the configuration and reloads sshd. It refuses to run while
   `~/.ssh/authorized_keys` is empty
5. On the mini PC, on another console, `ssh fedora` has to log in again, and
   `ssh -o PubkeyAuthentication=no fedora` has to fail with `Permission denied`.
   Only now close the session kept open at step 3
6. The xpra session, started once on display `:100`. Firefox on the home desktop
   reopens its tabs with "Open previous windows and tabs" (search `previous` in
   `about:preferences`), and closes with Ctrl+Q. Then, on the mini PC:
   ```sh
   ssh fedora xpra start :100 --start=firefox
   startx
   ```
   Firefox fills the screen. Back on a console, `ssh fedora xpra detach :100`
   closes X on the mini PC, and a new `startx` has to show the same tabs. When
   X closes on its own, `startx > ~/startx.log 2>&1` keeps what xpra printed
7. Repeat step 6, without the `xpra start`, from another network: the phone
   hotspot is enough

## Every day

- the console is the shell: `ssh fedora`, then the tmux sessions in
  [TMUX.md](TMUX.md), which stay alive when the connection drops. Emacs and tmux
  get every key combination a terminal can send
- the coding agents run on the home Fedora, each in its own tmux session: from
  the mini PC `tmux ls` lists them and `tmux attach -t <session>` joins one, as
  in [Commands](#commands)
- `startx` shows Firefox. Ctrl+Alt+F3 goes back to a console while it runs, and
  the console where X runs, F1 or F2, goes back to Firefox. Detaching from xpra,
  as in step 6, closes X
- leaving home, Firefox moves into the xpra session: Ctrl+Q closes it on the
  home desktop, then `fxstart`, from either machine, starts it inside the
  session. Back home, `fxstop` closes the session and `firefox` reopens
  the same tabs on the desktop
- when Firefox was left open on the home desktop, `fxstart` cannot open the
  profile, which is in use: `ssh fedora pkill firefox` closes it from the mini
  PC, and the session reopens its tabs
- with a passphrase on the key, xpra asks for it as well: `eval "$(ssh-agent)"`
  and `ssh-add` before `startx` ask for it once
- away from home the image depends on the upload speed of the home connection:
  when scrolling stutters, `--encoding=jpeg --quality=40 --refresh-rate=10`
  after `xpra attach` in `~/.xinitrc` makes it lighter, enough on a phone hotspot
- `Failed to link: error: Exceeded max TGSI temps` at every `startx` comes from
  X, which accelerates with OpenGL on the old Intel graphics: it is harmless.
  Should drawing glitches show up, `Option "AccelMethod" "none"` in a `Device`
  section under `/etc/X11/xorg.conf.d/` turns that off

## Commands

What is typed on the mini PC, at hand when this page is not.

The checks, when something does not answer:

```sh
nmcli d                        # CONNECTION is the current network
tailscale ping fedora          # pong: home is reachable
tailscale status               # "relay" when the direct path is blocked, slower
ssh fedora xpra list           # LIVE session at :100: Firefox is there
journalctl -b -p err           # errors since boot
```

The network, only from the local console, never inside `ssh fedora`, and with
`sudo` for the changes, as polkit is gone:

```sh
nmcli device wifi list         # networks around
sudo nmcli device wifi connect "<network>" password "<password>"
nmcli connection show          # saved networks
sudo nmcli connection up "<network>"
```

The tmux sessions on the home Fedora:

```sh
ssh fedora
tmux ls
tmux attach -t <session>
tmux attach -d -t <session>    # and detaches the other screens
tmux kill-session -t <session>
```

| keys | action |
|---|---|
| Ctrl+B % | new pane on the right |
| Ctrl+B " | new pane below |
| Ctrl+B arrows | move between panes |
| Ctrl+B [ | scroll with PgUp, PgDn and the arrows, `q` to exit |
| Ctrl+B d | detach, the session stays alive |

The rest:

- Ctrl+Alt+F3 or F4 opens another console, F1 or F2 goes back to X
- `scp fedora:/tmp/<file> ~/` brings a file from home, `scp ~/<file> fedora:/tmp/`
  takes it there
- `sudo reboot`, and `sudo poweroff` after `fxdetach`

## Aliases

The xpra session on display `:100` has short aliases: on the home Fedora they
talk to the session directly, on the mini PC they go through ssh. The ones of the home Fedora are in
[.bash_aliases](.bash_aliases), the ones of the mini PC in
[.bashrc.d/remote](.bashrc.d/remote), which `bin/remote-client` links into the
`~/.bashrc.d/` of the mini PC: its default `~/.bashrc` sources that directory,
the home one does not.

| alias | home Fedora | mini PC |
|---|---|---|
| `fxstart` | starts the session with Firefox, after Ctrl+Q on the desktop | the same, over ssh |
| `fxdetach` | | closes X, Firefox stays alive at home |
| `fxstop` | closes the session and its Firefox, before `firefox` on the desktop | the same, over ssh, on the way home |

## Keeping both on the same release

A Fedora release is supported for about 13 months, so once a year both machines
move to the next one with `dnf system-upgrade`. They move together: xpra client
and server are expected to be the same version, and `dnf upgrade` keeps them
aligned in between.
