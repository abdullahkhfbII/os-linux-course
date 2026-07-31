# 5. Cron Jobs and Backups

*Corresponds to: Lab 5*

Now that you can write scripts and check disk/memory usage, this module
teaches you to run those scripts **automatically on a schedule**, and to
create/clean up backups — two of the most common exam scenario ingredients.

## 5.1 What is cron?

**Cron** is a background service (see the Prerequisites section on
"daemons") that continuously runs and checks whether any scheduled task
needs to execute right now. Each user has their own list of scheduled
tasks, called their **crontab** ("cron table").

## 5.2 Editing your crontab: `crontab -e`

```bash
crontab -e
```

The very first time you run this, Linux asks which text editor you want to
use for editing the crontab file. Type `1` and press Enter to choose
`nano` (the same editor from Module 1). Your crontab then opens in nano,
ready for you to add a new scheduled line.

## 5.3 Cron syntax

Every line in a crontab has five time fields, followed by the command to
run:

```
minute hour day-of-month month day-of-week  command
  *      *        *          *       *
```

| Field | Range | Meaning |
|-------|-------|---------|
| minute | 0–59 | which minute of the hour |
| hour | 0–23 | which hour of the day (24-hour clock) |
| day-of-month | 1–31 | which day of the month |
| month | 1–12 | which month |
| day-of-week | 0–7 | which day of the week (0 and 7 both mean Sunday, 1=Monday...) |

`*` in any field means "every value" — e.g. `*` in the month field means
"every month."

### Examples

```bash
*/5 * * * * echo "Running every 5 minutes" >> ~/cron_demo.txt
0 * * * *   echo "Hourly task" >> ~/cron_demo.txt          # minute 0 of every hour
0 18 * * *  echo "Daily backup" >> ~/cron_demo.txt           # every day at 18:00 (6 PM)
0 9 * * 1   echo "Monday meeting reminder" >> ~/cron_demo.txt  # every Monday at 9:00
0 0 1 * *   echo "Monthly report" >> ~/cron_demo.txt          # midnight on the 1st of every month
```

`*/5` means "every 5 units" — in the minute field, that's every 5 minutes.

### Listing and removing cron jobs

```bash
crontab -l        # list all scheduled jobs for the current user
crontab -r         # remove ALL cron jobs for the current user (⚠ irreversible, no undo prompt)
```

To remove just **one** specific job without wiping everything, filter it
out with `grep -v` and feed the rest back in:

```bash
(crontab -l | grep -v "check_desktop_size.sh") | crontab -
```

- `crontab -l` lists the current jobs.
- `grep -v "pattern"` prints every line **except** the one matching the
  pattern (i.e., it removes that job from the list).
- `| crontab -` feeds the filtered list back in as the new crontab. The
  trailing `-` tells `crontab` to read from standard input (piped data)
  instead of from a file.

## 5.4 Adding a cron job without opening nano

You can also append a new scheduled job directly from the command line,
without going through the interactive editor:

```bash
(crontab -l; echo "1 * * * * ~/check_desktop_size.sh") | crontab -
```

Breaking this down:

- `crontab -l` lists the *existing* jobs.
- `;` runs the next command afterward (regardless of whether the first
  succeeded — this differs from `&&`, which only continues if the previous
  command succeeded).
- `echo "..."` prints the *new* schedule line you want to add.
- The parentheses `( ... )` **group** both commands so their combined
  output (old jobs + new job) is treated as one single stream.
- `| crontab -` feeds that combined list back in, replacing the crontab
  with "everything that was there before, plus this one new line."

> **⚠ Important:** cron jobs run silently in the background. If a
> scheduled script contains `echo`, that output will **not** appear on your
> terminal screen — there's no terminal attached to a cron job. Redirect
> output to a file (`>>`) if you need to see it later.

## 5.5 `watch` — repeating a command live

```bash
watch df -h
```

`watch` re-runs a given command repeatedly (every 2 seconds by default) and
shows the output on screen, refreshing in place. Useful for *watching*
something change in real time, as opposed to cron which runs unattended in
the background.

## 5.6 Creating backups with `tar`

```bash
tar -czvf directory_location/directory_name_$(date +%F).tar.gz file_name
```

`%F` is a date format specifier meaning the full date in `YYYY-MM-DD`
format. `$(date +%F)` runs the `date` command and captures its output
(command substitution, from Module 2), embedding today's date directly into
the backup's filename — so scheduled daily/weekly backups never overwrite
each other.

## 5.7 Finding and deleting old files: `find`

```bash
find Documents/ -type f -mtime +30 -exec rm {} \;
```

Breaking this down piece by piece:

- `find Documents/` — start searching inside the `Documents` directory
  (and every subdirectory beneath it).
- `-type f` — only match regular **f**iles (not directories, not symlinks).
- `-mtime +30` — only match files whose **m**odification **time** is more
  than 30 days ago.
- `-exec rm {} \;` — for every file found, **exec**ute the command `rm` on
  it. `{}` is a placeholder that `find` replaces with each matching
  filename; `\;` marks the end of the `-exec` command (the backslash stops
  the shell from interpreting the semicolon itself before `find` sees it).

You'll also frequently see the equivalent, slightly more efficient form:

```bash
find Documents/ -type f -mtime +30 -delete
```

`-delete` removes the matched files directly, without needing to launch a
separate `rm` process for each one.

## 5.8 Try it yourself

Work through the three scenarios in [`scenarios/`](scenarios/) — scheduling
a daily disk report, timestamped backups, and a combined backup + cleanup
system — before checking the provided solutions.

Next: [`06-networking-fundamentals/README.md`](../06-networking-fundamentals/README.md)
