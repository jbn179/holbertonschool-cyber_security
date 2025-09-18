# Web Application Security - OWASP Top 10

## Overview

This project explores the 10 most critical web security vulnerabilities according to OWASP (Open Web Application Security Project). It offers a practical and defensive approach to understand, identify, and protect against these major threats.

## Learning Objectives

By the end of this project, you should be able to:

- Identify and understand OWASP Top 10 2021 vulnerabilities
- Exploit these vulnerabilities in a controlled environment for educational purposes
- Implement appropriate protection measures
- Use decoding and security analysis tools
- Develop a methodical approach to web application security testing

## Project Structure

### Main Scripts and Tools

#### `1-xor_decoder.sh`
**Purpose**: XOR decoding script for analyzing encrypted data
**Usage**: Decoding obfuscated strings using XOR algorithm
**Documentation**: See `1-xor_decoder_documentation.md` for complete details
**Application**: Used in cryptographic failures tasks

### Results and Challenges

The project contains results from 4 main OWASP challenges:

#### `0-flag.txt` - Session Hijacking
**Vulnerability**: A01:2021 - Broken Access Control
**Technique**: Exploitation of predictable session cookies
**Objective**: Understand the importance of secure session identifier generation

#### `2-flag.txt` - Cryptographic Failures  
**Vulnerability**: A02:2021 - Cryptographic Failures
**Technique**: Authentication header analysis and multi-step decoding
**Tools Used**: Base64 decoder + XOR decoder
**Objective**: Identify flaws in sensitive data protection

#### `3-flag.txt` - Stored XSS (Part 1)
**Vulnerability**: A03:2021 - Injection (Cross-Site Scripting)
**Technique**: Profile identification and exploitation for XSS propagation
**Context**: Simulation of the Samy worm (MySpace 2005)
**Objective**: Understand stored XSS attack propagation

#### `4-vuln.txt` - XSS Field Discovery
**Vulnerability**: A03:2021 - Injection (Cross-Site Scripting)
**Technique**: Identification of field vulnerable to stored XSS
**Method**: Systematic testing of input fields
**Result**: Name of identified vulnerable field

### Complete Documentation

#### `project_documentation.md`
Complete technical documentation containing:
- Detailed methodology for each challenge
- Step-by-step exploitation instructions
- Theoretical context of vulnerabilities
- Recommended protection measures
- Procedure for the 4 main tasks

#### `1-xor_decoder_documentation.md`
Specialized guide for the XOR decoder tool:
- XOR encryption operating principle
- Script usage instructions
- Practical application examples
- Usage context in challenges

## OWASP Top 10 2021 - Context

### Vulnerabilities Covered in This Project

#### A01:2021 - Broken Access Control (Task 0)
- **Impact**: Unauthorized access to data and functionality
- **Example**: Session hijacking via predictable cookies
- **Protection**: Cryptographically secure identifier generation

#### A02:2021 - Cryptographic Failures (Task 2)  
- **Impact**: Sensitive data exposure
- **Example**: Weakly encoded credentials in headers
- **Protection**: Proper encryption and secure key management

#### A03:2021 - Injection (Tasks 3-4)
- **Impact**: Malicious code execution, data theft
- **Example**: Stored Cross-Site Scripting (XSS)
- **Protection**: Input validation, sanitization, and escaping

### Other Top 10 Vulnerabilities (Not Covered)

- **A04** - Insecure Design
- **A05** - Security Misconfiguration
- **A06** - Vulnerable and Outdated Components
- **A07** - Identification and Authentication Failures
- **A08** - Software and Data Integrity Failures
- **A09** - Security Logging and Monitoring Failures
- **A10** - Server-Side Request Forgery (SSRF)

## Prerequisites

### Required Tools
- **Web browser** with DevTools (F12)
- **curl** for HTTP requests
- **Base64 decoders** (online or command line)
- **VPN access** to Cyber - WebSec 0x01 test environment

### Prior Knowledge
- Basic web security concepts
- Browser DevTools usage
- Cryptography basics (encoding/decoding)
- Understanding of web cookies and sessions

## Testing Methodology

### Systematic Approach

1. **Reconnaissance**: Analyze target application
2. **Identification**: Detect potential vulnerabilities
3. **Exploitation**: Test flaws in authorized framework
4. **Documentation**: Record results and methods
5. **Mitigation**: Propose corrective measures

### Test Environment

- **Target Machine**: Cyber - WebSec 0x01
- **Base URLs**: `http://web0x01.hbtn/`
- **Context**: Controlled laboratory environment
- **Authorization**: Educational framework with explicit permissions

## Responsible Use

### ⚠️ Security Warning

**IMPORTANT**: This project is intended exclusively for defensive cybersecurity training.

#### Authorized Use ✅
- School laboratory environments
- Your own applications and systems
- Bug bounty programs with written authorization
- Academic research with appropriate supervision

#### Prohibited Use ❌
- Third-party systems without explicit permission
- Malicious or destructive activities
- Bypassing unauthorized security measures
- Non-responsible vulnerability disclosure

### Cybersecurity Code of Ethics

1. **Responsibility**: Use knowledge to protect and defend
2. **Integrity**: Report vulnerabilities responsibly
3. **Respect**: Never cause damage to systems or data
4. **Confidentiality**: Protect sensitive information discovered

## Validation and Testing

### Validation Process

1. **Study** technical documentation (`project_documentation.md`)
2. **Reproduce** exploitations in test environment
3. **Analyze** obtained results (flags and output files)
4. **Understand** mechanisms of each vulnerability
5. **Implement** recommended protection measures

### Success Criteria

- ✅ Obtaining the 4 main flags
- ✅ Correct identification of XSS vulnerable field
- ✅ Understanding exploitation mechanisms
- ✅ Proposing appropriate protection measures

## Recommended Protection Measures

### Protection Against Broken Access Control
```javascript
// Secure session identifier generation
const sessionId = crypto.randomBytes(32).toString('hex');
```

### Protection Against Cryptographic Failures
```javascript
// Proper encryption of sensitive data
const bcrypt = require('bcrypt');
const hashedPassword = await bcrypt.hash(password, 12);
```

### Protection Against Injection (XSS)
```javascript
// Proper escaping of user inputs
const sanitizedInput = DOMPurify.sanitize(userInput);
```

## Additional Resources

### Official Documentation
- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)

### Recommended Tools
- [Burp Suite](https://portswigger.net/burp) - Web interception proxy
- [OWASP ZAP](https://www.zaproxy.org/) - Web security scanner
- [Nuclei](https://nuclei.projectdiscovery.io/) - Vulnerability scanner

### Continuing Education
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [SANS Web Application Security](https://www.sans.org/courses/web-app-security/)
- [Bug Bounty Platforms](https://www.bugcrowd.com/) for ethical practice

---

**Repository**: holbertonschool-cyber_security  
**Series**: Web Application Security  
**Level**: Intermediate  
**Author**: Holberton School Cybersecurity Training  
**Version**: 1.0  
**Last Updated**: 2024