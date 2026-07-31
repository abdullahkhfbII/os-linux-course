# 7. Network Monitoring, Part 2 (Packet Capture & Firewall)

*Corresponds to: Lab 7*

## 7.1 Packet capture with `tcpdump`

`tcpdump` is a **passive** tool that captures and displays actual network
packets passing through an interface, in contrast to `ping` (Module 6),
which is an **active** tool that generates its own test traffic.

### Setup

```bash
sudo apt update
sudo apt upgrade -y
sudo apt-get install tcpdump
```

### Identify your interface first

```bash
ifconfig     # or: ip addr show
```

Find the name of your primary interface (e.g. `eth0`).

### Capturing packets

```bash
sudo tcpdump -i eth0
```

- `-i` specifies which interface to listen on.
- Output starts with setup info: `listening on eth0` (confirms it's
  capturing), `link-type EN10MB (Ethernet)` (the link protocol), `snapshot
  length 262144 bytes` (max bytes captured per packet, ensuring full packet
  data is available).
- At this point, `tcpdump` just waits silently — nothing is shown until
  actual network traffic occurs.

For more detail per packet:

```bash
sudo tcpdump -i eth0 -v
```

### Testing it with `ping`

Open a **second terminal** and run:

```bash
ping -c 4 8.8.8.8
```

Back in the first terminal (where `tcpdump` is running), you'll see lines
like:

```
IP 172.17.40.138 > dns.google: ICMP echo request, id 916, seq 1, length 64
IP dns.google > 172.17.40.138: ICMP echo reply, id 916, seq 1, length 64
```

- `IP` — this is an IPv4 packet.
- `172.17.40.138 > dns.google` — source → destination.
- `ICMP echo request` / `ICMP echo reply` — the actual ping packets going
  out and coming back.
- `id 916` — an identifier grouping this whole ping session's
  request/reply pairs together.
- `seq 1, 2, 3...` — sequence number, matching each request to its reply.
- `length 64` — size of the packet.

When you stop `ping` (Ctrl+C), it reports how many packets were transmitted
and received. When you stop `tcpdump` (Ctrl+C), it reports how many packets
were captured (and, if any, dropped).

### Why packets get dropped

`tcpdump` relies on the Linux kernel to hand it packets; under high traffic
volume, limited CPU/memory, or a small capture buffer, some packets may be
dropped before `tcpdump` can record them.

### `ping` vs. `tcpdump`

| Feature | `ping` | `tcpdump` |
|---------|--------|-----------|
| Type | Active (generates traffic) | Passive (observes existing traffic) |
| Purpose | Test connectivity | Analyze traffic in detail |
| Protocol | ICMP only | All protocols |
| Output | Simple (latency, success/fail) | Detailed packet-level data |

## 7.2 Firewall configuration with `iptables`

A firewall decides which network traffic is allowed in or out.
`iptables` works using a three-level hierarchy:

```
Tables → Chains → Rules
```

### 1) Tables — what kind of processing

| Table | Purpose |
|-------|---------|
| `filter` (default, most important) | Basic packet filtering: allow or deny |
| `nat` | Modifies IP addresses/ports (e.g., routers translating private↔public IPs) |
| `mangle` | Advanced packet modification (TTL, QoS, etc.) |

### 2) Chains — where in the traffic flow a rule applies

| Chain | Handles... |
|-------|------------|
| `INPUT` | Packets destined **for** this machine (e.g. someone connecting to you) |
| `OUTPUT` | Packets **originating from** this machine (e.g. you browsing the internet) |
| `FORWARD` | Packets passing **through** this machine (only relevant if it acts as a router/gateway) |

### 3) Rules — the actual conditions and actions

```bash
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

- `-A INPUT` — **a**ppend this rule to the end of the INPUT chain.
- `-p tcp` — match only TCP packets.
- `--dport 22` — match only packets with destination port 22 (SSH).
- `-j ACCEPT` — the **j**ump target: what to do when the rule matches.

### 4) Targets — possible actions

| Target | Effect |
|--------|--------|
| `ACCEPT` | Allow the packet through |
| `DROP` | Silently discard the packet (sender gets no response at all) |
| `REJECT` | Block the packet, but send an error message back to the sender |

### 5) Default policies

Each chain has a **default policy**, applied when no specific rule matches
a packet:

```bash
sudo iptables -P INPUT DROP
```

This means: "if a packet arrives and doesn't match any specific rule above,
drop it by default." This is a common security baseline — explicitly
`ACCEPT` only the traffic you actually want, and let the default policy
reject everything else.

### Listing current rules

```bash
sudo iptables -L -v -n
```

`-L` lists rules, `-v` gives verbose output (packet/byte counters), `-n`
shows numeric addresses/ports instead of resolving hostnames (faster, and
avoids DNS lookups revealing your activity).

### Common commands

```bash
# Allow incoming SSH (port 22)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP (port 80)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Block all traffic from a specific IP address
sudo iptables -A INPUT -s 203.0.113.5 -j DROP

# Set default policy: drop everything not explicitly allowed
sudo iptables -P INPUT DROP
```

> **⚠ CAUTION:** setting a `DROP` default policy on `INPUT` *before* adding
> an `ACCEPT` rule for your own SSH connection (port 22) will lock you out
> of a remote machine immediately. Always add your allow rules first.

## 7.3 Try it yourself

Work through [`scenarios/scenario_1_firewall_and_monitoring.sh`](scenarios/scenario_1_firewall_and_monitoring.sh)
before checking the provided solution — it combines firewall rules with a
scheduled port-monitoring script, tying together this module with Module 5.

Next: [`08-multiprocessing/README.md`](../08-multiprocessing/README.md)
