# 🔬 Wireshark Basics - 0x05 Network Security

## 📋 Project Overview

This project focuses on **network scanning detection** using Wireshark to identify various types of Nmap scanning techniques. Students learn to create precise display filters that detect specific scanning patterns for defensive security monitoring and intrusion detection.

**Project**: `0x05_wireshark_basics`  
**Environment**: Linux with Wireshark and network analysis tools  
**Repository**: `holbertonschool-cyber_security`

**Tasks are designed to help you understand different network scanning techniques and develop effective detection capabilities using Wireshark display filters.**

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🔍 Create precise Wireshark display filters for scan detection
- 📊 Identify different Nmap scanning techniques (TCP, UDP, ICMP, ARP)
- 🌐 Understand protocol-specific scanning signatures and patterns
- 🔎 Detect stealth scanning attempts through packet analysis
- 🛡️ Develop defensive monitoring capabilities for network security
- 📝 Document scanning patterns and create detection rules

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

## 🔧 Network Analysis Tasks

### 0️⃣ ARP Scanning Detection (`0-arp_scan.pcap`)
**Objective**: Capture and analyze ARP scanning traffic patterns.

**Wireshark Filter**:
```
arp.opcode == 1 && arp.dst.hw_mac == 00:00:00:00:00:00
```

**Analysis Focus**:
- ARP request patterns
- MAC address resolution attempts
- Network discovery techniques
- Broadcast traffic analysis

**Security Context**: ARP scanning is often the first step in network reconnaissance

### 1️⃣ Nmap Ping Scan Analysis (`1-nmap_scan.pcap`)
**Objective**: Detect and analyze ICMP-based host discovery scans.

**Wireshark Filter**:
```
ip.proto == 1
```

**Analysis Focus**:
- ICMP Echo Request/Reply patterns
- Host discovery methodologies
- Response timing analysis
- Network mapping techniques

**Security Context**: ICMP scanning reveals active hosts on the network

### 2️⃣ TCP Port Scanning Detection (`2-tcp_scan.pcap`)
**Objective**: Identify TCP port scanning activities and techniques.

**Wireshark Filter**:
```
tcp.flags.syn == 1 && tcp.flags.ack == 0
```

**Analysis Focus**:
- TCP SYN scanning patterns
- Port enumeration attempts
- Service discovery techniques
- Connection establishment analysis

**Security Context**: TCP scanning identifies open services and potential attack vectors

## 📚 ICMP Protocol Reference

### Complete ICMP Types Documentation
The project includes comprehensive documentation of all ICMP types and codes in `ICMP_Types_Documentation.md`:

- **ICMPv4**: All types (0-43) with corresponding codes
- **ICMPv6**: Error messages (0-127) and informational messages (128-255)
- **Wireshark Filters**: Practical filtering examples for each type
- **Security Applications**: How each ICMP type relates to network security

### Key ICMP Types for Security Analysis:
```
Type 0  - Echo Reply (ping response)
Type 3  - Destination Unreachable (network issues)
Type 8  - Echo Request (ping)
Type 11 - Time Exceeded (traceroute, TTL expiry)
Type 5  - Redirect (routing manipulation)
```

## 🛠️ Wireshark Analysis Techniques

### 🔍 **Essential Display Filters**
```bash
# Protocol-specific filtering
arp                           # ARP traffic only
icmp                          # ICMP traffic only
tcp                           # TCP traffic only
udp                           # UDP traffic only

# IP address filtering
ip.addr == 192.168.1.1       # Traffic to/from specific IP
ip.src == 192.168.1.1        # Traffic from specific source
ip.dst == 192.168.1.1        # Traffic to specific destination

# Port filtering
tcp.port == 80                # HTTP traffic
tcp.port == 443               # HTTPS traffic
tcp.dstport == 22             # SSH connections

# ICMP filtering
icmp.type == 8                # Echo Request (ping)
icmp.type == 0                # Echo Reply (pong)
icmp.type == 3                # Destination Unreachable

# ARP filtering
arp.opcode == 1               # ARP requests
arp.opcode == 2               # ARP replies
```

