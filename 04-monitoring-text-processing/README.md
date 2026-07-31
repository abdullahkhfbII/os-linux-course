# 4. Monitoring and Text Processing (`free`, `df`, `du`, `grep`, `awk`)

*Corresponds to: Lab 4*

This module covers checking system resources (memory, disk) and the two
most important text-filtering tools in Linux: `grep` and `awk`. These come
up constantly in the cron/backup and network modules that follow.

## 4.1 Memory: `free`

```bash
free
free -g       # show sizes in gigabytes
free --mega    # show sizes in megabytes
free --kilo    # show sizes in kilobytes
free --help    # see every available option
```

Two key rows in the output:

- **Mem** — your physical RAM.
- **Swap** — a reserved portion of your hard disk that Linux uses as
  overflow when RAM is full. It's much slower than RAM, but prevents
  crashes by moving inactive data out of RAM temporarily.

## 4.2 Disk space: `df` (disk free)

```bash
df
df -h     # human-readable sizes (e.g. "4.2G" instead of a huge number of bytes)
```

Key columns:

- **Filesystem** — the storage device or virtual filesystem being measured.
  `tmpfs` is a temporary filesystem stored in RAM; `/dev/sr0` is typically a
  CD/DVD drive.
- **1K-blocks** — total size in kilobytes.
- **Mounted on** — the directory where this filesystem is attached
  ("mounted"). Linux doesn't use drive letters (`C:`, `D:`) like Windows —
  every storage device is attached somewhere inside the single `/` tree.

## 4.3 Directory size: `du` (disk usage)

```bash
du -h                  # show the size of the current directory and everything inside it
du -h Documents/        # show sizes for a specific folder
du -sh Documents/       # -s = summarize: just ONE total line for the whole folder
```

## 4.4 `grep` — filtering text by pattern

```bash
grep "pattern" file.txt
```

`grep` ("**g**lobal **r**egular **e**xpression **p**rint") prints only the
lines from a file (or from piped input) that match a given pattern.

| Option | Meaning |
|--------|---------|
| `-n` | show line numbers alongside matches |
| `-v` | invert the match — show lines that do **NOT** contain the pattern |
| `-c` | count the matching lines instead of printing them |
| `-i` | ignore case (so "Error" and "error" both match) |
| `-o` | print only the matching part of the line, not the whole line |
| `-E` | enable extended regex syntax (needed for `+`, covered in Prerequisites §10) |

```bash
grep -n "systemd" /var/log/syslog       # find "systemd" mentions, with line numbers
grep -v "systemd" /var/log/syslog        # find every line WITHOUT "systemd"
grep -c "error" /var/log/syslog           # count how many lines mention "error"
grep -i "error" /var/log/syslog            # case-insensitive search
```

### Combining commands with pipes

`grep` is almost always used with a **pipe** (`|`), taking the output of
another command as its input:

```bash
ps -ef | grep firefox
```

`ps -ef` lists every running process; the pipe sends that entire list into
`grep`, which filters it down to only lines mentioning "firefox."

### Extracting patterns with `grep -oE`

```bash
grep -oE "[A-Z]"       # print only matching uppercase letters
grep -oE "[a-z]"       # print only matching lowercase letters
grep -oE "[0-9.]+"      # print only matching numbers (digits and decimal points)
grep -oE "[0-9.]+" | bc  # extract a number AND convert it to something bc can do math with
```

- `-o` prints *only* the matched text, not the whole line.
- `-E` enables extended regex, required for `+` ("one or more") to work.

## 4.5 `awk` — extracting specific columns

`awk` splits each line of input into columns (by default, separated by
whitespace) and lets you print specific ones.

```bash
command | awk 'NR==2 {print $4}'
```

- `NR` = the current row (line) number being processed.
- `$1, $2, $3...` = the 1st, 2nd, 3rd... column (field) of that row. (`$0`
  refers to the whole line.)
- So `NR==2 {print $4}` means: "on row 2, print column 4."

> **Fun fact from the original lab:** AWK isn't an acronym for anything
> technical — it's named after the initials of its three creators (Aho,
> Weinberger, and Kernighan).

### Chaining multiple pipes

```bash
command1 | command2 | command3 | command4
```

Each pipe sends the previous command's output as the next command's input,
letting you process data step-by-step, e.g. `du -sh` → `awk` to extract a
size number → `grep`/`bc` to convert units → `if` to compare against a
threshold.

## 4.6 Putting it together: a monitoring script

The original lab builds a script that checks whether the Desktop folder
exceeds a size threshold. The tricky part: `du -sh` gives a size like
`450M` or `2.1G` — a mix of a number and a unit — and Bash cannot compare
`"2.1G"` against a plain number directly. The approach:

1. Get the human-readable size with `du -sh`.
2. Use `awk` to grab just the size field (e.g. `2.1G`).
3. Use `grep -oE` to separate the numeric part from the unit letter.
4. Convert everything to the same unit (e.g. gigabytes) using `bc` for the
   math (dividing by 1024 to go from M→G, or 1024×1024 to go from K→G).
5. Compare the converted number against the threshold with `bc` /`(( ))`.
6. Print a warning or confirmation message accordingly.

See [`examples/04_monitoring_script.sh`](examples/04_monitoring_script.sh)
for the fully commented version of this exact script.

## 4.7 Try it yourself

Work through the three scenarios in
[`scenarios/`](scenarios/) — filesystem usage monitoring, RAM/Swap
monitoring, and file-size monitoring with arrays — before checking the
provided solutions.

Next: [`05-cron-jobs-and-backups/README.md`](../05-cron-jobs-and-backups/README.md)
