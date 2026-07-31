# 8. Multiprocessing

*Corresponds to: Lab 8*

This is one of the two most heavily-tested topics (alongside Module 9) in
the real Lab Test 2 scenarios provided. Take your time here.

## 8.1 Multiprocessing vs. Multithreading

- **Multiprocessing**: running a program as multiple **processes**, each
  with its own memory space and its own Process ID (PID). Processes don't
  share memory by default; they communicate via pipes, sockets, or explicit
  shared memory.
- **Multithreading**: running multiple **threads** *within the same
  process*. Threads share the same memory space, communicate faster, and
  have lower overhead than separate processes — but a crash in one thread
  can affect the whole process, whereas one process crashing doesn't affect
  others.

| Feature | Multiprocessing | Multithreading |
|---------|------------------|-----------------|
| Unit | Process | Thread |
| Memory | Separate | Shared |
| Isolation | Strong (safe) | Weak (risk of conflicts) |
| Communication | Slower (via IPC) | Faster (shared memory) |
| Overhead | Higher | Lower |
| Failure impact | One crash doesn't affect others | One crash may affect the whole process |

This module (and the exam) focuses on **multiprocessing**.

## 8.2 What is a process?

A **process** is a program currently running in memory — your terminal,
your web browser, the shell itself, all count as processes. Every process
has:

- a **PID** (Process ID) — a unique number identifying it
- a **PPID** (Parent Process ID) — the PID of whichever process created it
- memory, CPU usage, an owner, a state, and a list of open files

## 8.3 Viewing processes

### `ps` — snapshot of current processes

```bash
ps           # only processes tied to YOUR current terminal session
ps -ef        # every process on the system, full format
```

`ps -ef` columns: `UID` (owner), `PID`, `PPID` (parent), `CMD` (the full
command). This lets you trace parent-child relationships directly — for
example, PID 1 is almost always `systemd`, the ancestor of nearly every
process on an Ubuntu system.

### `$$` — the current shell's own PID

```bash
echo $$
```

### `pstree -p` — visualize the process tree

```bash
pstree -p
```

Shows processes nested under their parents, e.g.
`systemd(1)---bash(372)---pstree(674)`, making parent-child relationships
easy to see at a glance.

### `top` — live, constantly updating view

```bash
top
```

Shows total tasks, running vs. sleeping counts, zombie counts, CPU and
memory usage, updating in real time. Press `q` to quit.

## 8.4 Foreground vs. background processes

```bash
sleep 60          # runs in the FOREGROUND: your terminal is stuck/busy until it finishes
sleep 60 &         # the trailing & runs it in the BACKGROUND: terminal is immediately free
```

When you background a process with `&`, Bash prints something like
`[1] 1436` — `1` is the **job number** (specific to this shell session),
`1436` is the process's actual PID.

```bash
jobs               # list the background jobs started from THIS shell
```

## 8.5 Finding process IDs by name

```bash
pgrep sleep         # print the PID(s) of any process named "sleep"
ps -p <PID>          # show info about one specific process
ps -o pid,ppid,stat,cmd -p <PID>   # customize exactly which columns to display
```

Common process states (`STAT` column):

| Code | Meaning |
|------|---------|
| `R` | Running |
| `S` | Sleeping (waiting for something) |
| `T` | Stopped (paused) |
| `Z` | Zombie |

## 8.6 Signals and `kill`

`kill` doesn't necessarily mean "destroy immediately" — it **sends a
signal** to a process, and the process decides how to respond (unless the
signal specifically forces termination).

| Signal | Number | Meaning |
|--------|--------|---------|
| `SIGTERM` | 15 | Politely ask the process to terminate — it can clean up, catch it, ignore it, or delay it. **This is the default signal `kill` sends if you don't specify one.** |
| `SIGKILL` | 9 | Force termination immediately — cannot be caught, ignored, or delayed |
| `SIGSTOP` | 19 | Pause ("suspend") the process |
| `SIGCONT` | 18 | Resume a paused process |

