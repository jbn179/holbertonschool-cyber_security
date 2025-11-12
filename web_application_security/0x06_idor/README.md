# Insecure Direct Object Reference - IDOR (0x06)

This project focuses on understanding and exploiting Insecure Direct Object Reference (IDOR) vulnerabilities in web applications. Students will learn to identify, exploit, and remediate IDOR weaknesses that allow unauthorized access to objects and resources through hands-on practical exercises.

## Learning Objectives

At the end of this project, you are expected to be able to explain to anyone, without the help of Google:

- What is an Insecure Direct Object Reference (IDOR)?
- How do IDOR vulnerabilities occur?
- What is the difference between horizontal and vertical privilege escalation?
- How can predictable IDs be exploited?
- What are direct object references vs. indirect object references?
- How do authorization flaws differ from authentication flaws?
- What is enumeration and how does it relate to IDOR?
- How can session management prevent IDOR attacks?
- What is the principle of least privilege?
- How do you test for IDOR vulnerabilities?
- What are common IDOR attack vectors in APIs?
- How can access control lists (ACLs) prevent IDOR?
- What is the role of server-side validation in preventing IDOR?
- Why is relying on client-side checks insufficient?

## Requirements

### General
- Allowed editors: vi, vim, emacs
- All your scripts will be tested on Kali Linux
- All your files should end with a new line
- A README.md file, at the root of the folder of the project, is mandatory
- For this project, your focus will be on the target **Cyber - WebSec 0x06**
- All HTTP interactions should be documented with request/response pairs

## Project Overview

This project consists of 4 tasks that progressively demonstrate different IDOR vulnerability scenarios in a banking application (CyberBank). Each task builds upon knowledge from previous tasks and demonstrates critical security flaws in access control mechanisms.

### Task 0: Customer Information Disclosure (IDOR-001)
**Objective**: Exploit IDOR vulnerability to access unauthorized customer information.

- **Target Endpoint**: `GET /api/customer/info/{customer_id}`
- **Vulnerability**: Missing ownership validation on customer data access
- **Challenge**: Enumerate customer IDs and retrieve sensitive personal information
- **Goal**: Access another user's customer information and retrieve FLAG_0
- **Output**: Store the flag in `0-flag.txt`

**Security Impact**:
- Exposure of personal information (names, usernames, balances)
- Privacy violation and compliance risk (GDPR, PCI-DSS)
- Potential for identity theft and social engineering

### Task 1: Account Balance Enumeration (IDOR-002)
**Objective**: Exploit IDOR to access unauthorized account details and balances.

- **Target Endpoint**: `GET /api/accounts/info/{account_id}`
- **Vulnerability**: No validation of account ownership
- **Challenge**: Access detailed financial information of other users
- **Goal**: Retrieve account numbers, routing numbers, and balances for FLAG_1
- **Output**: Store the flag in `1-flag.txt`

**Security Impact**:
- Complete financial data exposure
- Access to account and routing numbers
- Enablement of fraud and identity theft
- System-wide account enumeration capability

### Task 2: Wire Transfer Manipulation (IDOR-003)
**Objective**: Exploit critical IDOR to perform unauthorized wire transfers.

- **Target Endpoint**: `POST /api/accounts/transfer_to/{receiver_payment_id}`
- **Vulnerability**: Accepting user-controlled `account_id` without validation
- **Challenge**: Initiate transfers from other users' accounts
- **Goal**: Transfer funds from victim accounts to reach $10,000 balance for FLAG_2
- **Output**: Store the flag in `2-flag.txt`

**Security Impact**:
- **CRITICAL**: Direct financial theft capability
- Account draining potential
- Mass fraud vulnerability
- Legal liability and business destruction risk

### Task 3: 3D Secure OTP Bypass (IDOR-004)
**Objective**: Bypass 3D Secure payment authentication through IDOR exploitation.

- **Target Endpoint**: `GET /api/cards/3dsecure/{card_id}`
- **Vulnerability**: OTP exposure without card ownership validation
- **Challenge**: Retrieve OTPs for other users' cards and complete fraudulent payments
- **Goal**: Successfully complete payment with stolen OTP for FLAG_3
- **Output**: Store the flag in `3-flag.txt`

**Security Impact**:
- Complete 3D Secure authentication bypass
- Credit card fraud capability
- PCI-DSS compliance violation
- Chargeback risk and merchant account loss

