# 0x04 Nmap Live Hosts Discovery

This project contains Bash scripts for discovering live hosts on a network using different scanning techniques with Nmap.

## Description

Live host discovery is a fundamental step in network reconnaissance. This project implements various scanning techniques to detect online machines on a given network, each adapted to different scenarios and network environments.

## Available Scripts

### 0-arp_scan.sh
**ARP Ping Scan**
```bash
./0-arp_scan.sh <target>
```
- Uses ARP requests to discover hosts on the local network
- Very effective on local networks (same subnet)
- Nmap option: `-sn -PR`

### 1-icmp_echo_scan.sh
**ICMP Echo Scan**
```bash
./1-icmp_echo_scan.sh <target>
```
- Sends ICMP Echo Request packets (traditional ping)
- Works well if ICMP is not blocked by firewalls
- Nmap option: `-sn -PE`

### 2-icmp_timestamp_scan.sh
**ICMP Timestamp Scan**
```bash
./2-icmp_timestamp_scan.sh <target>
```
- Uses ICMP Timestamp requests
- Alternative when Echo Requests are blocked
- Nmap option: `-sn -PP`

### 3-icmp_address_mask_scan.sh
**ICMP Address Mask Scan**
```bash
./3-icmp_address_mask_scan.sh <target>
```
- Sends ICMP Address Mask requests
- Can bypass certain ICMP restrictions
- Nmap option: `-sn -PM`

### 4-tcp_syn_ping.sh
**TCP SYN Ping**
```bash
./4-tcp_syn_ping.sh <target>
```
- Sends TCP SYN packets to ports 22, 80, 443
- Effective when ICMP is blocked
- Nmap option: `-sn -PS22,80,443`

### 5-tcp_ack_ping.sh
**TCP ACK Ping**
```bash
./5-tcp_ack_ping.sh <target>
```
- Sends TCP ACK packets to ports 22, 80, 443
- Can bypass certain stateless firewalls
- Nmap option: `-sn -PA22,80,443`

### 6-udp_ping_scan.sh
**UDP Ping Scan**
```bash
./6-udp_ping_scan.sh <target>
```
- Sends UDP packets to ports 53, 161, 162
- Useful when TCP and ICMP are blocked
- Nmap option: `-sn -PU53,161,162`

## Usage

### Prerequisites
- Nmap installed on the system
- Administrative privileges (sudo) for execution
- Linux/Unix system

### Usage Examples

```bash
# Scan a single IP address
./0-arp_scan.sh 192.168.1.1

# Scan a subnet
./1-icmp_echo_scan.sh 192.168.1.0/24

# Scan a range of addresses
./4-tcp_syn_ping.sh 192.168.1.1-254
```

### Supported Target Formats
- Single IP address: `192.168.1.1`
- CIDR subnet: `192.168.1.0/24`
- Address range: `192.168.1.1-254`
- Address list: `192.168.1.1,192.168.1.5,192.168.1.10`

## Usage Recommendations

1. **Local network**: Start with ARP scan (`0-arp_scan.sh`)
2. **Remote network**: Use ICMP Echo (`1-icmp_echo_scan.sh`) first
3. **Restrictive environment**: Try TCP SYN/ACK ping (`4-tcp_syn_ping.sh`, `5-tcp_ack_ping.sh`)
4. **Last resort**: UDP ping scan (`6-udp_ping_scan.sh`)

## Important Notes

- **Legality**: Ensure you have authorization before scanning networks
- **Performance**: Some scans may be slow on large networks
- **Detection**: These techniques can be detected by IDS/IPS systems
- **Privileges**: Execution requires root privileges (sudo)

## Project Results and Deliverables

### Challenge Flag
- **100-flag.txt**: Flag obtained during the practical reconnaissance challenge
- **Purpose**: Demonstrates successful application of host discovery techniques
- **Achievement**: Validation of learning objectives and practical skills

