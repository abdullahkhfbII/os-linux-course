# 6. Network Monitoring, Part 1

*Corresponds to: Lab 6*

Before this module, make sure you've read Prerequisites §11 (IP addresses,
ports, protocols, sockets, daemons) — everything below assumes you know
what those words mean.

## 6.1 Displaying network interfaces

A **network interface** is a connection point between your machine and a
network (physical Ethernet card, Wi-Fi card, or virtual interface).

### `ip addr show`

```bash
ip addr show
```

- `ip` — the modern command-line tool for network configuration.
- `addr` — short for "address"; shows IP addresses assigned to interfaces.
- `show` — display the information (doesn't change anything).

Common interfaces you'll see:

- `lo` — the **loopback** interface. Used for the machine to talk to
  itself (testing, internal services). Always has address `127.0.0.1`.
- `enp0s3` — a real Ethernet adapter name (common in VirtualBox VMs).
- `ens33` — a real Ethernet adapter name (common in VMware VMs).

### `ifconfig` (older tool)

```bash
ifconfig
```

Shows similar information, in an older format. Notable output fields:
`inet` (IPv4 address), `inet6` (IPv6 address), `RX`/`TX` (received/
transmitted packet counters).

### `ip addr` vs `ifconfig`

| Feature | `ip addr` | `ifconfig` |
|---------|-----------|------------|
| Age | New | Old |
| Pre-installed | Yes, standard everywhere | Often not, deprecated |
| Accuracy | Shows every address the kernel knows about | Can miss secondary IPs |
| Speed | Uses Netlink (modern, fast) | Uses an older, slower kernel interface |
| Capabilities | Can manage routing, tunnels, VLANs, complex rules | Mostly just viewing/basic IP changes |

Use `ip addr` going forward; `ifconfig` is shown here only because you may
encounter it on older systems or documentation.

## 6.2 Configuring interfaces

```bash
sudo ip addr add 192.168.1.50/24 dev enp0s3     # assign an IP address
sudo ip addr del 192.168.1.50/24 dev enp0s3      # remove an IP address (mirror of "add")
```

Recall from the Prerequisites: `/24` is CIDR notation, describing how many
bits of the address represent the network portion.

### Enabling / disabling an interface

```bash
sudo ip link set enp0s3 down    # disable the interface
sudo ip link set enp0s3 up       # re-enable it
```

> **⚠ CAUTION:** if you disable the interface you're currently using for a
> remote session (e.g. SSH), you will instantly disconnect yourself, with
> no way to bring it back up remotely. Only do this on a local console or a
> secondary interface.

## 6.3 Checking connectivity

### `ping`

```bash
ping 8.8.8.8              # keeps sending until you stop it (Ctrl+C)
ping -c 4 8.8.8.8           # send exactly 4 packets, then stop
```

`ping` sends **ICMP Echo Request** packets to a target and waits for **ICMP
Echo Reply** packets back, measuring whether the target is reachable and
how long the round trip took (round-trip time, or RTT).

### `traceroute`

```bash
sudo apt-get update
sudo apt-get install traceroute
traceroute 8.8.8.8
```

`traceroute` reveals every router ("hop") a packet passes through on its
way to the destination, by sending packets with a gradually increasing
Time-To-Live (TTL) value, so each router along the path replies once. A `*`
in the output means that hop didn't respond (timeout, or blocking ICMP for
security).

| Feature | `ping` | `traceroute` |
|---------|--------|--------------|
| Purpose | Tests basic connectivity and speed | Maps the entire path to a destination |
| Question answered | "Are you there? How fast?" | "Which routers am I passing through?" |
| Analogy | A sonar pulse | A trail of breadcrumbs |
| Use case | Quickly check if a site is down | Find exactly where a connection breaks |

## 6.4 Monitoring traffic: `netstat`

```bash
sudo netstat -tulnp
```

- `-t` = TCP connections, `-u` = UDP connections
- `-l` = only **l**istening sockets (services waiting for connections)
- `-n` = show **n**umeric addresses/ports (don't waste time resolving
  hostnames)
- `-p` = show the **p**rocess ID and program name using each socket

Key output columns: **Proto** (TCP/UDP), **Local Address** (IP:port on this
machine), **Foreign Address** (IP:port on the remote machine), **State**
(e.g. `LISTEN`, `ESTABLISHED`), **PID/Program name**.

## 6.5 Restricting SSH access

**SSH** (Secure Shell) is a protocol for securely connecting to and
controlling a remote computer over an untrusted network — everything sent,
including your password, is encrypted before it leaves your machine.

SSH's behavior is controlled by a configuration file:
`/etc/ssh/sshd_config` (`sshd` = the SSH **d**aemon, the background service
constantly waiting for login attempts, as discussed in the Prerequisites).

| Directive | Effect |
|-----------|--------|
| `AllowUsers user1 user2` | ONLY these users may log in via SSH (everyone else is denied) |
| `DenyUsers user1 user2` | These specific users are denied; everyone else is still allowed |
| `AllowGroups group_name` | Only members of this group may log in |
| `DenyGroups group_name` | Members of this group are denied |

### Steps to deny a specific user

```bash
sudo nano /etc/ssh/sshd_config
```

Scroll to the end (or find the existing directive) and add:

```
DenyUsers john
```

To deny multiple users at once, list them space-separated on the same
line: `DenyUsers john mary sam`.

### Editing the config from a script (exam style)

Since the Lab Test expects a **single Bash script**, not manual editing in
nano, use `echo` piped into `sudo tee -a`:

```bash
echo "DenyUsers john" | sudo tee -a /etc/ssh/sshd_config
```

- `echo "..."` produces the line of text you want to add.
- `| sudo tee -a /etc/ssh/sshd_config` — `tee` reads its input and writes it
  **both** to the terminal and to a file at the same time. `-a` means
  append rather than overwrite. We use `tee` here (instead of `>>`)
  specifically because `sudo echo "..." >> file` does **not** actually work
  as expected — the redirection itself happens *before* `sudo` takes
  effect, so it's still your normal (non-root) user trying to write to a
  root-owned file. Piping into `sudo tee -a` correctly runs the *write*
  itself with root privileges.

After editing SSH's config, the SSH service normally needs to be restarted
for changes to take effect: `sudo systemctl restart sshd`.

### Daemon vs. Cron job

The lab draws this comparison because both run "in the background," but
they behave very differently:

| Feature | Daemon (e.g. `sshd`) | Cron job |
|---------|------------------------|----------|
| Availability | Runs constantly | Runs only at scheduled times |
| Trigger | Starts at boot, or manually | Triggered by a time/date schedule |
| Lifespan | Stays alive until shutdown | Ends as soon as its task finishes |
| Logic | "I am always listening/waiting" | "Is it 2:00 PM yet? Okay, work." |

## 6.6 Try it yourself

Work through the two scenarios in [`scenarios/`](scenarios/) — denying a
contractor SSH access while allowing only internal staff, and revoking
temporary student access every Sunday at midnight — before checking the
provided solutions.

Next: [`07-networking-advanced/README.md`](../07-networking-advanced/README.md)
