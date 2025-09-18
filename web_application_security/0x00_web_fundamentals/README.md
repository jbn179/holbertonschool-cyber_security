# Web Application Security - Web Fundamentals

## Overview

This project covers fundamental concepts of web application security and common vulnerabilities. It provides a practical introduction to defensive exploitation techniques for understanding and protecting modern web applications.

## Learning Objectives

By the end of this project, you should be able to:

- Understand client-server architecture and web protocols
- Identify common web application vulnerabilities
- Use ethical penetration testing techniques
- Implement appropriate defensive security measures
- Analyze and exploit security flaws in a controlled environment

## Project Structure

### Scripts and Tools

#### `1-host_header_injection.sh`
**Purpose**: Script to test Host header injection vulnerabilities
**Usage**: `./1-host_header_injection.sh <malicious_host> <target_url> <post_data>`
**Description**: Tests if a web application is vulnerable to Host header injection attacks, often used for cache poisoning or malicious redirections.

### Payloads and Exploitation

#### `3-xss_payload.txt`
**Purpose**: Cross-Site Scripting (XSS) payload for testing
**Usage**: Content used to test XSS vulnerabilities
**Security**: Use only on your own applications or in authorized test environments

#### `7-rce_payload.txt`
**Purpose**: Remote Code Execution (RCE) payload for testing
**Usage**: Payload to identify remote code execution vulnerabilities
**⚠️ Warning**: Use strictly limited to authorized test environments

### Results and Flags

The project contains several flag files obtained during practical exercises:

- `2-flag.txt` - Flag obtained during exploitation challenge 2
- `4-flag.txt` - Flag obtained during exploitation challenge 4  
- `6-flag.txt` - Flag obtained during exploitation challenge 6
- `8-flag.txt` - Flag obtained during exploitation challenge 8

### Support Ticket

#### `5-ticket.txt`
**Purpose**: Simulation of a support ticket or security incident
**Content**: Information related to a discovered security incident

## Additional Documentation

This project builds upon several comprehensive guides available in the directory:

### `web_fundamentals_guide.md`
Comprehensive guide with 630+ lines covering:
- Client-server architecture and web protocols
- Web evolution (1.0, 2.0, 3.0)
- Progressive Web Applications (PWA)
- Front-end/back-end communication
- Stateful vs stateless architectures
- OWASP Top 10 security risks
- Bug Bounty programs and ethical methodology

### `exploitations_doc.md`
Documentation of exploitation techniques used in practical exercises.

### `quiz_web_fundamentals.md`
Questions and answers to validate understanding of covered concepts.

## Prerequisites

### Required Tools
- `curl` - for HTTP requests
- Web browser with DevTools
- Access to a secure test environment

### Prior Knowledge
- Basics of HTTP/HTTPS protocols
- Web programming concepts (HTML, JavaScript)
- Basic cybersecurity concepts

## Responsible Use

### ⚠️ Security Warning

**IMPORTANT**: This project is intended exclusively for educational purposes and defensive cybersecurity training.

- ✅ **Authorized**: Use on your own systems
- ✅ **Authorized**: Laboratory and test environments
- ✅ **Authorized**: Bug bounty programs with explicit authorization
- ❌ **Prohibited**: Third-party systems without written authorization
- ❌ **Prohibited**: Malicious or illegal activities

### Code of Ethics

1. **Responsible Disclosure**: Report vulnerabilities to system owners
2. **Scope Respect**: Stay within authorized boundaries
3. **No User Impact**: Avoid damage or disruption
4. **Confidentiality**: Protect sensitive data discovered

## Testing and Validation

To validate your understanding:

1. **Study** theoretical documentation (`web_fundamentals_guide.md`)
2. **Practice** with scripts in a test environment
3. **Analyze** obtained results (flags)
4. **Complete** the validation quiz

## Recommended Protection Measures

Based on vulnerabilities studied, implement:

### Against Host Header Injection
- Strict validation of Host headers
- Proper web server configuration
- Use whitelists for authorized domains

### Against XSS
- Proper escaping of user inputs
- Content Security Policy (CSP)
- Data validation and sanitization

### Against RCE
- Principle of least privilege
- Strict input validation
- Process sandboxing

## Additional Resources

- [OWASP Top 10](https://owasp.org/Top10/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [Bug Bounty Platforms](https://www.bugcrowd.com/resources/getting-started/)

---

**Repository**: holbertonschool-cyber_security  
**Author**: Holberton School Cybersecurity Training  
**Version**: 1.0  
**Last Updated**: 2024