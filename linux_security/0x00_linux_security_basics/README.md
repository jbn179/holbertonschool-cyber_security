# 🛡️ Linux Security Basics - 0x00 Linux Security Fundamentals

## 📋 Project Overview

This project focuses on fundamental Linux security operations and monitoring techniques. Students will learn essential security tools and commands for system administration, network monitoring, firewall configuration, and security auditing on Linux systems.

**Project**: `0x00_linux_security_basics`  
**Environment**: Linux/Kali Linux  
**Repository**: `holbertonschool-cyber_security`

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🔍 Monitor user login sessions and activity
- 🌐 Analyze active network connections and processes
- 🔥 Configure firewall rules with UFW and iptables
- 🚪 Audit network services and open ports
- 📊 Perform system security audits
- 📡 Capture and analyze network traffic
- 🎯 Conduct basic network reconnaissance

## 📁 Project Structure

| Task | Script | Description | Key Tool |
|------|--------|-------------|----------|
| **0** | `0-login.sh` | Monitor user login sessions | `last` |
| **1** | `1-active-connections.sh` | Display active TCP connections | `ss` |
| **2** | `2-incoming_connections.sh` | Configure UFW firewall policy | `ufw` |
| **3** | `3-firewall_rules.sh` | List iptables security rules | `iptables` |
| **4** | `4-network_services.sh` | Audit network services and ports | `netstat` |
| **5** | `5-audit_system.sh` | Perform comprehensive system audit | `lynis` |
| **6** | `6-capture_analyze.sh` | Capture network packets | `tcpdump` |
| **7** | `7-scan.sh` | Network host discovery and scanning | `nmap` |

## 🔧 Scripts Documentation

### 0️⃣ Login Session Monitor (`0-login.sh`)
```bash
#!/bin/bash
sudo last -F -5  # List last 5 logins session for users with their corresponding dates and times.
```

**Code Explanation**:
- `sudo last` : Shows user login history from system logs
- `-F` : Full format with complete timestamps
- `-5` : Display only the last 5 login sessions

**Security Context**: Track user access patterns, detect unauthorized logins, forensic analysis

### 1️⃣ Active Connections Monitor (`1-active-connections.sh`)
```bash
#!/bin/bash
sudo ss -antp  # List all active connections with process information
```

**Code Explanation**:
- `ss` : Modern replacement for netstat (socket statistics)
- `-a` : All connections (listening + established)
- `-n` : Numeric format (no DNS resolution)
- `-t` : TCP connections only
- `-p` : Show process using socket

**Security Context**: Detect suspicious connections, identify running services, network forensics

### 2️⃣ UFW Firewall Configuration (`2-incoming_connections.sh`)
```bash
#!/bin/bash
sudo ufw --force reset > /dev/null 2>&1 && sudo ufw default deny incoming > /dev/null 2>&1 && sudo ufw default allow outgoing > /dev/null 2>&1 && sudo ufw allow 80/tcp && sudo ufw --force enable > /dev/null 2>&1
```

**Code Explanation**:
- `ufw --force reset` : Reset firewall to default state
- `ufw default deny incoming` : Block all incoming traffic by default
- `ufw default allow outgoing` : Allow all outgoing traffic
- `ufw allow 80/tcp` : Specifically allow HTTP traffic
- `ufw --force enable` : Activate firewall without prompts

**Security Context**: Implement defense-in-depth, minimize attack surface, secure server configuration

### 3️⃣ Firewall Rules Audit (`3-firewall_rules.sh`)
```bash
#!/bin/bash
sudo iptables -t security -L -n -v  # List all rules in security table with verbose output
```

**Code Explanation**:
- `iptables` : Linux kernel firewall administration tool
- `-t security` : Target the security table (SELinux/AppArmor controls)
- `-L` : List all rules in the table
- `-n` : Numeric output (no hostname resolution)
- `-v` : Verbose mode with packet/byte counters

**Security Context**: Security policy auditing, MAC (Mandatory Access Control) verification

### 4️⃣ Network Services Audit (`4-network_services.sh`)
```bash
#!/bin/bash
sudo netstat -tunlp  # List services, their current state, and their corresponding ports
```

**Code Explanation**:
- `netstat` : Network statistics and connection information
- `-t` : TCP connections
- `-u` : UDP connections
- `-n` : Numeric addresses (no DNS resolution)
- `-l` : Listening ports only
- `-p` : Process ID and name

**Security Context**: Service enumeration, identify unnecessary services, attack surface assessment

