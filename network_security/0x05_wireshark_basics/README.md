# 🔬 Wireshark Basics - 0x05 Network Security

## 📋 Project Overview

This project focuses on **network scanning detection** using Wireshark to identify and analyze various Nmap scanning techniques through packet-level analysis. Students learn to create precise display filters that detect specific scanning patterns, understand protocol behaviors, and develop advanced defensive monitoring capabilities for network security and intrusion detection.

**Project**: `0x05_wireshark_basics`  
**Environment**: Linux with Wireshark, Nmap, and network analysis tools  
**Repository**: `holbertonschool-cyber_security`

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🔍 Master Wireshark display filter syntax and advanced packet filtering techniques
- 📊 Identify and differentiate between various Nmap scanning methodologies (TCP, UDP, ICMP, ARP)
- 🌐 Analyze protocol-specific scanning signatures and behavioral patterns at the packet level
- 🔎 Detect sophisticated stealth scanning techniques through traffic analysis
- 🛡️ Develop comprehensive defensive monitoring capabilities for network security operations
- 📝 Create detection rules and implement security monitoring workflows
- 🧠 Understand the offensive perspective to strengthen defensive capabilities
- 📋 Perform forensic network analysis for incident response scenarios

## 📁 Project Structure

| Task | File | Description | Scan Type | Tool |
|------|------|-------------|-----------|------|
| **0** | `0-ip_scan.txt` | IP protocol scanning detection | Protocol scan | `nmap -sO` |
| **1** | `1-tcp_syn.txt` | TCP SYN scanning detection | Stealth scan | `nmap -sS` |
| **2** | `2-tcp_connect_scan.txt` | TCP Connect scanning detection | Full connect | `nmap -sT` |
| **3** | `3-tcp_fin.txt` | TCP FIN scanning detection | Stealth scan | `nmap -sF` |
| **4** | `4-tcp_ping_sweep.txt` | TCP ping sweep detection | Host discovery | `nmap -sn -PS/-PA` |
| **5** | `5-udp_port_scan.txt` | UDP port scanning detection | UDP scan | `nmap -sU` |
| **6** | `6-udp_ping_sweep.txt` | UDP ping sweep detection | Host discovery | `nmap -sn -PU` |
| **7** | `7-icmp_ping_sweep.txt` | ICMP ping sweep detection | Host discovery | `nmap -sn -PE` |
| **8** | `8-arp_scanning.txt` | ARP scanning detection | Layer 2 discovery | `arp-scan` |
| **Docs** | `ICMP_Types_Documentation.md` | Complete ICMP reference | Protocol docs | Reference |

## 🔧 Network Scanning Detection Tasks

### 0️⃣ IP Protocol Scan Detection (`0-ip_scan.txt`)
```bash
# Nmap Command: sudo nmap -sO <target>
```

**Wireshark Filter**:
```
icmp
```

**Technical Concept**:
IP protocol scanning (`-sO`) tests which IP protocols are supported by the target (TCP=6, UDP=17, ICMP=1, etc.). Nmap sends IP headers with different protocol numbers to identify active protocols.

**Detection Method**:
- ICMP filter to capture "Protocol Unreachable" responses (Type 3, Code 2)
- Unsupported protocols generate ICMP error messages
- Supported protocols: no ICMP response or direct protocol response

**Security Interest**:
- **Reconnaissance**: Enumeration of available network services
- **System fingerprinting**: Identification of the OS TCP/IP stack
- **Attack preparation**: Protocol selection for targeted attacks

**Defensive Usage Example**:
```bash
# Continuous monitoring of protocol scans
tshark -i eth0 -f "icmp and icmp[0] == 3 and icmp[1] == 2"
```

---

### 1️⃣ TCP SYN Scan Detection (`1-tcp_syn.txt`)
```bash
# Nmap Command: sudo nmap -sS <target>
```

