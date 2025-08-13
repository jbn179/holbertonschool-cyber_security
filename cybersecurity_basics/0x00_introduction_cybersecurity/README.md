# 🛡️ Cybersecurity Basics - 0x00 Introduction to Cybersecurity

## 📋 Project Overview

This project introduces fundamental cybersecurity concepts and tools through practical Bash scripting exercises on **Kali Linux**. Students will learn essential security operations including system information gathering, secure password generation, cryptographic validation, SSH key management, and process monitoring for security analysis.

**Project**: `0x00_introduction_cybersecurity`  
**Environment**: Kali Linux  
**Repository**: `holbertonschool-cyber_security`

## 🎯 Learning Objectives

After completing this project, you will be able to:

- 🔍 Gather system information for security assessments and environment validation
- 🔐 Generate cryptographically secure passwords using system entropy
- 🔒 Validate file integrity using SHA256 cryptographic hashes
- 🔑 Create and manage RSA SSH key pairs for secure authentication
- 👁️ Monitor and filter system processes for security analysis and incident response

## 📁 Project Structure

| Task | Script | Description | Key Tool |
|------|--------|-------------|----------|
| **0** | `0-release.sh` | System distributor identification | `lsb_release` |
| **1** | `1-gen_password.sh` | Cryptographically secure password generation | `/dev/urandom` |
| **2** | `2-sha256_validator.sh` | File integrity validation with SHA256 | `sha256sum` |
| **3** | `3-gen_key.sh` | RSA SSH key pair generation | `ssh-keygen` |
| **4** | `4-root_process.sh` | User process monitoring and filtering | `ps` |

## 🔧 Scripts Documentation

### 0️⃣ System Identification (`0-release.sh`)
```bash
#!/bin/bash
lsb_release -si
```

**Code Explanation**:
- `lsb_release` : Linux Standard Base release information utility
- `-s` : Short format output (concise, single word)
- `-i` : Display distributor ID only
- Outputs system identifier for environment validation

**Usage & Output**:
```bash
./0-release.sh
Kali
```
**Security Context**: Environment fingerprinting, penetration testing setup validation, system reconnaissance

### 1️⃣ Secure Password Generator (`1-gen_password.sh`)
```bash
#!/bin/bash
tr -dc '[:alnum:]' < /dev/urandom | head -c "$1"
```

**Code Explanation**:
- `/dev/urandom` : Kernel entropy source for cryptographically secure randomness
- `tr -dc '[:alnum:]'` : **d**elete **c**omplement - keep only alphanumeric characters
- `head -c "$1"` : Extract exactly `$1` characters from the stream
- Pipeline ensures uniform distribution of secure random characters

**Usage & Output**:
```bash
./1-gen_password.sh 20
MkPpprPyC3i6navUB3Lj
```
**Security Context**: Strong password generation for account security, credential management, secure system access

### 2️⃣ File Integrity Validator (`2-sha256_validator.sh`)
```bash
#!/bin/bash
echo "$2  $1" | sha256sum -c
```

**Code Explanation**:
- `echo "$2  $1"` : Format as `hash  filename` (sha256sum expected format)
- `$2` : Expected SHA256 hash (second argument)
- `$1` : Target filename (first argument)
- `sha256sum -c` : Check mode - validates computed hash against provided hash
- Two spaces between hash and filename (required by sha256sum format)

**Usage & Output**:
```bash
./2-sha256_validator.sh test_file e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
test_file: OK
```
**Security Context**: File integrity verification, tamper detection, forensic analysis, data validation

### 3️⃣ RSA SSH Key Generator (`3-gen_key.sh`)
```bash
#!/bin/bash
ssh-keygen -t rsa -b 4096 -f "$1" -N ""
```

**Code Explanation**:
- `ssh-keygen` : OpenSSH key generation and management utility
- `-t rsa` : Algorithm **t**ype - RSA public key cryptography
- `-b 4096` : Key length in **b**its - 4096 bits for high security
- `-f "$1"` : Output **f**ilename prefix (creates private and .pub files)
- `-N ""` : **N**ew passphrase - empty string for automation/scripting

**Usage & Output**:
```bash
./3-gen_key.sh new_key
Generating public/private rsa key pair.
Your identification has been saved in new_key
Your public key has been saved in new_key.pub
The key fingerprint is:
SHA256:aq73wv2/5u6k/qoGF83U3DZNsy5jg7Omv+zCSHkdbUM yosri@hbtn-lab

# Files created with secure permissions:
-rw------- 1 yosri yosri 3381 new_key      # Private key (owner read/write only)
-rw-r--r-- 1 yosri yosri  740 new_key.pub  # Public key (world readable)
```
**Security Context**: Key-based authentication, secure remote access, automated deployment, passwordless authentication

