# 🔍 Passive Reconnaissance - 0x01 Network Security

## 📋 Project Overview

This project focuses on **passive reconnaissance** techniques in network security through DNS enumeration, subdomain discovery, and OSINT (Open Source Intelligence) gathering. Passive reconnaissance involves collecting information about targets without directly interacting with them, making it stealthy and undetectable.

**Project**: `0x01_passive_reconnaissance`  
**Environment**: Linux with DNS tools and reconnaissance utilities  
**Repository**: `holbertonschool-cyber_security`

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🌐 Perform comprehensive DNS enumeration and record analysis
- 📧 Extract contact information from domain registration data
- 🔍 Discover subdomains using automated reconnaissance tools
- 📊 Analyze DNS records for security assessment purposes
- 🎯 Conduct OSINT gathering through various online resources
- 📝 Generate structured reports from reconnaissance data

## 📁 Project Structure

| Task | Script | Description | Key Tool |
|------|--------|-------------|----------|
| **0** | `0-whois.sh` | Domain registration information extraction | `whois` |
| **1** | `1-a_record.sh` | DNS A record resolution | `nslookup` |
| **2** | `2-mx_record.sh` | Mail exchange record enumeration | `nslookup` |
| **3** | `3-txt_record.sh` | TXT record information gathering | `nslookup` |
| **4** | `4-dig_all.sh` | Comprehensive DNS record analysis | `dig` |
| **5** | `5-subfinder.sh` | Automated subdomain discovery | `subfinder` |
| **Bonus** | Flag files | OSINT challenge completion | Manual research |

## 🔧 Scripts Documentation

### 0️⃣ WHOIS Information Extraction (`0-whois.sh`)
```bash
#!/bin/bash
whois $1|awk -F': ' '/^Registrant |^Admin |^Tech /{gsub(/^Registry /,"");print $1","$2}'>$1.csv
```

**Code Explanation**:
- `whois $1` : Query domain registration information
- `awk -F': '` : Field separator set to colon-space
- `/^Registrant |^Admin |^Tech /` : Match registrant, admin, and technical contacts
- `gsub(/^Registry /,"")` : Remove "Registry" prefix
- `print $1","$2` : Output in CSV format
- `>$1.csv` : Save results to domain-named CSV file

**Security Context**: Contact information gathering, social engineering preparation, organizational mapping

### 1️⃣ DNS A Record Resolution (`1-a_record.sh`)
```bash
#!/bin/bash
nslookup $1 8.8.8.8
```

**Code Explanation**:
- `nslookup $1` : Resolve domain to IP address
- `8.8.8.8` : Use Google's public DNS server for queries
- Returns IPv4 address mapping for the domain

**Security Context**: IP address identification, infrastructure mapping, network reconnaissance

### 2️⃣ Mail Exchange Records (`2-mx_record.sh`)
```bash
#!/bin/bash
nslookup -type=MX $1 8.8.8.8
```

**Code Explanation**:
- `nslookup -type=MX` : Query specifically for MX records
- `$1` : Target domain parameter
- `8.8.8.8` : Google DNS for consistent results
- Returns mail server information and priorities

**Security Context**: Email infrastructure enumeration, phishing campaign preparation, mail server targeting

### 3️⃣ TXT Record Analysis (`3-txt_record.sh`)
```bash
#!/bin/bash
nslookup -type=TXT $1 8.8.8.8
```

**Code Explanation**:
- `nslookup -type=TXT` : Query TXT records specifically
- TXT records contain various information: SPF, DKIM, verification codes
- Often reveals third-party services and configurations

**Security Context**: Service enumeration, SPF/DKIM analysis, technology stack identification

### 4️⃣ Comprehensive DNS Analysis (`4-dig_all.sh`)
```bash
#!/bin/bash
dig +noall +answer $1 any
```

**Code Explanation**:
- `dig` : More advanced DNS lookup tool than nslookup
- `+noall` : Suppress all output sections
- `+answer` : Show only the answer section
- `any` : Query for all available record types

**Security Context**: Complete DNS footprinting, infrastructure analysis, service discovery

### 5️⃣ Automated Subdomain Discovery (`5-subfinder.sh`)
```bash
#!/bin/bash
subfinder -silent -d $1 -o $1.txt -nW -oI
```

**Code Explanation**:
- `subfinder` : Automated subdomain enumeration tool
- `-silent` : Suppress verbose output
- `-d $1` : Target domain
- `-o $1.txt` : Output to domain-named file
- `-nW` : No wildcard filtering
- `-oI` : Output IP addresses along with subdomains

**Security Context**: Attack surface expansion, hidden service discovery, comprehensive asset mapping

## 🏆 Project Results

