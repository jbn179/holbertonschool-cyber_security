# 🛡️ Cybersecurity Basics - 0x00 Introduction to Cybersecurity

## 📋 Project Overview

This project introduces fundamental cybersecurity concepts and tools through practical Bash scripting exercises on **Kali Linux**. Students will learn essential security operations including system information gathering, secure password generation, cryptographic validation, SSH key management, and process monitoring.

**Project**: `0x00_introduction_cybersecurity`  
**Environment**: Kali Linux  
**Repository**: `holbertonschool-cyber_security`

## 🎯 Learning Objectives

After completing this project, you will be able to:

- ✅ Gather system information for security assessments
- 🔐 Generate cryptographically secure passwords
- 🔍 Validate file integrity using SHA256 hashes
- 🔑 Create and manage SSH key pairs for secure authentication
- 👁️ Monitor and filter system processes for security analysis

## 📁 Project Structure

| Task | Script | Description | Requirements | Score |
|------|--------|-------------|--------------|-------|
| **0** | `0-release.sh` | Display distributor ID (Kali detection) | Single line, no awk | 6/6 pts |
| **1** | `1-gen_password.sh` | Generate strong random passwords | <3 lines, /dev/urandom, [:alnum:] | 4/4 pts |
| **2** | `2-sha256_validator.sh` | Validate file integrity with SHA256 | <3 lines, echo allowed | 6/6 pts |
| **3** | `3-gen_key.sh` | Generate 4096-bit RSA SSH keys | OpenSSH, 4096 bits | 8/8 pts |
| **4** | `4-root_process.sh` | Monitor user processes | ps command, grep -v VSZ/RSS=0 | - |

## 🔧 Scripts Documentation

### 0️⃣ Kali Detection (`0-release.sh`)
```bash
#!/bin/bash
lsb_release -si
```

**Code Explanation**:
- `lsb_release -si` : **s**hort format, **i**dentity only → Outputs just "Kali"
- Simple and elegant solution using LSB (Linux Standard Base) tools
- No `awk` needed, direct command output

**Usage & Output**:
```bash
./0-release.sh
Kali
```
**Security Context**: Quick system identification for pentesting environment validation

### 1️⃣ Strong Password Generator (`1-gen_password.sh`)
```bash
#!/bin/bash
tr -dc '[:alnum:]' < /dev/urandom | head -c "$1"
```

**Code Explanation**:
- `tr -dc '[:alnum:]'` : **d**elete **c**omplement of alphanumeric characters
- `< /dev/urandom` : Cryptographically secure random source
- `head -c "$1"` : Take exactly `$1` characters (first argument)
- Pipeline: random bytes → filter → limit length

**Usage & Output**:
```bash
./1-gen_password.sh 20
MkPpprPyC3i6navUB3Lj
```
**Security Context**: Generates strong passwords for credential management and account security

### 2️⃣ File Integrity Validator (`2-sha256_validator.sh`)
```bash
#!/bin/bash
echo "$2  $1" | sha256sum -c
```

**Code Explanation**:
- `echo "$2  $1"` : Creates checksum format → `hash  filename`
- `$2` = expected hash (2nd argument), `$1` = filename (1st argument)
- `sha256sum -c` : **c**heck mode, validates hash against file
- Two spaces between hash and filename (sha256sum format requirement)

**Usage & Output**:
```bash
./2-sha256_validator.sh test_file e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
test_file: OK
```
**Security Context**: File integrity verification for forensics and tamper detection

### 3️⃣ RSA SSH Key Pair Generator (`3-gen_key.sh`)
```bash
#!/bin/bash
ssh-keygen -t rsa -b 4096 -f "$1" -N ""
```

**Code Explanation**:
- `ssh-keygen` : OpenSSH key generation utility
- `-t rsa` : Key **t**ype = RSA algorithm
- `-b 4096` : **b**it length = 4096 bits (high security)
- `-f "$1"` : **f**ilename = first argument (keyname)
- `-N ""` : **N**ew passphrase = empty (no password protection)

**Usage & Output**:
```bash
./3-gen_key.sh new_key
Generating public/private rsa key pair.
Your identification has been saved in new_key
Your public key has been saved in new_key.pub
The key fingerprint is:
SHA256:aq73wv2/5u6k/qoGF83U3DZNsy5jg7Omv+zCSHkdbUM yosri@hbtn-lab

# File permissions automatically set:
-rw------- 1 yosri yosri 3381 new_key      # Private key (600)
-rw-r--r-- 1 yosri yosri  740 new_key.pub  # Public key (644)
```
**Security Context**: Key-based authentication for secure remote access and automation