### 4️⃣ Process Security Monitor (`4-root_process.sh`)
```bash
#!/bin/bash
ps aux | grep "^$1" | grep -v " 0      0 "
```

**Code Explanation**:
- `ps aux` : Process status - **a**ll processes, **u**ser format, include processes without **x** controlling terminal
- `grep "^$1"` : Filter lines beginning with username (first argument)
- `grep -v " 0      0 "` : Exclude processes with VSZ=0 and RSS=0 (kernel threads)
- Three-stage pipeline: list → filter by user → exclude kernel processes

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
**Security Context**: Process monitoring, privilege escalation detection, incident response, system forensics

## 🚨 Security Considerations

### 🔐 **Cryptographic Security**
- `/dev/urandom` provides cryptographically secure pseudo-random numbers
- SHA256 offers strong collision resistance for integrity verification
- 4096-bit RSA keys exceed current security recommendations

### 🔑 **Key Management**
- Private keys generated without passphrase for automation scenarios
- **⚠️ Critical**: Secure private key storage with appropriate file permissions (600)
- Public keys can be freely distributed for authentication setup

### 📊 **Process Monitoring**
- Kernel process filtering prevents information noise
- User-specific filtering enables targeted security analysis
- Process enumeration useful for detecting unauthorized activities

### ⚠️ **Operational Security**
- Scripts require appropriate system permissions
- Password generation should use sufficient length (minimum 12 characters)
- File validation requires trusted hash sources

## 📚 Prerequisites

- **Operating System**: Linux/Unix environment (Kali Linux recommended)
- **Shell**: Bash version 4.0 or higher
- **System Tools**: `lsb_release`, `tr`, `sha256sum`, `ssh-keygen`, `ps`
- **Permissions**: Standard user privileges (sudo not required for basic operations)
- **Knowledge**: Basic command-line proficiency and security concepts

## 🛠️ Installation & Usage

1. **Verify system tools availability**:
   ```bash
   # Check required utilities
   which lsb_release tr sha256sum ssh-keygen ps
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x *.sh
   ```

3. **Execute scripts as documented**:
   ```bash
   # System identification
   ./0-release.sh
   
   # Generate 16-character password
   ./1-gen_password.sh 16
   
   # Validate file integrity
   ./2-sha256_validator.sh myfile.txt expected_hash_value
   
   # Generate SSH key pair
   ./3-gen_key.sh production_key
   
   # Monitor user processes
   ./4-root_process.sh username
   ```

## 🧪 Testing Examples

```bash
# Environment validation
./0-release.sh
# Expected Output: Kali

# Secure password generation
./1-gen_password.sh 24
# Expected Output: aB3kL9mN4qR7sT2vX8wZ1cD5 (varies each execution)

# File integrity verification (empty file example)
./2-sha256_validator.sh test_file e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
# Expected Output: test_file: OK

# SSH key generation
./3-gen_key.sh deployment_key
# Creates: deployment_key (private) and deployment_key.pub (public)
# Displays: Key fingerprint and randomart visualization

# Process security monitoring
./4-root_process.sh root
# Expected Output: Active root processes (excluding kernel threads)
```

## 📊 Project Requirements Summary

| Task | Line Limit | Technical Requirements | Restrictions |
|------|------------|----------------------|--------------|
| **0** | 2 lines (shebang + command) | System distributor identification | ❌ No `awk` usage |
| **1** | < 3 lines total | Entropy source `/dev/urandom`, `[:alnum:]` charset | ✅ Accept length parameter |
| **2** | < 3 lines total | SHA256 integrity validation | ✅ `echo` command permitted |
| **3** | No restriction | 4096-bit RSA key generation | ✅ OpenSSH tools required |
| **4** | No restriction | Process enumeration and filtering | ✅ `ps` and `grep -v` required |

## 🔗 Additional Resources

- [NIST Special Publication 800-63B - Authentication Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [SSH Key Management Best Practices](https://www.ssh.com/academy/ssh/keygen)
- [Linux Security and Hardening Guide](https://linux-audit.com/)
- [Cryptographic Standards and Guidelines](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)

## 👥 Author

**Holberton School Cybersecurity Program**  
*Foundational Security Skills Development* 🛡️

---

**⚠️ Legal Disclaimer**: These tools are designed for educational purposes and authorized security testing only. Users must obtain explicit permission before conducting security assessments on systems they do not own. Respect all applicable laws, regulations, and ethical guidelines in cybersecurity practice.