## Key Concepts Covered

### Understanding IDOR Vulnerabilities

1. **Direct Object References**
   - Understanding how applications use predictable identifiers
   - Recognizing exposed internal object references (IDs, keys, filenames)
   - Differentiating between direct and indirect references

2. **Authorization vs. Authentication**
   - Authentication: Who you are (identity verification)
   - Authorization: What you can access (permission verification)
   - IDOR exploits authorization flaws, not authentication

3. **Horizontal vs. Vertical Privilege Escalation**
   - **Horizontal**: Accessing resources of users at the same privilege level
   - **Vertical**: Accessing resources of higher privilege levels (admin functions)
   - Most IDOR vulnerabilities are horizontal privilege escalation

### IDOR Attack Methodology

1. **Reconnaissance and Mapping**
   - Identify endpoints that accept object identifiers
   - Map application structure and API endpoints
   - Understand parameter naming conventions

2. **Enumeration**
   - Identify predictable patterns in object IDs
   - Test sequential, incremental, or UUID-based identifiers
   - Use tools like Burp Suite Intruder for automation

3. **Access Control Testing**
   - Intercept legitimate requests to your own resources
   - Modify object identifiers to target other users
   - Test for authorization checks on each endpoint

4. **Exploitation**
   - Demonstrate unauthorized data access
   - Chain multiple IDOR vulnerabilities for maximum impact
   - Document full attack path and business impact

### Common IDOR Patterns

**URL Parameters**:
```
GET /api/user/profile?user_id=123
GET /download/invoice/456
```

**Path Parameters**:
```
GET /api/customer/info/789
POST /api/accounts/transfer_to/012
```

**Request Body**:
```json
POST /api/transaction
{
  "account_id": "vulnerable_parameter",
  "amount": 100
}
```

**Cookies and Headers**:
```
Cookie: account_id=345; session=xyz
X-User-ID: 678
```

### Real-World IDOR Examples

1. **Facebook Profile Picture IDOR** (2013)
   - Attackers could view private profile pictures by manipulating photo IDs
   - Impact: Privacy violation for millions of users

2. **Instagram Private Photos** (2015)
   - Direct object reference allowed access to private photos
   - Impact: Exposure of private media content

3. **Banking Application Account Access**
   - Similar to this project's CyberBank scenario
   - Impact: Unauthorized access to financial data and transactions

4. **Healthcare Record Access**
   - Patient record IDs exposed in URLs
   - Impact: HIPAA violations and patient privacy breach

## Security Implications

### Business Impact
- **Financial Loss**: Direct theft through transfer manipulation
- **Regulatory Penalties**: GDPR, PCI-DSS, SOX violations
- **Reputation Damage**: Loss of customer trust
- **Legal Liability**: Lawsuits from affected customers
- **Business Closure**: Existential threat for financial institutions

### Technical Impact
- **Data Breach**: Exposure of sensitive personal and financial information
- **Privacy Violation**: Unauthorized access to customer data
- **Fraud Enablement**: Information used for identity theft
- **System Compromise**: Stepping stone for further attacks

## Tools and Technologies

- **Kali Linux**: Primary testing environment
- **Burp Suite**: HTTP proxy for intercepting and modifying requests
- **Firefox Developer Tools**: Network traffic analysis
- **curl**: Command-line HTTP client for API testing
- **Postman**: API testing and exploration
- **Python/Bash Scripts**: Automation of enumeration attacks

## Defense and Remediation

### Secure Coding Practices

1. **Implement Server-Side Authorization Checks**
```python
def get_customer_info(customer_id):
    current_user = get_authenticated_user()

    # CRITICAL: Validate ownership
    if customer_id != current_user.id:
        log_security_event("Unauthorized access attempt")
        return {"error": "Unauthorized"}, 403

    return get_customer_data(customer_id)
```

2. **Use Indirect Object References**
```python
# Instead of exposing database IDs directly
GET /api/account/12345

# Use session-based or obfuscated references
GET /api/account/my-checking
GET /api/account/session-account-1
```

3. **Implement Role-Based Access Control (RBAC)**
```python
@require_permission('view_account')
def get_account_info(account_id):
    if not user_owns_account(current_user, account_id):
        return {"error": "Forbidden"}, 403
    return account_data
```

