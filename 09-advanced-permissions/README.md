# 9. Advanced File Permissions

*Corresponds to: Lab 9*

This module builds directly on Module 3. Make sure you're comfortable with
`chmod`, the `rwx` permission string, and reading `ls -l` output before
continuing.

## 9.1 Permissions recap

Every file has a 10-character permission string, e.g. `-rwxr-x r--`:

- Position 1: file type (`-` = regular file, `d` = directory, `l` = symlink)
- Positions 2–4: owner permissions
- Positions 5–7: group permissions
- Positions 8–10: others permissions

A **symlink** (symbolic link) is a shortcut pointing to another file or
directory — conceptually the same as a shortcut on Windows.

## 9.2 UID and GID — Linux doesn't see names, it sees numbers

Linux does **not** actually track ownership by the name "alice" or "bob" —
internally, every user is a number.

- **UID** (User ID): every user account has a numeric UID. UID `0` is
  always the root account, which bypasses all permission checks entirely.
- **GID** (Group ID): every group has a numeric GID. Files belong to one
  group; users can belong to multiple groups.

Permissions are attached to these **numbers**, not the human-readable
names. This means if you rename a user account but keep the same UID, they
still own all their original files — the OS never actually "sees" the name
change.

### The `id` command

```bash
id                # your own UID, GID, and every group you belong to
id -u              # only your UID
id -g               # only your primary GID
id -G                # ALL group IDs you belong to
id alice              # identity info for a specific user
```

### `/etc/passwd` and the mysterious `x`

Each line in `/etc/passwd` describes one account: username, UID, GID, a
description, home directory, and default shell. The `x` you'll see in this
file is a placeholder — it tells Linux "don't look for the password here,
go check the shadow file instead" (the actual encrypted password is stored
separately, in `/etc/shadow`, which only root can read).

### Viewing numeric ownership directly

```bash
ls -l -n file.txt          # show numeric UID/GID instead of names, for a file
ls -ldn directory_name       # same, but for a directory
```

### Changing ownership by number

```bash
sudo chown 1001:1002 filename    # assign ownership using raw UID:GID numbers
sudo chgrp research_team file.txt  # change ONLY the group ownership
```

Numeric UID/GID ownership is more stable for the kernel to work with than
names — names can be renamed or reused, but the numeric IDs are what
permissions are actually checked against.

## 9.3 SUID (Set User ID)

Normally, when you run a program, it runs with **your own** permissions.
SUID changes this: when set on an executable, running that file makes the
resulting process temporarily adopt the **file owner's** identity instead
of yours.

**The logic:** "When I run this, I temporarily become the owner of the
file."

**Real-world example:** changing your password requires writing to
`/etc/shadow`, a file only root can touch. The `passwd` command has SUID
set (owned by root), so when *you* run `passwd`, the resulting process
briefly runs with root's power — just enough to update that one file.

```bash
chmod 4755 file       # numeric: 4 = SUID bit, plus 755 for normal rwxr-xr-x
chmod u+s file          # symbolic: u = owner/user, +s = add the SUID bit
```

Look at the owner's permission slot in `ls -l`:

- `-rwsrwx---` — lowercase **s**: SUID is set **and** the file is
  executable. This is the correct, working state.
- `-rwSrwx---` — uppercase **S**: SUID is set, but the file is **not**
  executable. This is a misconfiguration — the special bit has nothing to
  "trigger" without the execute permission.

## 9.4 SGID (Set Group ID)

SGID lets a file or directory pass on **group** privileges, instead of the
individual user's, and behaves differently depending on what it's applied
to:

1. **On a file**: the program runs with the file's **group** privileges
   (parallel to how SUID uses the owner's identity).
2. **On a directory**: any new file created inside automatically inherits
   the **directory's** group — not the personal group of whoever created
   it. This is the more commonly tested use, since it's exactly what's
   needed for shared team folders.

```bash
chmod 2775 file_or_dir     # numeric: 2 = SGID bit
chmod g+s file_or_dir        # symbolic: g = group, +s = add the SGID bit
```

Look for `s` in the **group** permission slot: `rwxr-sr-x`.

## 9.5 Sticky Bit

The Sticky Bit is applied to **directories** to act as a security guard for
shared spaces. It restricts deletion: even in a directory that's fully
writable by everyone, a user can only delete files they personally own.

**Why it matters:** without it, a shared folder like `/tmp` set to `777`
(everyone can do everything) would let any user run `rm -rf /tmp/*` and
destroy everyone else's temporary files — even ones they don't own. The
Sticky Bit adds one final check at the moment of deletion: "are you the
owner of this specific file?"

```bash
chmod 1777 dir      # numeric: 1 = Sticky Bit
chmod +t dir          # symbolic: +t = add the Sticky Bit
```

Look for `t`/`T` in the **others** execute slot:

- Lowercase `t`: Sticky Bit is set **and** the directory is executable (so
  anyone can still `cd` into it).
- Uppercase `T`: Sticky Bit is set, but the directory is **not** executable
  for others (they can't even enter it). You get a capital `T` if you set
  the Sticky Bit on a directory whose "others" execute permission is off.

## 9.6 Combining special bits — the fourth digit

`chmod` numeric mode uses a leading **fourth digit** for special bits, in
front of the normal three:

| Special bit | Numeric value | Example command | Symbolic | Visual result |
|---|---|---|---|---|
| SUID | 4 | `chmod 4755 file` | `chmod u+s file` | `rws` (lowercase s) |
| SGID | 2 | `chmod 2775 file` | `chmod g+s file` | `r-s` (lowercase s) |
| Sticky (active) | 1 | `chmod 1777 dir` | `chmod +t dir` | `rwt` (lowercase t) |
| Sticky (inactive) | 1 | `chmod 1666 dir` | `chmod o-x dir` then `chmod +t dir` | `rwT` (capital T) |

Memory trick: for the last digit of the special-bits number, an **odd**
value (1, 3, 5, 7) means "others" execute is on → lowercase `t`; an
**even** value (0, 2, 4, 6) means it's off → capital `T`. The same
odd/even logic parallels the `s`/`S` distinction for SUID.

To enable **all three** special bits (SUID + SGID + Sticky) plus full
`rwx` for everyone:

```bash
chmod 7777 path
```

## 9.7 Real UID vs. Effective UID

| Term | Meaning |
|------|---------|
| **Real UID (RUID)** | Who you actually are — the user who launched the process |
| **Effective UID (EUID)** | Who the kernel *treats you as* during permission checks |

- **Normal binaries** (like `ls`, `mkdir`, `cat`, `sleep`) run with the EUID
  of whoever launched them — RUID and EUID are the same. If a regular user
  tries to `cat /etc/shadow`, it fails, because their EUID has no
  permission to read it.
- **SUID binaries** are the exception: they run with the EUID of the
  file's **owner** (usually root), no matter who launches them. This lets a
  regular user perform one narrow "superuser" task (like `passwd`)
  without granting them full system access.

```bash
sudo find / -perm -4000 -type f 2>/dev/null
```

This searches the whole filesystem for files with the SUID bit set,
silencing "permission denied" errors (`2>/dev/null` — recall this
redirects stderr to the "black hole" device, from the Prerequisites
module) so you get a clean list.

## 9.8 Security considerations: privilege escalation

**Privilege escalation** is when a user gains higher permissions than
they're supposed to have. SUID binaries are a common target: if a
SUID-root program has a vulnerability or is misconfigured, an attacker can
exploit it to gain full administrative control.

Auditing and fixing:

```bash
find / -perm /4000 2>/dev/null      # list every SUID binary on the system
sudo chmod u-s /path/to/suspicious/binary   # remove (disarm) the SUID bit
```

## 9.9 Try it yourself

Work through [`scenarios/scenario_1_shared_secure_directory.sh`](scenarios/scenario_1_shared_secure_directory.sh)
before checking the solution.

Next: [`10-exam-practice/README.md`](../10-exam-practice/README.md) — this
is where every remaining exam-style scenario from the two revision
documents is solved, each as its own standalone script.