### 🎯 **Flags Discovered**
| **Flag** | **Value** | **Source** |
|----------|-----------|------------|
| **Flag 1** | `33f2788b8fc9e4491de9dc6f1508c3b9` | OSINT Challenge 1 |
| **Flag 2** | `f7fa98301068787c242679b7b297f8e2` | OSINT Challenge 2 |
| **Flag 3** | `61b2662611e0e2a178468e30739142c6` | OSINT Challenge 3 |

### 📊 **Additional Artifacts**
- `holbertonschool_report.md` : Comprehensive reconnaissance report
- `shodan_ip_holberton.bmp` : Shodan IP analysis results
- `shodan_tech_holberton.bmp` : Technology stack analysis

## 🛠️ Tools Reference

### 🌐 **DNS Enumeration**
```bash
# Basic DNS resolution
nslookup <domain> 8.8.8.8

# Specific record types
nslookup -type=MX <domain>
nslookup -type=TXT <domain>
nslookup -type=NS <domain>

# Advanced DNS analysis
dig <domain> any
dig @8.8.8.8 <domain> MX
```

### 🔍 **Domain Intelligence**
```bash
# WHOIS information
whois <domain>

# Subdomain enumeration
subfinder -d <domain>
sublist3r -d <domain>

# Certificate transparency
crt.sh search
```

### 📊 **OSINT Platforms**
- **Shodan**: IoT and service discovery
- **Certificate Transparency Logs**: Subdomain discovery
- **VirusTotal**: Domain reputation and relationships
- **DNSdumpster**: DNS reconnaissance visualization

## 🚨 Security Considerations

### ⚖️ **Ethical Guidelines**
- Passive techniques are generally legal but respect rate limits
- Do not use gathered information for malicious purposes
- Follow responsible disclosure for discovered vulnerabilities

### 🛡️ **Defensive Perspectives**
- Limit public DNS information exposure
- Monitor certificate transparency logs for unauthorized certificates
- Implement DNS monitoring for reconnaissance detection

### 📊 **Operational Security**
- Use different DNS servers to avoid detection patterns
- Implement query timing to avoid triggering rate limits
- Consider using VPN or proxy for additional anonymity

## 📚 Prerequisites

- **Operating System**: Linux environment with networking tools
- **Required Tools**: `whois`, `nslookup`, `dig`, `subfinder`
- **Network Access**: Internet connectivity for DNS queries
- **Knowledge**: Basic DNS concepts, command-line proficiency

## 🛠️ Installation & Usage

1. **Install required tools**:
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install whois dnsutils

   # Install subfinder
   go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x *.sh
   ```

3. **Execute reconnaissance scripts**:
   ```bash
   # Domain registration information
   ./0-whois.sh example.com

   # DNS record enumeration
   ./1-a_record.sh example.com
   ./2-mx_record.sh example.com
   ./3-txt_record.sh example.com
   ./4-dig_all.sh example.com

   # Subdomain discovery
   ./5-subfinder.sh example.com
   ```

## 🧪 Usage Examples

```bash
# Complete reconnaissance workflow
./0-whois.sh holbertonschool.com
# Output: holbertonschool.com.csv with contact information

./1-a_record.sh holbertonschool.com
# Output: IP address resolution

./2-mx_record.sh holbertonschool.com  
# Output: Mail server information

./3-txt_record.sh holbertonschool.com
# Output: TXT records including SPF, DKIM

./4-dig_all.sh holbertonschool.com
# Output: Complete DNS record analysis

./5-subfinder.sh holbertonschool.com
# Output: holbertonschool.com.txt with discovered subdomains
```

## 📊 Project Requirements Summary

| Task | Output Format | Technical Requirements | Key Information |
|------|---------------|----------------------|-----------------|
| **0** | CSV file | WHOIS contact extraction | Registrant, Admin, Tech contacts |
| **1** | Terminal output | A record resolution | IPv4 addresses |
| **2** | Terminal output | MX record enumeration | Mail servers and priorities |
| **3** | Terminal output | TXT record analysis | SPF, DKIM, verification records |
| **4** | Terminal output | Complete DNS analysis | All record types |
| **5** | Text file | Subdomain discovery | Subdomains with IP addresses |

## 🔗 Additional Resources

- [DNS Security Best Practices](https://www.cloudflare.com/learning/dns/dns-security/)
- [OSINT Framework](https://osintframework.com/)
- [Subfinder Documentation](https://github.com/projectdiscovery/subfinder)
- [DNS Record Types Reference](https://en.wikipedia.org/wiki/List_of_DNS_record_types)
- [Passive Reconnaissance Techniques](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/01-Information_Gathering/01-Conduct_Search_Engine_Discovery_Reconnaissance_for_Information_Leakage)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Network Security and Intelligence Gathering* 🛡️

---

**⚠️ Legal Disclaimer**: This project involves passive reconnaissance techniques for educational purposes. While these methods typically do not directly interact with target systems, users must ensure compliance with applicable laws and regulations. Always obtain proper authorization before conducting reconnaissance on systems or organizations you do not own.