**Wireshark Filter**:
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size <= 1024
```

**Technical Concept**:
SYN scanning (half-open) is the most popular stealth scanning technique. Nmap sends SYN packets with a characteristic window size (1024 bytes) that differs from normal operating system connections.

**Detection Method**:
- **tcp.syn == 1**: Packets with SYN flag enabled (connection initiation)
- **tcp.ack == 0**: No ACK flag (not a response)
- **tcp.window_size <= 1024**: Nmap-specific signature (normal OS uses >1024)

**Security Interest**:
- **Stealth scanning**: Doesn't complete TCP connections (no application logs)
- **Speed**: Faster than full connect scanning
- **Port detection**: Identification of open services without establishing connections

**Advanced Detection Signatures**:
```bash
# Detection by SYN volume (possible scan)
tcp.flags.syn == 1 and tcp.flags.ack == 0
```

**Defensive Usage Example**:
```bash
# IDS/IPS rule to detect SYN scans
alert tcp any any -> HOME_NET any (msg:"Possible SYN Scan"; flags:S,!A; threshold: type limit, count 100, seconds 60;)
```

---

### 2️⃣ TCP Connect Scan Detection (`2-tcp_connect_scan.txt`)
```bash
# Nmap Command: sudo nmap -sT <target>
```

**Wireshark Filter**:
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size > 1024
```

**Technical Concept**:
Connect scanning uses the complete operating system connect() system call to establish full TCP connections. It uses the native OS window size (typically >1024 bytes).

**Detection Method**:
- **tcp.window_size > 1024**: Normal OS window size
- Differentiation from SYN scan by window size
- Complete TCP connections (SYN → SYN/ACK → ACK)

**Security Interest**:
- **Less stealthy**: Leaves traces in application logs
- **More reliable**: Uses native TCP stack, fewer false positives
- **Privilege bypass**: Doesn't require root privileges

**Behavioral Differences**:
```
Nmap SYN (-sS)    : window_size = 1024 (fixed value)
Nmap Connect (-sT): window_size = OS value (32768, 64240, 65535)
```

**Defensive Usage Example**:
```bash
# Detection of rapid multiple connections (connect scan)
tcp.flags.syn == 1 and tcp.window_size > 1024 and tcp.analysis.initial_rtt < 0.1
```

---

### 3️⃣ TCP FIN Scan Detection (`3-tcp_fin.txt`)
```bash
# Nmap Command: sudo nmap -sF <target>
```

**Wireshark Filter**:
```
tcp.flags == 0x01
```

**Technical Concept**:
FIN scanning exploits a TCP RFC 793 subtlety: a FIN packet to a closed port should generate an RST, while an open port should ignore the packet. This technique bypasses certain stateless firewalls.

**Detection Method**:
- **tcp.flags == 0x01**: Only the FIN flag is enabled (0x01 in hexadecimal)
- Abnormal TCP packets (FIN without prior connection)
- Absence of established TCP session

**Security Interest**:
- **Firewall bypass**: Stateless firewalls often block SYN but not FIN
- **Stealth**: Less detected by basic IDS systems
- **Port enumeration**: Identification of open ports without SYN

**Expected Responses**:
```
Closed port : RST/ACK (detectable)
Open port   : No response (silence = open)
Firewall    : Packet dropped (undetectable)
```

**Defensive Usage Example**:
```bash
# Detection of isolated FIN packets (without session context)
tcp.flags.fin == 1 and tcp.flags.syn == 0 and tcp.flags.ack == 0
```

---

### 4️⃣ TCP Ping Sweep Detection (`4-tcp_ping_sweep.txt`)
```bash
# Nmap Commands: sudo nmap -sn -PS <subnet> / sudo nmap -sn -PA <subnet>
```

**Wireshark Filter**:
```
tcp.syn== 1 and tcp.ack== 1
```

**Technical Concept**:
TCP ping sweep uses TCP SYN (-PS) or ACK (-PA) packets to discover live hosts. The filter detects SYN+ACK responses that indicate active hosts with open ports.