### 📊 **Security-Focused Analysis**
```bash
# Scanning detection
tcp.flags.syn == 1 && tcp.flags.ack == 0    # SYN scans
icmp.type == 8                               # Ping sweeps
arp.opcode == 1                              # ARP scans

# Suspicious activities
tcp.flags.reset == 1                         # Connection resets
icmp.type == 3                               # Blocked connections
dns.qry.name contains "."                    # DNS enumeration
```

## 🚨 Security Applications

### ⚖️ **Network Monitoring**
- **Traffic Analysis**: Identify unusual communication patterns
- **Intrusion Detection**: Recognize scanning and reconnaissance attempts
- **Incident Response**: Analyze network traces for security events

### 🛡️ **Defensive Security**
- **Baseline Establishment**: Understand normal network behavior
- **Anomaly Detection**: Identify deviations from normal patterns
- **Threat Hunting**: Proactively search for security indicators

### 📊 **Forensic Analysis**
- **Evidence Collection**: Preserve network communication records
- **Timeline Reconstruction**: Map sequence of network events
- **Attack Vector Analysis**: Understand how attacks progressed

## 🔧 Tools and Environment

### **Required Software**
- **Wireshark**: Primary packet analysis tool
- **tshark**: Command-line packet analyzer
- **tcpdump**: Packet capture utility
- **Linux networking tools**: For traffic generation and testing

### **Installation**
```bash
# Ubuntu/Debian installation
sudo apt update
sudo apt install wireshark tshark tcpdump

# Add user to wireshark group for packet capture
sudo usermod -a -G wireshark $USER
```

## 📚 Prerequisites

- **Operating System**: Linux environment with network tools
- **Network Knowledge**: Understanding of TCP/IP, OSI model
- **Security Concepts**: Basic network security principles
- **Tool Familiarity**: Command-line interface proficiency

## 🧪 Practical Exercises

### 🔍 **Traffic Generation for Analysis**
```bash
# Generate ARP traffic
ping -c 1 192.168.1.1

# Generate ICMP traffic  
ping -c 5 google.com

# Generate TCP traffic
curl http://example.com

# Capture traffic
sudo tcpdump -i eth0 -w capture.pcap
```

### 📊 **Analysis Workflow**
1. **Capture Phase**: Record network traffic
2. **Filter Phase**: Apply relevant display filters
3. **Analysis Phase**: Examine protocol details
4. **Documentation Phase**: Record findings and observations

## 🏆 Project Completion

### ✅ **Deliverables**
- [ ] ARP scanning traffic capture (`0-arp_scan.pcap`)
- [ ] ICMP ping scan analysis (`1-nmap_scan.pcap`)
- [ ] TCP port scan detection (`2-tcp_scan.pcap`)
- [ ] ICMP documentation (`ICMP_Types_Documentation.md`)

### 📊 **Success Criteria**
- Demonstrate understanding of packet capture techniques
- Apply appropriate Wireshark filters for security analysis
- Identify scanning and reconnaissance activities
- Document findings with technical accuracy

## 🔗 Additional Resources

- [Wireshark User Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- [Network Protocol Analysis](https://www.sans.org/white-papers/1409/)
- [ICMP RFC 792](https://tools.ietf.org/html/rfc792)
- [ICMPv6 RFC 4443](https://tools.ietf.org/html/rfc4443)
- [Wireshark Display Filters Reference](https://www.wireshark.org/docs/man-pages/wireshark-filter.html)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Network Security and Protocol Analysis* 🛡️

---

**⚠️ Legal Disclaimer**: This project involves network traffic analysis for educational and defensive security purposes. Packet capture and analysis should only be performed on networks you own or have explicit authorization to monitor. Unauthorized network monitoring may violate privacy laws and regulations.