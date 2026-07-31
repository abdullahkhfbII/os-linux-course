# 3. Users, Groups, and Permissions

*Corresponds to: Lab 3*

Linux is a **multi-user** system by design: multiple people (or automated
services) can have accounts on the same machine, and permissions control who
can read, change, or run what. This module covers creating those accounts
and controlling access.

## 3.1 Creating users

```bash
sudo useradd alice
sudo passwd alice
```

- `useradd` creates a new user account and, by default, a matching home
  directory.
- `passwd` sets (or changes) that user's login password. You'll be prompted
  to type it twice. `sudo` is required because only an administrator can
  change another user's password.

### Account and password expiration with `chage`

`chage` ("change age") manages time-based rules on an account:

```bash
sudo chage -E 2026-12-31 alice     # -E sets an EXPIRATION DATE on the account itself
sudo chage -l alice                 # -l LISTS the current expiration settings
sudo chage -M 30 alice               # -M sets how many days until the PASSWORD must be changed
sudo chage -W 5 alice                 # -W sets a WARNING, in days, before the password expires
```

| Flag | Meaning |
|------|---------|
| `-E date` | Account expiration date |
| `-l` | List current expiry settings |
| `-M days` | Maximum password age (force password change) |
| `-W days` | Warn the user this many days before password expiry |

## 3.2 Ownership: `chown`

Every file has an **owner** (a user) and a **group owner**. `chown` changes
who owns a file:

```bash
sudo chown alice file.txt              # change owner only
sudo chown alice:developers file.txt    # change owner AND group in one go
sudo chown :developers file.txt          # change ONLY the group (leave owner unchanged)
```

## 3.3 Groups

A **group** is a named collection of users, used to manage permissions for
many people at once instead of one-by-one.

```bash
sudo groupadd research_team                    # create an empty group
sudo usermod -aG research_team alice            # add alice to the group
getent group research_team                       # list who's in the group
```

- `usermod -aG group user` — `-a` means **a**ppend (add to existing groups
  without removing others the user already belongs to), `-G` specifies the
  supplementary group. **Always use `-a`** with `-G` — forgetting it
  replaces the user's other group memberships entirely, which is a common
  and dangerous mistake.
- `getent group group_name` reads the system's group database and shows its
  members.

> Every command that creates or modifies system-wide accounts/groups needs
> `sudo`, since regular users cannot manage other accounts.

## 3.4 Permissions and binary calculations

Every file/directory has three sets of permissions, one each for: the
**owner**, the **group**, and **others** (everyone else). Each set can have:

| Symbol | Permission | Numeric value |
|--------|------------|----------------|
| `r` | read | 4 |
| `w` | write | 2 |
| `x` | execute | 1 |
| `-` | none | 0 |

(There's also a `d` shown at the very start of a listing, which isn't a
permission at all — it just flags "this is a directory.")

To get a combined number for one set of permissions, **add up** the values
you want. For example: read + write = 4 + 2 = **6**. Read + execute = 4 + 1
= **5**. Full read/write/execute = 4+2+1 = **7**.

A full permission number has **three digits**, one for owner, one for
group, one for others, in that order:

```
chmod 750 file.txt
```

- `7` (owner) = 4+2+1 = read, write, execute
- `5` (group) = 4+1 = read, execute (no write)
- `0` (others) = nothing at all

### Viewing permissions: `ls -l`

```bash
ls -l
# -rwxr-x---  1 alice research_team  220 Jan 10 10:00 script.sh
```

Reading the ten characters at the start:

- Position 1: file type (`-` = regular file, `d` = directory, `l` = symlink)
- Positions 2–4: owner's permissions (`rwx`)
- Positions 5–7: group's permissions (`r-x`)
- Positions 8–10: others' permissions (`---`)

### `chmod` — changing permissions

**Numeric (absolute) style** — sets the exact permissions, ignoring
whatever was there before:

```bash
chmod 750 script.sh
```

**Symbolic style** — adjusts specific permissions relative to the current
ones, without needing to know/recompute the rest:

```bash
chmod u+x script.sh    # u = user/owner,  + = add,  x = execute
chmod g-w script.sh    # g = group,        - = remove, w = write
chmod o=r script.sh    # o = others,       = = set exactly to this
chmod a+r script.sh    # a = all (owner+group+others)
```

> **⚠ Inefficient/risky shortcut:** `chmod 777` gives everyone (owner,
> group, others) full read/write/execute permissions simultaneously. It's
> sometimes used to quickly "make something work," but it's a security risk
> because *anyone* on the system can modify or delete the file. Avoid it
> outside of controlled lab exercises.

## 3.5 Creating a script from within another script (heredoc)

You already know `cat` prints a file's content. A **heredoc** (`<<`) lets
you feed `cat` multiple lines of text directly, without opening an editor —
useful for generating scripts automatically:

```bash
cat << EOF > child_script.sh
#!/bin/bash
echo "I was generated automatically!"
EOF
```

- `cat` — normally prints text.
- `<< EOF` — starts a "here document": everything typed after this, up
  until a line containing exactly `EOF` by itself, is treated as input text
  (not commands).
- `EOF` — just a marker/label; you could use any word, `EOF` is simply the
  conventional choice ("End Of File").
- `> child_script.sh` — redirects that captured text into a new file
  instead of printing it to the screen.

This pattern appears constantly in the exam-style scenarios (Module 10) to
generate a script inside another script.

## 3.6 Try it yourself

Work through
[`scenarios/scenario_1_research_project.sh`](scenarios/scenario_1_research_project.sh)
and
[`scenarios/scenario_2_payroll_security.sh`](scenarios/scenario_2_payroll_security.sh)
before checking the provided solution.

Next: [`04-monitoring-text-processing/README.md`](../04-monitoring-text-processing/README.md)

(Full deep-dive into UID/GID, SUID, SGID, and the Sticky Bit is in Module 9,
which builds directly on the permission basics taught here.)