**Detection Method**:
- **tcp.syn == 1 and tcp.ack == 1**: SYN+ACK responses from target hosts
- Host discovery pattern on a subnet
- Multiple SYN+ACK from different IPs within short timeframe

**Security Interest**:
- **Host discovery**: Network mapping without port scanning
- **ICMP bypass**: Alternative when ICMP is blocked
- **Attack preparation**: Reconnaissance phase preceding exploitation

**TCP Ping Types**:
```bash
-PS (SYN Ping)  : Sends SYN, expects SYN+ACK (open port) or RST (closed port)
-PA (ACK Ping)  : Sends ACK, expects RST (live host - no session)
```

**Defensive Usage Example**:
```bash
# Sweep detection through statistical analysis
tcp.flags.syn == 1 and tcp.flags.ack == 1 | statistics over time intervals
```

---

### 5️⃣ UDP Port Scan Detection (`5-udp_port_scan.txt`)
```bash
# Nmap Command: sudo nmap -sU <target>
```

**Wireshark Filter**:
```
icmp.type == 3 and icmp.code == 3
```

**Technical Concept**:
UDP scanning exploits the ICMP error notification mechanism. When a UDP packet is sent to a closed port, the target system responds with an ICMP "Destination Unreachable - Port Unreachable" message (Type 3, Code 3).

**Detection Method**:
- **icmp.type == 3**: ICMP Destination Unreachable
- **icmp.code == 3**: Specific "Port Unreachable" code
- ICMP messages in response to UDP probes

**Security Interest**:
- **UDP enumeration**: Discovery of UDP services (DNS, DHCP, SNMP)
- **Critical services**: Identification of infrastructure services
- **UDP attacks**: Preparation for amplification attacks

**UDP Port States**:
```
Closed port  : ICMP Port Unreachable (detectable)
Open port    : Service response OR silence (difficult to distinguish)
Filtered port: No ICMP response (firewall/filtering)
```

**Defensive Usage Example**:
```bash
# UDP scan detection through ICMP analysis
icmp.type == 3 and icmp.code == 3 | grouping by source IP
```

---

### 6️⃣ UDP Ping Sweep Detection (`6-udp_ping_sweep.txt`)
```bash
# Nmap Command: sudo nmap -sn -PU <subnet>
```

**Wireshark Filter**:
```
udp and udp.dstport == 7
```

**Technical Concept**:
UDP ping sweep sends UDP packets to specific ports (often port 7 - Echo) to discover active hosts. This technique is useful when ICMP and TCP are blocked by firewalls.

**Detection Method**:
- **udp.dstport == 7**: UDP traffic to Echo port (echo service)
- UDP host discovery packets
- Scanning pattern across a subnet

**Security Interest**:
- **Filtering bypass**: Alternative when ICMP/TCP are blocked
- **Stealth discovery**: Less suspicious than classic ICMP pings
- **UDP services**: May reveal active UDP services

**Common UDP Ports for Ping**:
```
Port 7   : Echo (echo service)
Port 9   : Discard (discard service)
Port 13  : Daytime (date/time service)
Port 37  : Time (time service)
```

**Defensive Usage Example**:
```bash
# Monitoring UDP ping sweep attempts
udp.dstport in {7,9,13,37} | analysis by IP ranges
```

---

### 7️⃣ ICMP Ping Sweep Detection (`7-icmp_ping_sweep.txt`)
```bash
# Nmap Command: sudo nmap -sn -PE <subnet>
```

**Wireshark Filter**:
```
icmp.type == 8 or icmp.type == 0
```

**Technical Concept**:
ICMP ping sweep is the classic method for host discovery. It sends Echo Requests (Type 8) to a range of IPs and analyzes Echo Replies (Type 0) to identify active hosts.

**Detection Method**:
- **icmp.type == 8**: ICMP Echo Request (outbound ping)
- **icmp.type == 0**: ICMP Echo Reply (responses from active hosts)
- Sequence of pings across a subnet

