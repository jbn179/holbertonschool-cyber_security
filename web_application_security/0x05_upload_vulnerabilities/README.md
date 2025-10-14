# Upload Vulnerabilities (0x05)

This project focuses on understanding and analyzing file upload vulnerabilities in web applications. Students will learn to identify, exploit, and defend against various file upload security weaknesses through hands-on practical exercises.

## Learning Objectives

At the end of this project, you are expected to be able to explain to anyone, without the help of Google:

- What is an unrestricted file upload?
- Why are file uploads a security risk?
- How can file upload forms be exploited?
- What is a web shell?
- How do MIME types relate to upload security?
- What is content-type spoofing?
- How can server-side validation mitigate risks?
- What is the importance of file extension filtering?
- How can client-side checks be bypassed?
- What are some secure file upload practices?
- How does file size limitation help security?
- What are the risks of storing files on the same domain?
- How do file permissions affect upload security?
- Why should upload directories not be executable?

## Requirements

### General
- Allowed editors: vi, vim, emacs
- All your scripts will be tested on Kali Linux
- All your scripts should be exactly one line long ($ wc -l file should print 1)
- All your files should end with a new line
- A README.md file, at the root of the folder of the project, is mandatory
- For this project, your focus will be on the target **Cyber - WebSec 0x05**

## Project Overview

This project consists of 5 tasks that progressively demonstrate different file upload vulnerability scenarios:

### Task 0: Subdomain Discovery
**Objective**: Identify which subdomain contains a web application with an insecure file upload feature.

- **Target Domain**: `http://web0x05.hbtn`
- **Goal**: Discover the vulnerable subdomain through systematic exploration
- **Output**: Store the discovered subdomain in `0-target.txt`

### Task 1: Client-Side Filter Bypass
**Objective**: Bypass client-side file type filtering mechanisms.

- **Target**: `http://[vuln-subdomain].web0x05.hbtn/task1`
- **Challenge**: Overcome JavaScript-based file validation
- **Goal**: Successfully upload a PHP file and retrieve FLAG_1.txt
- **Output**: Store the flag in `1-flag.txt`

### Task 2: Server-Side Validation with Special Characters
**Objective**: Bypass server-side validation using special characters in file names.

- **Target**: `http://[vuln-subdomain].web0x05.hbtn/task2`
- **Challenge**: Deceive server-side extension checks
- **Technique**: Use special characters to manipulate file name parsing
- **Goal**: Upload a PHP file and retrieve FLAG_2.txt
- **Output**: Store the flag in `2-flag.txt`

### Task 3: Magic Number Manipulation
**Objective**: Bypass content-based validation by manipulating file magic numbers.

- **Target**: `http://[vuln-subdomain].web0x05.hbtn/task3`
- **Challenge**: Create a polyglot file that passes magic number validation
- **Technique**: Craft a file with valid image headers but executable PHP content
- **Goal**: Upload the hybrid file and retrieve FLAG_3.txt
- **Output**: Store the flag in `3-flag.txt`

### Task 4: File Size Restriction Bypass
**Objective**: Bypass file size limitations through debug mode exploitation.

- **Target**: `http://[vuln-subdomain].web0x05.hbtn/task4`
- **Challenge**: Overcome minimum file size restrictions (80KB)
- **Discovery**: Identify hidden debug functionality through HTTP response analysis
- **Goal**: Upload a file bypassing size restrictions and retrieve FLAG_4.txt
- **Output**: Store the flag in `4-flag.txt`

## Key Concepts Covered

### File Upload Security Vulnerabilities

1. **Client-Side Validation Bypass**
   - Understanding JavaScript-based filtering limitations
   - HTTP request interception and modification techniques

2. **Server-Side Filter Evasion**
   - Null byte injection techniques
   - Special character exploitation in file names
   - Double extension vulnerabilities

3. **Content Validation Bypass**
   - Magic number/file signature manipulation
   - Creating polyglot files
   - MIME type spoofing

4. **Information Disclosure**
   - HTTP header analysis for hidden functionality
   - Debug mode exploitation
   - Backdoor discovery through response inspection

### Security Implications

- **Web Shell Deployment**: Understanding how malicious files can provide persistent access
- **Remote Code Execution**: Learning how uploaded files can lead to server compromise
- **Data Exfiltration**: Exploring how file uploads can be used to access sensitive information
- **Privilege Escalation**: Understanding how file upload vulnerabilities can expand attack scope

## Tools and Technologies

- **Kali Linux**: Primary testing environment
- **Web Browsers**: For manual testing and observation
- **Burp Suite**: HTTP proxy for request interception and modification
- **Command Line Tools**: For file manipulation and server communication
- **Hex Editors**: For binary file manipulation

## Security Best Practices

This project demonstrates common vulnerabilities to teach proper defensive measures:

- **Server-side validation**: Always validate file types on the server
- **File type verification**: Check magic numbers, not just extensions
- **Safe storage**: Store uploads outside web-accessible directories
- **Execution prevention**: Disable script execution in upload directories
- **Size limitations**: Implement reasonable file size restrictions
- **Input sanitization**: Properly sanitize file names and metadata
- **Content scanning**: Implement malware and content scanning
- **Access controls**: Restrict upload functionality to authenticated users

## Repository Information

- **GitHub repository**: holbertonschool-cyber_security
- **Directory**: web_application_security/0x05_upload_vulnerabilities
- **Files**: 
  - `0-target.txt`: Vulnerable subdomain
  - `1-flag.txt`: Client-side bypass flag
  - `2-flag.txt`: Server-side bypass flag  
  - `3-flag.txt`: Magic number bypass flag
  - `4-flag.txt`: Size restriction bypass flag

## Important Note

This project is designed for educational purposes within a controlled environment. The techniques demonstrated should only be used on authorized systems as part of legitimate security testing or educational activities. Unauthorized use of these techniques against systems you do not own or have explicit permission to test is illegal and unethical.