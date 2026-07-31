# 1. Introduction to the Linux Operating System

*Corresponds to: Lab 1*

If you've never used a command line before, read this slowly and try every
command as you go. Nothing here is "read only" — open a terminal now.

## 1.1 What is Linux?

Linux is a free, open-source operating system. "Open source" means the
underlying code is public — anyone can read it, change it, and share their
own version. This is different from Windows or macOS, which are owned and
controlled by a single company. Because of this openness, Linux is the base
for everything from Android phones to web servers to supercomputers. It's
known for being stable (rarely crashes), secure, and flexible.

## 1.2 What is a Linux "distribution" (distro)?

The Linux **kernel** by itself is just the core engine — it's not something
you'd install and start using directly. A **distribution** packages the
kernel together with system tools, a package manager, and (usually) a
graphical interface, into something installable. Different distros target
different audiences:

- **Ubuntu, Fedora, Debian** — general-purpose, beginner-friendly
- **Arch, Gentoo** — for advanced users who want full manual control
- **Kali Linux** — pre-loaded with security/penetration-testing tools
- **Raspbian** — tuned for the Raspberry Pi's hardware

This course uses **Ubuntu**, made by a company called Canonical, because it
balances ease of use with the full power of Linux underneath.

## 1.3 The Ubuntu / Linux filesystem structure