4. **Add Access Control Lists (ACLs)**
```python
def check_resource_access(user, resource_id):
    acl = get_resource_acl(resource_id)
    if user.id not in acl.allowed_users:
        raise UnauthorizedException()
```

### Defense in Depth Strategies

1. **Input Validation**: Validate all user-supplied identifiers
2. **Rate Limiting**: Prevent rapid enumeration attacks
3. **Audit Logging**: Log all access attempts with full context
4. **Multi-Factor Authentication**: Add extra layer for sensitive operations
5. **Web Application Firewall**: Detect and block enumeration patterns
6. **Security Headers**: Implement CSP, X-Frame-Options, etc.
7. **Principle of Least Privilege**: Grant minimum necessary permissions

### Testing for IDOR

**Manual Testing Checklist**:
- [ ] Identify all endpoints accepting object identifiers
- [ ] Create multiple test accounts at same privilege level
- [ ] Attempt to access Account B's resources while logged in as Account A
- [ ] Test all HTTP methods (GET, POST, PUT, DELETE, PATCH)
- [ ] Check API endpoints separately from web interface
- [ ] Test with missing, null, or invalid IDs
- [ ] Verify authorization on every request, not just initial access

**Automated Testing**:
- Use Burp Suite Intruder to test ID ranges
- Implement automated scripts for mass enumeration
- Leverage tools like OWASP ZAP for scanning

## OWASP Top 10 Context

IDOR falls under **A01:2021 – Broken Access Control**, which moved to #1 in the OWASP Top 10 (previously A5:2017). This category includes:

- Violation of principle of least privilege
- Bypassing access control checks by modifying URLs or parameters
- Accessing API with missing access controls
- Elevation of privilege (acting as user without logging in, or as admin when logged in as user)

**CWE References**:
- CWE-639: Authorization Bypass Through User-Controlled Key
- CWE-22: Improper Limitation of a Pathname to a Restricted Directory
- CWE-352: Cross-Site Request Forgery (when combined with IDOR)

## Repository Information

- **GitHub repository**: holbertonschool-cyber_security
- **Directory**: web_application_security/0x06_idor
- **Files**:
  - `0-flag.txt`: Customer information disclosure flag
  - `1-flag.txt`: Account balance enumeration flag
  - `2-flag.txt`: Wire transfer manipulation flag
  - `3-flag.txt`: 3D Secure OTP bypass flag
  - `VULNERABILITY_REPORT.md`: Detailed security assessment report

## Additional Resources

### Reading Materials
- [OWASP Testing Guide: IDOR](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)
- [PortSwigger: Access Control Vulnerabilities](https://portswigger.net/web-security/access-control)
- [CWE-639: Authorization Bypass](https://cwe.mitre.org/data/definitions/639.html)
- [OWASP Top 10 2021: A01 Broken Access Control](https://owasp.org/Top10/A01_2021-Broken_Access_Control/)

### Video Tutorials
- OWASP IDOR Explained
- HackerOne IDOR Bug Bounty Reports
- PentesterLab IDOR Exercises

### Practice Platforms
- HackTheBox: Banking applications
- PortSwigger Web Security Academy: Access Control Labs
- OWASP WebGoat: Access Control Flaws

## Important Note

This project is designed for **educational purposes** within a **controlled environment**. The techniques demonstrated should only be used on authorized systems as part of legitimate security testing or educational activities.

**Legal Warning**: Unauthorized access to computer systems and data is illegal under laws including:
- Computer Fraud and Abuse Act (CFAA) in the United States
- Computer Misuse Act in the United Kingdom
- Similar legislation in other jurisdictions

Always obtain **explicit written permission** before testing any system you do not own. Unauthorized testing can result in criminal prosecution, fines, and imprisonment.

## Conclusion

IDOR vulnerabilities represent one of the most common and critical security flaws in modern web applications. Understanding how to identify, exploit, and remediate these vulnerabilities is essential for both offensive security professionals (penetration testers, bug bounty hunters) and defensive security teams (developers, security engineers).

This project provides hands-on experience with real-world IDOR scenarios in a banking context, demonstrating the severe business impact these vulnerabilities can have. By mastering these concepts, you will be better equipped to build and test secure applications that properly implement authorization controls.

**Key Takeaway**: Always validate authorization on the server-side for every request, never trust client-supplied identifiers, and implement defense-in-depth strategies to protect sensitive resources.