```bash
kill <PID>            # sends SIGTERM (15) by default -- polite request
kill -9 <PID>           # sends SIGKILL -- force it
kill -STOP <PID>         # pause the process
kill -CONT <PID>          # resume it
```

### `killall` vs. `pkill`

```bash
killall sleep      # kills processes matching the EXACT name "sleep"
pkill sleep          # kills processes matching a PATTERN (more flexible)
```

## 8.7 Inspecting a process through `/proc`

```bash
cat /proc/<PID>/status
```

Every running process has a corresponding folder inside `/proc`, named
after its PID, exposing detailed kernel-level information: process name,
state, PID, parent PID, user ID, and much more.

## 8.8 `wait` — waiting for a background process to finish

```bash
sleep 30 &
pid=$!          # $! stores the PID of the MOST RECENTLY backgrounded process
wait $pid        # pause THIS script here until that process finishes
echo "Done waiting"
```

`wait` is a shell built-in specifically for this purpose: when a script
starts background processes with `&`, `wait` lets the script pause and
block until those background processes actually finish, instead of
continuing (or exiting) while they're still running.

## 8.9 `fork()` and `exec()` — how new processes are actually created

> **⚠ Background theory:** you won't call `fork()`/`exec()` directly in
> Bash (they're C system calls), but understanding them explains *why*
> everything above behaves the way it does.

1. **Parent calls `fork()`**: the current process is duplicated. Now there
   are two nearly-identical processes — the original **parent** and a new
   **child** — both continuing to run from the exact same point in the
   code.
2. **Child calls `exec()`**: the child process replaces its own memory with
   a completely different program. `exec()` does **not** create a new
   process — it overwrites the child's own memory with new code.
3. **Parent calls `wait()`**: the parent process pauses and waits for the
   child to finish, preventing zombie processes and uncontrolled execution
   order.

After `fork()`, both processes are running the same code, but:

- the **parent** receives the child's PID as the return value,
- the **child** receives `0`.

Bash performs this fork+exec sequence implicitly, every single time you run
any command:

```
ls                 -->  1) fork() creates a child   2) exec(ls) replaces the child with "ls"
sleep 60 &          -->  1) fork() creates a child   2) exec(sleep) runs in the child, parent continues immediately
```

> **Note:** Bash does not expose `fork()` as something you type explicitly
> — every command you run, or every `&` background job, implicitly performs
> this fork+exec sequence behind the scenes.

## 8.10 Zombie processes

A **zombie process** has already finished running, but still has an entry
in the process table because its parent hasn't yet collected its exit
status by calling `wait()`.

- The OS keeps this entry temporarily so the parent *can* check how/why the
  child ended.
- A zombie disappears once the parent calls `wait()`, **or** once the
  parent itself terminates (in which case the zombie is "adopted" by
  `systemd`, PID 1, which cleans it up automatically).
- Zombies use essentially no CPU and very little memory, but too many can
  fill up the process table.

| State | Meaning |
|-------|---------|
| Running | Process is executing |
| Sleeping | Waiting for an event |
| Zombie (Z) | Finished but not yet cleaned up |
| Terminated | Fully removed from the system |

## 8.11 Full worked example (the exact style the Lab Test expects)

```bash
#!/bin/bash

sleep 20 &
PID1=$!

sleep 30 &
PID2=$!

ps -o pid,ppid,stat,cmd -p $PID1 $PID2

kill -STOP $PID1
ps -o pid,stat,cmd -p $PID1

kill -CONT $PID1
ps -o pid,stat,cmd -p $PID1

kill -9 $PID2

wait $PID1

echo "All required process management steps completed"
```

Every line of this maps directly onto the concepts above: background jobs
(`&`), capturing PIDs (`$!`), inspecting state (`ps -o ... -p`), pausing
and resuming (`SIGSTOP`/`SIGCONT`), forced termination (`SIGKILL`/`-9`),
and waiting for completion (`wait`).

## 8.12 Try it yourself

Work through [`scenarios/scenario_1_process_lifecycle.sh`](scenarios/scenario_1_process_lifecycle.sh)
on your own before checking the solution.

Next: [`09-advanced-permissions/README.md`](../09-advanced-permissions/README.md)