### 5️⃣ System Security Audit (`5-audit_system.sh`)
```bash
#!/bin/bash
sudo lynis audit system  # List all audit rules
```

**Code Explanation**:
- `lynis` : Comprehensive security auditing tool
- `audit system` : Perform full system security assessment
- Checks: hardening, compliance, vulnerabilities, configuration

**Security Context**: Security baseline assessment, compliance checking, vulnerability identification

### 6️⃣ Network Packet Capture (`6-capture_analyze.sh`)
```bash
#!/bin/bash
sudo tcpdump -c 5 -i any  # Capture 5 packets and display verbose output
```

**Code Explanation**:
- `tcpdump` : Command-line packet analyzer
- `-c 5` : Capture exactly 5 packets then stop
- `-i any` : Listen on all available interfaces

**Security Context**: Network forensics, traffic analysis, intrusion detection

### 7️⃣ Network Scanner (`7-scan.sh`)
```bash
#!/bin/bash
sudo nmap "$1"
```

**Code Explanation**:
- `nmap` : Network exploration and security scanning tool
- `"$1"` : Target IP address or hostname (first argument)
- Default scan: TCP SYN scan of top 1000 ports

**Security Context**: Network reconnaissance, service discovery, vulnerability assessment

## 🚨 Security Considerations

### 🔐 **Privileged Operations**
- All scripts require `sudo` privileges for system-level access
- Monitor execution logs for security compliance
- Use principle of least privilege in production

### 🌐 **Network Security**
- UFW provides stateful firewall protection
- Default deny policy minimizes attack surface
- Regular audit of firewall rules essential

### 📊 **Monitoring Best Practices**
- Regular login session monitoring for anomaly detection
- Continuous network connection monitoring
- Automated security auditing with tools like Lynis

### ⚠️ **Ethical Usage**
- Network scanning tools (nmap) should only be used on authorized systems
- Packet capture requires proper authorization and legal compliance
- Respect privacy and legal boundaries in security testing

## 🛠️ Installation & Usage

1. **Ensure required tools are installed**:
   ```bash
   # Install security tools (on Debian/Ubuntu)
   sudo apt update
   sudo apt install ufw iptables-persistent netstat-nat lynis tcpdump nmap
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x *.sh
   ```

3. **Run individual scripts**:
   ```bash
   # Monitor logins
   ./0-login.sh
   
   # Check active connections
   ./1-active-connections.sh
   
   # Configure firewall
   ./2-incoming_connections.sh
   
   # Audit firewall rules
   ./3-firewall_rules.sh
   
   # Check network services
   ./4-network_services.sh
   
   # System security audit
   ./5-audit_system.sh
   
   # Capture network packets
   ./6-capture_analyze.sh
   
   # Scan target host
   ./7-scan.sh 192.168.1.1
   ```

## 🧪 Testing Examples

```bash
# Check last 5 user logins
./0-login.sh
# Output: Login history with timestamps

# Monitor TCP connections
./1-active-connections.sh  
# Output: Active TCP connections with processes

# Setup secure firewall
./2-incoming_connections.sh
# Result: UFW configured with HTTP access only

# Audit security table rules
./3-firewall_rules.sh
# Output: iptables security rules

# List listening services
./4-network_services.sh
# Output: Active network services and ports

# Run security audit
./5-audit_system.sh
# Output: Comprehensive security assessment

# Capture 5 network packets
./6-capture_analyze.sh
# Output: Packet details and analysis

# Scan local host
./7-scan.sh localhost
# Output: Open ports and services
```

## 📚 Prerequisites

- Linux environment (Ubuntu/Debian/Kali recommended)
- Sudo privileges for system-level operations
- Basic understanding of:
  - Linux command line
  - Network protocols (TCP/UDP)
  - Firewall concepts
  - Security principles

## 🔗 Additional Resources

- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [iptables Tutorial](https://www.netfilter.org/documentation/)
- [Lynis Security Auditing](https://cisofy.com/lynis/)
- [tcpdump Manual](https://www.tcpdump.org/manpages/tcpdump.1.html)
- [Nmap Reference Guide](https://nmap.org/book/)
- [Linux Security Best Practices](https://linux-audit.com/)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Advanced Linux Security and System Administration* 🛡️

---

**⚠️ Disclaimer**: These tools are for educational and authorized security testing purposes only. Always obtain proper authorization before conducting security assessments on systems you do not own. Respect legal boundaries and ethical guidelines in cybersecurity practice.