**Security Interest**:
- **Network discovery**: Fast and efficient mapping
- **Network baseline**: Establishing network reference state
- **Initial reconnaissance**: First step before port scanning

**ICMP Ping Types**:
```bash
-PE : Echo Request/Reply (Type 8/0) - Classic ping
-PP : Timestamp Request/Reply (Type 13/14) - Alternative
-PM : Address Mask Request/Reply (Type 17/18) - Less common
```

**Defensive Usage Example**:
```bash
# Ping sweep detection through temporal analysis
icmp.type == 8 | grouping by source IP, sequential analysis
```

---

### 8️⃣ ARP Scanning Detection (`8-arp_scanning.txt`)
```bash
# Nmap/arp-scan Command: sudo arp-scan -l / sudo nmap -sn -PR <subnet>
```

**Wireshark Filter**:
```
arp.dst.hw_mac == 00:00:00:00:00:00
```

**Technical Concept**:
ARP scanning operates at layer 2 (data link) to discover hosts on the local network segment. It sends ARP requests with null destination MAC address (broadcast) to discover all machines on the local subnet.

**Detection Method**:
- **arp.dst.hw_mac == 00:00:00:00:00:00**: Null destination MAC address
- ARP requests in discovery mode (broadcast)
- Abnormal volume of ARP traffic

**Security Interest**:
- **Layer 2 discovery**: Host detection even with IP firewall
- **Local network**: Complete enumeration of LAN segment
- **Absolute bypass**: Impossible to block at IP level

**ARP Scan Operation**:
```
ARP Request : "Who has IP X.X.X.X?" (MAC destination = 00:00:00:00:00:00)
ARP Reply   : "IP X.X.X.X is at MAC yy:yy:yy:yy:yy:yy"
Result      : IP → MAC mapping of all active hosts
```

**Defensive Usage Example**:
```bash
# Monitoring intensive ARP scans
arp.dst.hw_mac == 00:00:00:00:00:00 | frequency analysis by source IP
```

## 📚 Filter Reference Summary

### Complete Detection Filters

| Task | Nmap Command | Wireshark Filter | Target Protocol |
|------|-------------|------------------|----------------|
| **0** | `nmap -sO <target>` | `icmp` | IP Protocol |
| **1** | `nmap -sS <target>` | `tcp.syn == 1 and tcp.ack == 0 and tcp.window_size <= 1024` | TCP |
| **2** | `nmap -sT <target>` | `tcp.syn == 1 and tcp.ack == 0 and tcp.window_size > 1024` | TCP |
| **3** | `nmap -sF <target>` | `tcp.flags == 0x01` | TCP |
| **4** | `nmap -sn -PS/-PA <subnet>` | `tcp.syn== 1 and tcp.ack== 1` | TCP |
| **5** | `nmap -sU <target>` | `icmp.type == 3 and icmp.code == 3` | UDP/ICMP |
| **6** | `nmap -sn -PU <subnet>` | `udp and udp.dstport == 7` | UDP |
| **7** | `nmap -sn -PE <subnet>` | `icmp.type == 8 or icmp.type == 0` | ICMP |
| **8** | `arp-scan -l` | `arp.dst.hw_mac == 00:00:00:00:00:00` | ARP |

### Key Protocol Values
- **ICMP Types**: 0=Echo Reply, 3=Dest Unreachable, 8=Echo Request
- **ICMP Codes**: 3=Port Unreachable (for Type 3)
- **TCP Flags**: SYN=0x02, ACK=0x10, FIN=0x01, SYN+ACK=0x12
- **UDP Port**: 7=Echo service (commonly used for ping sweeps)

## 🛠️ Practical Testing Guide

### 🔧 **Testing Environment Setup**
```bash
# Install required tools
sudo apt update
sudo apt install wireshark nmap arp-scan

# Start Wireshark with privileges
sudo wireshark

# Grant capture permissions (alternative)
sudo usermod -a -G wireshark $USER
```

