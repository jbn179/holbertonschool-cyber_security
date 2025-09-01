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

## 🔧 Scanning Detection Tasks

### 0️⃣ IP Protocol Scan Detection (`0-ip_scan.txt`)
**Objective**: Detect `nmap -sO` IP protocol scanning.

**Wireshark Filter**:
```
icmp
```

**Scan Type**: Protocol discovery scan  
**Detection Method**: ICMP traffic generated during protocol testing  
**Security Context**: Identifies protocol enumeration attempts

---

### 1️⃣ TCP SYN Scan Detection (`1-tcp_syn.txt`)
**Objective**: Detect `nmap -sS` stealth scanning.

**Wireshark Filter**:
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size <= 1024
```

**Scan Type**: Half-open stealth scan  
**Detection Method**: SYN packets with characteristic window size ≤ 1024  
**Security Context**: Most common stealth scanning technique

---

### 2️⃣ TCP Connect Scan Detection (`2-tcp_connect_scan.txt`)
**Objective**: Detect `nmap -sT` full connection scanning.

**Wireshark Filter**:
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size > 1024
```

**Scan Type**: Full TCP connection scan  
**Detection Method**: SYN packets with normal OS window size > 1024  
**Security Context**: Slower but more reliable scanning method

---

### 3️⃣ TCP FIN Scan Detection (`3-tcp_fin.txt`)
**Objective**: Detect `nmap -sF` FIN scanning.

**Wireshark Filter**:
```
tcp.flags == 0x01
```

**Scan Type**: Stealth scan using FIN packets  
**Detection Method**: TCP packets with only FIN flag set  
**Security Context**: Firewall evasion technique

---

### 4️⃣ TCP Ping Sweep Detection (`4-tcp_ping_sweep.txt`)
**Objective**: Detect `nmap -sn -PS/-PA` TCP ping sweeps.

**Wireshark Filter**:
```
tcp.syn== 1 and tcp.ack== 1
```

**Scan Type**: Host discovery using TCP  
**Detection Method**: SYN+ACK responses from live hosts  
**Security Context**: Network reconnaissance and host enumeration

---

### 5️⃣ UDP Port Scan Detection (`5-udp_port_scan.txt`)
**Objective**: Detect `nmap -sU` UDP port scanning.

**Wireshark Filter**:
```
icmp.type == 3 and icmp.code == 3
```

**Scan Type**: UDP port enumeration  
**Detection Method**: ICMP "Port Unreachable" responses  
**Security Context**: UDP service discovery attempts

---

### 6️⃣ UDP Ping Sweep Detection (`6-udp_ping_sweep.txt`)
**Objective**: Detect `nmap -sn -PU` UDP ping sweeps.

**Wireshark Filter**:
```
udp and udp.dstport == 7
```

**Scan Type**: Host discovery using UDP  
**Detection Method**: UDP packets to port 7 (Echo service)  
**Security Context**: Alternative host discovery method

---

### 7️⃣ ICMP Ping Sweep Detection (`7-icmp_ping_sweep.txt`)
**Objective**: Detect `nmap -sn -PE` ICMP ping sweeps.

**Wireshark Filter**:
```
icmp.type == 8 or icmp.type == 0
```

**Scan Type**: Classic ping sweep  
**Detection Method**: ICMP Echo Request/Reply pairs  
**Security Context**: Traditional network discovery technique

---

### 8️⃣ ARP Scanning Detection (`8-arp_scanning.txt`)
**Objective**: Detect `arp-scan` layer 2 discovery.

**Wireshark Filter**:
```
arp.dst.hw_mac == 00:00:00:00:00:00
```

**Scan Type**: Layer 2 host discovery  
**Detection Method**: ARP requests with null destination MAC  
**Security Context**: Local network reconnaissance

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

## 🏆 Project Results

### ✅ **Task Completion**
| Task | Filter File | Scan Detection | Status |
|------|-------------|----------------|--------|
| **0** | `0-ip_scan.txt` | IP Protocol Scan | ✅ |
| **1** | `1-tcp_syn.txt` | TCP SYN Scan | ✅ |
| **2** | `2-tcp_connect_scan.txt` | TCP Connect Scan | ✅ |
| **3** | `3-tcp_fin.txt` | TCP FIN Scan | ✅ |
| **4** | `4-tcp_ping_sweep.txt` | TCP Ping Sweep | ✅ |
| **5** | `5-udp_port_scan.txt` | UDP Port Scan | ✅ |
| **6** | `6-udp_ping_sweep.txt` | UDP Ping Sweep | ✅ |
| **7** | `7-icmp_ping_sweep.txt` | ICMP Ping Sweep | ✅ |
| **8** | `8-arp_scanning.txt` | ARP Scanning | ✅ |

### 📚 **Knowledge Gained**
- Network scanning technique identification
- Wireshark filter syntax mastery
- Protocol-level traffic analysis
- Defensive monitoring capabilities

## 📚 Prerequisites

- **Operating System**: Linux environment with network analysis tools
- **Network Knowledge**: TCP/IP protocol understanding, OSI model concepts
- **Security Concepts**: Network scanning techniques and defensive principles
- **Tool Familiarity**: Command-line interface and Wireshark basics

## 🔗 Additional Resources

- [Wireshark Display Filters Reference](https://www.wireshark.org/docs/man-pages/wireshark-filter.html)
- [Nmap Network Scanning Guide](https://nmap.org/book/)
- [ICMP RFC 792](https://tools.ietf.org/html/rfc792) - ICMPv4 specification
- [ICMPv6 RFC 4443](https://tools.ietf.org/html/rfc4443) - ICMPv6 specification
- [TCP/IP Protocol Suite](https://www.rfc-editor.org/rfc/rfc793.html) - TCP specification

## 👥 Author

**Holberton School Cybersecurity Program**  
*Network Security and Scanning Detection* 🛡️

---

**⚠️ Legal Disclaimer**: This project involves network scanning detection for educational and defensive security purposes. All scanning activities should only be performed on networks you own or have explicit authorization to test. Unauthorized network scanning may violate laws and regulations. This knowledge should be used exclusively for defensive security monitoring and authorized penetration testing.