### 4️⃣ User Process Monitor (`4-root_process.sh`)
```bash
#!/bin/bash
ps aux | grep "^$1" | grep -v " 0      0 "
```

**Code Explanation**:
- `ps aux` : **a**ll processes, **u**ser format, include processes without terminals
- `grep "^$1"` : Filter lines starting with username (`$1` = first argument)
- `grep -v " 0      0 "` : Exclude processes with VSZ=0 and RSS=0 (kernel processes)
- Pipeline: all processes → filter by user → exclude kernel processes

**Usage & Output**:
```bash
./4-root_process.sh root
root           1  0.0  0.0  21172 12376 ?        Ss   07:38   0:01 /sbin/init splash
root         598  0.0  0.1  66380 19908 ?        Ss   07:39   0:00 /lib/systemd/systemd-journald
root         614  0.0  0.0 152264  1548 ?        Ssl  07:39   0:00 vmware-vmblock-fuse
root         619  0.0  0.0  28688  8192 ?        Ss   07:39   0:00 /lib/systemd/systemd-udevd
root         768  0.0  0.0   8264  5304 ?        Ss   07:39   0:00 /usr/sbin/haveged
root        1005  0.0  0.0 311384  9268 ?        Ssl  07:39   0:00 /usr/libexec/accounts-daemon
```
**Security Context**: Process monitoring for incident response, privilege escalation detection, and system forensics

## 🚨 Security Considerations

### 🔐 **Password Security**
- Passwords use `/dev/urandom` for cryptographic randomness
- Alphanumeric characters only (safe for most systems)
- Length should be minimum 12 characters for adequate security

### 🔑 **SSH Key Security**
- 4096-bit RSA keys provide strong security
- Keys generated without passphrase for automation
- **⚠️ Warning**: Protect private keys with `chmod 600`

### 📊 **Process Monitoring**
- Filters out kernel processes (VSZ/RSS = 0)
- Shows process owners for privilege escalation detection
- Useful for incident response and forensics

## 📚 Prerequisites

- Linux/Unix environment
- Bash shell (version 4.0+)
- Standard utilities: `lsb_release`, `tr`, `sha256sum`, `ssh-keygen`, `ps`
- Basic understanding of command-line operations

## 🛠️ Installation & Usage

1. **Clone or download the scripts**
2. **Make scripts executable**:
   ```bash
   chmod +x *.sh
   ```
3. **Run individual scripts** as documented above

## 🧪 Testing Examples

```bash
# Kali Detection
./0-release.sh
# Expected Output: Kali

# Generate 20-character password
./1-gen_password.sh 20
# Expected Output: MkPpprPyC3i6navUB3Lj (varies each time)

# Validate file integrity (empty file example)
./2-sha256_validator.sh test_file e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
# Expected Output: test_file: OK

# Generate SSH keys
./3-gen_key.sh new_key
# Creates: new_key (private) and new_key.pub (public)
# Shows fingerprint and randomart

# Monitor root processes
./4-root_process.sh root
# Expected Output: List of root processes (excluding kernel processes with VSZ/RSS=0)
```

## 📊 Project Requirements Summary

| Task | Max Lines | Special Requirements | Key Restrictions |
|------|-----------|---------------------|------------------|
| **0** | 1 line + newline | Display distributor ID | ❌ No `awk` |
| **1** | < 3 lines | Use `/dev/urandom` + `[:alnum:]` | ✅ Accept length argument |
| **2** | < 3 lines | File integrity validation | ✅ `echo` allowed |
| **3** | No limit | 4096-bit RSA keys | ✅ Must use OpenSSH |
| **4** | No limit | Process monitoring | ✅ Use `ps` + `grep -v` |



## 🔗 Additional Resources

- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [OWASP Security Guidelines](https://owasp.org/)
- [Linux Security Best Practices](https://linux-audit.com/)
- [SSH Key Management Guide](https://www.ssh.com/academy/ssh/keygen)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Building the next generation of cybersecurity professionals* 🛡️

---

**⚠️ Disclaimer**: These scripts are for educational purposes. Always follow your organization's security policies and obtain proper authorization before using security tools in production environments.