### 📊 **Testing Methodology**
1. **Open Wireshark** and select network interface
2. **Apply filter** from the task file
3. **Start capture** in Wireshark
4. **Execute scan command** in separate terminal
5. **Observe captured packets** matching the filter
6. **Analyze packet details** for scanning signatures

### 🎯 **Common Test Commands**
```bash
# Protocol scan
sudo nmap -sO 8.8.8.8

# TCP scans
sudo nmap -sS 8.8.8.8          # SYN scan
sudo nmap -sT 8.8.8.8          # Connect scan
sudo nmap -sF 8.8.8.8          # FIN scan

# Host discovery
sudo nmap -sn -PE 192.168.1.0/24   # ICMP ping sweep
sudo nmap -sn -PS 192.168.1.0/24   # TCP SYN ping
sudo nmap -sn -PA 192.168.1.0/24   # TCP ACK ping
sudo nmap -sn -PU 192.168.1.0/24   # UDP ping

# UDP scanning
sudo nmap -sU 8.8.8.8

# ARP scanning
sudo arp-scan -l
sudo arp-scan 192.168.1.0/24
```

## 🚨 Scanning Signatures & Detection

### 🔍 **TCP Flag Analysis**
```bash
# TCP Flag combinations for different scans
SYN Scan (nmap -sS)    : tcp.flags == 0x02 (SYN only)
Connect Scan (nmap -sT): tcp.flags == 0x02 (SYN, normal window)
FIN Scan (nmap -sF)    : tcp.flags == 0x01 (FIN only)
NULL Scan (nmap -sN)   : tcp.flags == 0x00 (no flags)
XMAS Scan (nmap -sX)   : tcp.flags == 0x29 (FIN+PSH+URG)
```

### 📊 **Window Size Signatures**
```bash
# Distinguish nmap from normal connections
Nmap SYN Scan     : window_size = 1024
Normal OS Connect : window_size = 64240, 65535, 32768+
```

### 🎯 **ICMP Pattern Recognition**
```bash
# ICMP scanning patterns
Ping Sweep        : icmp.type == 8 (requests) + type == 0 (replies)
UDP Scan Response : icmp.type == 3 && icmp.code == 3 (port unreachable)
Protocol Scan     : Various ICMP types generated during testing
```

## 🛡️ Defensive Applications

### ⚖️ **Intrusion Detection**
- **Real-time Monitoring**: Deploy filters in network monitoring systems
- **Alert Generation**: Trigger alerts on scanning pattern detection
- **Traffic Analysis**: Identify reconnaissance attempts in packet captures

### 🔧 **Security Operations**
- **Incident Response**: Analyze captures during security incidents
- **Threat Hunting**: Proactively search for scanning activities
- **Network Forensics**: Reconstruct attack timelines from packet data

### 📊 **Monitoring Implementation**
```bash
# Example: Continuous monitoring with tshark
tshark -i eth0 -f "tcp[tcpflags] & tcp-syn != 0 and tcp[4:2] <= 1024"
```

## 🚨 Signature Analysis & Advanced Detection

### 🔍 **TCP Flag Analysis for Scan Identification**
```bash
# Common TCP signatures in Nmap scans
SYN Scan (nmap -sS)     : tcp.flags == 0x02 (SYN only)
Connect Scan (nmap -sT) : tcp.flags == 0x02 (SYN with OS window size)
FIN Scan (nmap -sF)     : tcp.flags == 0x01 (FIN only)
NULL Scan (nmap -sN)    : tcp.flags == 0x00 (no flags)
XMAS Scan (nmap -sX)    : tcp.flags == 0x29 (FIN+PSH+URG)
ACK Scan (nmap -sA)     : tcp.flags == 0x10 (ACK only)
```

### 📊 **Window Size Signatures for Nmap Fingerprinting**
```bash
# TCP window size differentiation
Nmap SYN Scan (-sS)     : window_size = 1024 (signature)
Windows 10 native      : window_size = 64240
Linux native           : window_size = 32768, 65535
macOS native           : window_size = 65535
```