Everything lives in one tree starting at `/` (the root directory — not to be
confused with the "root user," which we'll meet in Lab 3). A few directories
you'll touch constantly in this course:

| Directory | What lives there |
|-----------|-------------------|
| `/` | The root of the entire filesystem. Everything is under here. |
| `/home` | Each regular user gets a personal folder here, e.g. `/home/student`. |
| `/root` | The home directory belonging specifically to the root (admin) user. |
| `/etc` | System-wide configuration files (e.g. `/etc/ssh/sshd_config`, used in Lab 6). |
| `/var` | Data that changes often: logs, caches, mail. `/var/log` is used a lot in later labs. |
| `/dev` | Special files representing hardware devices (disks, terminals). |
| `/tmp` | Temporary files, cleared periodically. Classic example for the Sticky Bit (Lab 9). |

## 1.4 The terminal and your first commands

The terminal (also called the command-line interface, or CLI) lets you type
text commands instead of clicking icons. It's not "for hackers" — it's just
a faster, more precise way to control the system, and it's the only way to
write automation scripts, which is most of this course.

### Where am I? — `pwd`

`pwd` = **p**rint **w**orking **d**irectory. It tells you the absolute path
of the folder you're currently "standing in."

```bash
pwd
# /home/student
```

### What's here? — `ls`

`ls` = **l**i**s**t. Shows the files and folders inside your current
directory.

```bash
ls
# Desktop  Documents  Downloads  Pictures
```

Useful options: `ls -l` (long format — shows permissions, owner, size, date;
this becomes essential in Lab 3 and Lab 9), `ls -a` (show hidden files,
which start with a dot), `ls -la` (both together).

### Moving around — `cd`

`cd` = **c**hange **d**irectory.

```bash
cd Documents          # go INTO the Documents folder (relative path)
cd /home/student      # go to an exact location (absolute path)
cd ..                 # go UP one level, to the parent directory
cd ~                  # jump straight to your home directory
cd -                  # jump back to the PREVIOUS directory you were in
```

### Reading the manual — `man`

Forget a command's options? Every built-in Linux command has a manual page.

```bash
man ls
# Opens a scrollable manual. Press 'q' to quit.
```

## 1.5 Creating directories and files

### `mkdir` — make directory

```bash
mkdir Projects              # create one folder called Projects
mkdir -p a/b/c               # create nested folders in one go (creates a, then a/b, then a/b/c)
```

The `-p` flag ("parents") is important: without it, `mkdir a/b/c` fails if
`a` doesn't already exist. `-p` creates every missing parent along the way.

### `touch` — create an empty file

```bash
touch notes.txt
# creates an empty file called notes.txt (or updates its "last modified" time if it already exists)
```

### `echo` — print text (and write it to files)

```bash
echo "Hello world"                    # just prints to the screen
echo "Hello world" > notes.txt         # OVERWRITES notes.txt with this text
echo "Another line" >> notes.txt       # APPENDS this text to notes.txt, keeping what was there
```

Remember from the prerequisites: `>` and `>>` are stdout redirection.
`>` replaces the whole file's content; `>>` adds to the end.

### `cat` — show a file's contents

```bash
cat notes.txt
```

### `nano` — a simple text editor

```bash
nano notes.txt
```

This opens a full-screen text editor inside the terminal (creating the file
if it doesn't exist). Type normally to edit. To save and exit:

1. Press `Ctrl + X` (tells nano you want to exit)
2. Press `Y` (confirms you want to save changes)
3. Press `Enter` (confirms the filename)

> **Beginner tip:** nano shows its own shortcuts at the bottom of the screen
> (the `^` symbol means "Ctrl"). You cannot use your mouse to click a "Save"
> button — everything is keyboard shortcuts.

## 1.6 File operations: copy, move, rename, delete

| Command | What it does |
|---------|--------------|
| `cp source.txt dest.txt` | Copies a file |
| `mv old.txt new.txt` | Renames a file (same command as move!) |
| `mv file.txt folder/` | Moves a file into a folder |
| `rm file.txt` | Deletes a file **permanently** |
| `rmdir folder` | Deletes a folder, but only if it's **empty** |
| `rm -r folder` | Deletes a folder and everything inside it, recursively |

> **⚠ CAUTION:** Linux does **not** ask "are you sure?" before deleting.
> There is no Recycle Bin/Trash for terminal deletions. `rm -r` on the wrong
> folder is permanent and unrecoverable. Always double-check the path before
> pressing Enter.

## 1.7 Archiving vs. compressing

These are two different, related ideas:

- **Archiving** bundles many files/folders into one single file, for
  organization or backup. It does **not** shrink the total size. The classic
  tool is `tar`.
- **Compressing** shrinks the size of data to save space or speed up
  transfer, using algorithms like `gzip`, `bzip2`, or `xz`.

In practice, you almost always do both at once: archive first, then
compress the resulting archive.

### `tar` command breakdown

```bash
tar -cvf backup.tar myfolder/
```

- `-c` = **c**reate a new archive
- `-v` = **v**erbose (print each file as it's added, so you can watch progress)
- `-f` = the next argument is the archive's **f**ilename
- `-x` = e**x**tract (opposite of `-c`)
- `-z` = also compress/decompress with **g**zip (adds `.gz`, giving `.tar.gz`)

```bash
tar -cvf backup.tar myfolder/          # archive only (no compression)
tar -czvf backup.tar.gz myfolder/       # archive AND compress
tar -xvf backup.tar                     # extract a plain .tar archive
tar -xzvf backup.tar.gz                 # extract a compressed .tar.gz archive
```

A memory trick: the letters can go in almost any order after the dash
(`-cvf` or `-cfv` work the same), but by convention people write `czvf` /
`xzvf` and you'll see this exact spelling throughout the labs and exam
scenarios.

## 1.8 `sudo` — running commands as administrator

Regular user accounts are deliberately limited — they can't change system
files or install software, to protect the system from mistakes or malware.
`sudo` ("**s**uper**u**ser **do**") temporarily elevates a single command to
run with administrator (root) privileges.

```bash
sudo apt update              # run just THIS command as admin
whoami                       # shows your normal username
sudo -i                      # open a whole new shell AS root (like "Run as Administrator")
whoami                       # now shows "root"
exit                         # leave the root shell, return to your normal user
```

> **⚠ CAUTION:** Anything you do with `sudo` can modify or break core system
> files. Use it only when a command specifically requires it (usually
> because the lab/task tells you to).

## 1.9 Try it yourself

Once you're comfortable with the commands above, work through
[`scenarios/scenario_1_document_organization.sh`](scenarios/scenario_1_document_organization.sh)
and
[`scenarios/scenario_2_work_summary.sh`](scenarios/scenario_2_work_summary.sh)
**without looking at the answer first** — then compare. These are the
original Lab 1 practice scenarios, solved in the exact one-command-per-line
style your Lab Test answers should use.

See also [`examples/`](examples/) for each command demonstrated in isolation.

Next: [`02-bash-scripting/README.md`](../02-bash-scripting/README.md)
