# Mock Final Exam — Practice Paper

**Total: 100 marks | Time: 1 hour | Format based on the real Lab Test:
one theory question + one practical scenario answered as a single Bash
script.**

> [!IMPORTANT]
> This mock paper is deliberately **harder** than the real Lab Test
> described in the course notes. The real exam's practical scenario fits
> on about two pages and draws from a handful of modules at once; this
> one draws from **almost every module in the course** in a single
> scenario, on purpose, so that the real thing feels shorter and more
> manageable by comparison. If you can complete this paper cleanly within
> the time limit, you are well prepared. Don't be discouraged if your
> first attempt takes much longer — that gap is exactly what practicing
> is for.

## Instructions

- Part A is worth 80 marks. Write **one single Bash script** that
  satisfies every requirement below, in order. Partial credit is given
  per requirement, not per line — an unrelated mistake in step 3 should
  not stop you from attempting step 7.
- Part B is worth 20 marks. Answer in your own words, in complete
  sentences. Command syntax alone, without explanation, earns no marks
  here — this part tests understanding, not recall.
- Use `sudo` wherever a command genuinely requires elevated privileges
  (creating users, editing `/etc/ssh/sshd_config`, managing the
  firewall, etc.) — don't assume it's already been granted for you,
  and don't add it to commands that don't actually need it.
- Where a requirement doesn't specify an exact name/value, choose a
  reasonable one and state your assumption in a comment.

---

## Part A — Practical Scenario (80 marks)

**Scenario:** You are the system administrator for a small university
research lab called **NovaLab**. You must configure users, storage,
scheduled maintenance, monitoring, network access, and process
supervision for the lab, all from a single setup script.

Write **one Bash script** that does the following, in this order:

### A1. Users and groups (11 marks)

1. Create a group called `novalab_staff`.
2. Create two users, `dr_amir` and `dr_lina`, and add both to
   `novalab_staff`.
3. Create a third user, `intern_sam`, **not** in `novalab_staff`.
4. Set `intern_sam`'s account to expire automatically 90 days from
   today, and force a password change every 14 days with a 3-day
   warning beforehand.
5. Using one command, print `dr_amir`'s numeric UID, primary GID, and
   every group they belong to, in a form that proves group membership
   by ID number, not just by name.

### A2. Secure shared storage (12 marks)

1. Create a directory `/novalab/shared_data`.
2. Set its group owner to `novalab_staff`.
3. Configure permissions so that: the owner and group have full
   read/write/execute access, others have no access at all, any new
   file created inside automatically belongs to the `novalab_staff`
   group, and a user can only delete files they personally created
   (even though the group has write access to the whole directory).
4. Verify the final permission string with a command that prints it to
   the screen, and briefly comment what each relevant symbol means.

### A3. A privileged helper script (8 marks)

1. Inside `/novalab/shared_data`, create an empty script called
   `run_diagnostics.sh`.
2. Make it executable.
3. Configure it so that, whenever *any* lab member runs it, it executes
   with the permissions of the file's owner rather than their own.
4. Explain, in a comment above this section, one realistic risk of
   configuring a script this way.

### A4. Scheduled backups and cleanup (12 marks)

1. Write the logic (inside the same script, or generated as a
   sub-script via heredoc — your choice) to compress
   `/novalab/shared_data` into a timestamped `.tar.gz` archive stored in
   `/novalab/backups`, so that repeated backups never overwrite one
   another.
2. Schedule this backup to run automatically every day at 1:00 AM.
3. Separately, schedule a cleanup task that deletes files in
   `/novalab/backups` older than 60 days, once a week, on Sunday at
   3:00 AM.
4. Confirm both scheduled tasks were registered successfully.

### A5. Resource monitoring (12 marks)

1. Check the current memory usage of the system.
2. Extract just the percentage of RAM currently in use (you will need
   to calculate this — it is not printed directly by any single
   command).
3. If usage exceeds 85%, print a clear warning message; otherwise print
   a confirmation that memory usage is within a safe range.
4. Separately, check the disk usage of the `/` filesystem specifically
   (not every mounted filesystem), extract just its used-percentage
   value, and print a warning if it exceeds 80%.

### A6. Network and remote access control (12 marks)

1. Display the lab server's current network interfaces and their
   assigned IP addresses.
2. Configure SSH so that only members of `novalab_staff` may log in
   remotely, and `intern_sam` is explicitly denied, even if they were
   somehow later added to an allowed group.
3. Configure the firewall so that only SSH (port 22) and HTTPS (port
   443) traffic is accepted inbound, and every other unmatched inbound
   packet is dropped by default.
4. Capture live packets on the server's primary network interface for
   a short, fixed duration, and save the captured traffic to a file
   for later inspection instead of printing it to the screen.

### A7. Supervised background processing (13 marks)

NovaLab runs three overnight data-processing jobs that must be
supervised by your script:

1. Start three background processes representing these jobs (you may
   simulate each with an appropriately long `sleep`, since the real
   data-processing programs aren't available in this exam environment).
2. Store all three PIDs in an array, then use a loop (not three
   separate hardcoded commands) to print the PID, parent PID, and
   current state of each, proving they are children of your script.
3. Midway through, pause the **first** job, confirm it is paused, then
   resume it and confirm it is running again.
4. The **second** job must be terminated immediately and forcefully,
   with no opportunity for it to clean up or ignore the request. Prove
   it no longer exists afterward.
5. Your script must not exit until the **first and third** jobs have
   both finished naturally.
6. Print a final message only once every step above has completed
   successfully.

---

## Part B — Theory (20 marks, 4 marks each)

Answer each of the following in 2–4 sentences, in your own words.

**B1.** A colleague suggests giving a shared folder `chmod 777`
permissions "to avoid permission errors, since everyone can access it
anyway." Explain what specific problem the Sticky Bit solves that plain
`777` permissions do not, and why simply avoiding `777` altogether isn't
always a practical option in a shared multi-user directory.

**B2.** Explain the difference between a process's **real UID** and its
**effective UID**, and describe a concrete example (not necessarily
`passwd`) of why this distinction needs to exist at all.

**B3.** A background process finishes, but `ps -ef` still shows it in
the process list with state `Z`. Explain what this process actually is,
why the operating system doesn't just remove it immediately, and what
specifically causes it to finally disappear.

**B4.** Explain the difference between a **daemon** and a **cron job**
in terms of *when* each one runs, and give one task from this exam
scenario that must be implemented as a cron job rather than a daemon,
with a brief justification.

**B5.** In `iptables`, explain the relationship between a **chain**, a
**rule**, and a **default policy**, using the SSH/HTTPS firewall
requirement from Part A6 as your example.

---

*End of paper.*