### 🔎 **ICMP Pattern Recognition for UDP Scanning**
```bash
# ICMP types revealing scans
Type 3, Code 3 : Port Unreachable (UDP scan)
Type 3, Code 2 : Protocol Unreachable (protocol scan)
Type 3, Code 1 : Host Unreachable (filtered network)
Type 3, Code 0 : Network Unreachable (missing route)
```

### 📈 **Temporal Correlation Techniques**
```bash
# Detection based on temporal patterns
Burst SYN       : >10 SYN/second to different ports
Sequential Scan : Consecutive ports scanned rapidly
Random Scan     : Random ports but high volume
Slow Scan       : Intentional delays between packets (< 1 packet/second)
```

## 📚 Prerequisites & Environment Setup

### 🖥️ **System Requirements**
- **Operating System**: Linux environment (Ubuntu, Kali Linux recommended)
- **Privileges**: Administrator access for packet capture
- **Network Interface**: Active network interface for monitoring

### 🧠 **Knowledge Prerequisites**
- **TCP/IP Stack**: Deep understanding of network protocols (OSI layers 2-4)
- **Network Security**: Basic concepts of network attacks and defenses
- **Command Line**: Linux terminal and bash scripting proficiency
- **Packet Analysis**: Familiarity with network traffic analysis

### 🛠️ **Required Tools Installation**
```bash
# Installation on Ubuntu/Debian
sudo apt update
sudo apt install wireshark nmap arp-scan tshark

# Wireshark permissions for non-root user
sudo usermod -a -G wireshark $USER
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# Installation on Kali Linux (usually pre-installed)
sudo apt update && sudo apt upgrade
```

### 🔧 **Tool Configuration**
```bash
# Wireshark configuration for privileged capture
echo 'wireshark-common wireshark-common/install-setuid boolean true' | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure wireshark-common

# Configuration test
wireshark --version
nmap --version
arp-scan --version
```

## 🔗 Advanced Resources & References

### 📖 **Official Documentation**
- [Wireshark Display Filters Reference](https://www.wireshark.org/docs/man-pages/wireshark-filter.html) - Complete filter syntax
- [Nmap Network Scanning Guide](https://nmap.org/book/) - Complete network scanning guide
- [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) - Complete user documentation

### 📋 **Protocol Specifications (RFC)**
- [RFC 793 - TCP](https://www.rfc-editor.org/rfc/rfc793.html) - Transmission Control Protocol
- [RFC 792 - ICMP](https://tools.ietf.org/html/rfc792) - Internet Control Message Protocol
- [RFC 768 - UDP](https://www.rfc-editor.org/rfc/rfc768.html) - User Datagram Protocol
- [RFC 826 - ARP](https://www.rfc-editor.org/rfc/rfc826.html) - Address Resolution Protocol

### 🛡️ **Security & Defense Resources**
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework) - Security standards
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/) - Security testing methodology
- [SANS Internet Storm Center](https://isc.sans.edu/) - Threat intelligence
- [Snort IDS Rules](https://www.snort.org/rules) - Intrusion detection rules

### 🎓 **Advanced Learning Resources**
- [Wireshark Network Analysis](https://www.wiresharkbook.com/) - Specialized network analysis book
- [Network Security Monitoring](https://nostarch.com/nsm) - Network monitoring book
- [Practical Packet Analysis](https://nostarch.com/packet2.htm) - Practical packet analysis

## 👥 Author

**Holberton School Cybersecurity Program**  
*Network Security and Scanning Detection* 🛡️

---

**⚠️ Legal Disclaimer**: This project involves network scanning detection for educational and defensive security purposes. All scanning activities should only be performed on networks you own or have explicit authorization to test. Unauthorized network scanning may violate laws and regulations. This knowledge should be used exclusively for defensive security monitoring and authorized penetration testing.