### Comprehensive Report
- **rapport-nmap-complet.md**: Detailed analysis and documentation
- **Contents**: Complete methodology, results analysis, and technical insights
- **Purpose**: In-depth exploration of network reconnaissance techniques

## Educational Objectives

This project allows learning:
- Different host discovery techniques and their appropriate use cases
- Practical application of Nmap for network reconnaissance
- Network protocols (ARP, ICMP, TCP, UDP) and their security implications
- Firewall evasion strategies and stealth scanning techniques
- Ethical network reconnaissance and responsible disclosure

### Learning Outcomes

Upon completion, students will:
- **Understand Protocol Differences**: Know when to use ARP vs ICMP vs TCP/UDP pings
- **Master Nmap Options**: Proficient with host discovery flags and techniques
- **Recognize Network Behavior**: Understand how different networks respond to scans
- **Apply Ethical Standards**: Practice responsible reconnaissance methodologies
- **Document Findings**: Create comprehensive reports of reconnaissance activities

## Advanced Concepts

### Stealth and Evasion
- **Timing Options**: Understanding scan timing and stealth considerations
- **Firewall Detection**: Identifying filtered vs closed ports
- **IDS/IPS Awareness**: Recognizing detection and prevention systems
- **Traffic Analysis**: Understanding network traffic patterns

### Real-World Applications
- **Network Inventory**: Asset discovery and network mapping
- **Security Assessment**: Identifying exposed systems and services
- **Penetration Testing**: Initial reconnaissance phase
- **Incident Response**: Network forensics and investigation

## Professional Context

### Industry Usage
- **Network Administrators**: Regular network health and inventory checks
- **Security Analysts**: Threat hunting and vulnerability assessment
- **Penetration Testers**: Initial reconnaissance and attack surface mapping
- **Incident Responders**: Network forensics and breach investigation

### Compliance and Standards
- **PCI DSS**: Regular network scanning requirements
- **NIST Framework**: Asset inventory and management
- **ISO 27001**: Information security management systems
- **SANS Critical Controls**: Network ports, protocols, and services

## Ethical and Legal Considerations

### Authorization Requirements
- **Written Permission**: Always obtain explicit authorization before scanning
- **Scope Definition**: Clearly define authorized targets and techniques
- **Legal Compliance**: Understand applicable laws and regulations
- **Responsible Disclosure**: Report findings through appropriate channels

### Professional Ethics
- **Minimize Impact**: Use least intrusive methods necessary
- **Respect Privacy**: Protect discovered information and data
- **Maintain Integrity**: Provide accurate and honest reporting
- **Continuous Learning**: Stay updated on best practices and legal requirements

## Further Reading and Resources

### Technical Documentation
- [Nmap Network Scanning Guide](https://nmap.org/book/) - Comprehensive Nmap documentation
- [RFC 792 - ICMP](https://tools.ietf.org/html/rfc792) - Internet Control Message Protocol
- [RFC 826 - ARP](https://tools.ietf.org/html/rfc826) - Address Resolution Protocol
- [SANS Network Discovery](https://www.sans.org/white-papers/) - Professional reconnaissance techniques

### Professional Development
- [GIAC Certified Incident Handler (GCIH)](https://www.giac.org/certification/certified-incident-handler-gcih)
- [Certified Ethical Hacker (CEH)](https://www.eccouncil.org/programs/certified-ethical-hacker-ceh/)
- [NMAP Scripting Engine (NSE)](https://nmap.org/nsedoc/) - Advanced Nmap capabilities
- [Network Security Assessment](https://www.oreilly.com/library/view/network-security-assessment/0596006611/) - Professional assessment techniques

## Author

Project completed as part of Holberton School - Cybersecurity curriculum

---

**Repository**: holbertonschool-cyber_security  
**Module**: Network Security  
**Project**: 0x04 - Nmap Live Hosts Discovery  
**Focus**: Host discovery techniques and network reconnaissance  
**Level**: Intermediate  
**Last Updated**: 2024
