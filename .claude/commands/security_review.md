---
allowed-tools: Bash(bundle:*), Bash(rails:*), Bash(find:*), Bash(grep:*), Bash(gem:*), Bash(brakeman:*)
description: Comprehensive security review for Ruby on Rails applications | Run monthly
---

## Context

- Rails version: !`rails --version`
- Ruby version: !`ruby --version`
- Current branch: !`git branch --show-current`
- Recent security-related changes: !`git log --oneline -10 --grep="security\|auth\|password\|session\|csrf"`
- Gemfile last modified: !`ls -la Gemfile Gemfile.lock | head -2`

## Security Tools Setup

- Brakeman installed: !`bundle show brakeman 2>/dev/null || echo "Brakeman not installed - add to Gemfile"`
- Bundler audit: !`bundle show bundler-audit 2>/dev/null || echo "bundler-audit not installed"`
- Security gems: !`grep -iE "(brakeman|bundler-audit|secure_headers)" Gemfile`

## Automated Security Scans

### Brakeman Static Analysis
- Run Brakeman: !`bundle exec brakeman --format json --output /tmp/brakeman.json 2>/dev/null && echo "Brakeman scan completed" || echo "Run: bundle exec brakeman"`
- Critical issues: !`bundle exec brakeman --format text | grep -A5 "High\|Critical" 2>/dev/null || echo "Run brakeman first"`

### Dependency Vulnerability Scan  
- Bundle audit: !`bundle audit check --update 2>/dev/null || echo "Run: bundle audit check --update"`
- Outdated gems: !`bundle outdated --only-explicit | head -10`

### Rails Security Configuration
- Rails config: !`find ./config -name "*.rb" | head -5`
- Security headers: !`grep -r "force_ssl\|secure_headers" config/ 2>/dev/null | head -5`
- CSRF protection: !`grep -r "protect_from_forgery\|csrf" app/controllers/ 2>/dev/null | head -5`

## Manual Security Assessment Areas

### Authentication & Session Management
- Authentication system: !`grep -r "devise\|has_secure_password\|authenticate" app/ config/ | head -5`
- Session config: !`grep -r "session\|cookie" config/ | head -5`
- Password policies: !`grep -r "password.*length\|password.*complexity" app/ | head -3`

### Authorization & Access Control
- Authorization gems: !`grep -E "(cancancan|pundit|rolify)" Gemfile`
- Admin interfaces: !`find . -name "*admin*" -type f | head -5`
- Role-based access: !`grep -r "role\|permission\|authorize" app/ | head -5`

### Input Validation & SQL Injection
- Strong parameters: !`grep -r "params.require\|permit" app/controllers/ | wc -l`
- Raw SQL usage: !`grep -rn "find_by_sql\|execute\|connection.select" app/ | head -5`
- User input handling: !`grep -rn "params\[" app/ | head -10`

## CRITICAL REQUIREMENTS

**FACTUAL ACCURACY ONLY**: 
- Base ALL findings and statements ONLY on actual code analysis and the provided notes file
- DO NOT make assumptions, inferences, or add information not explicitly found in the source code or notes
- If information is not available in the code or notes, explicitly state "Information not available" or omit the section
- DO NOT speculate about functionality, performance, or implementation details
- When in doubt, err on the side of omission rather than inclusion

**SOURCE-BASED ANALYSIS**:
- Every statement must be traceable to specific code files, lines, or the notes document
- Quote directly from source code when describing functionality
- Reference specific file paths and line numbers when discussing implementation details
- Use exact language from the notes file when describing test coverage status

## Your Task

Perform a comprehensive security analysis focusing on:

### 1. **Authentication Security**
- **Password security**: Strong password requirements, secure storage
- **Session management**: Secure session handling, timeout policies  
- **Multi-factor authentication**: Is MFA implemented where needed?
- **Account lockout**: Brute force protection mechanisms
- **Password reset**: Secure password recovery process
- **Remember me**: Secure persistent login implementation

### 2. **Authorization & Access Control**
- **Role-based access**: Proper role and permission systems
- **Vertical privilege escalation**: Users can't access higher privileges
- **Horizontal privilege escalation**: Users can't access others' data
- **Admin interfaces**: Admin panels properly secured
- **API access**: API endpoints have proper authorization
- **Direct object references**: Insecure direct object reference vulnerabilities

### 3. **Input Validation & Injection Attacks**
- **SQL injection**: Parameterized queries, avoid raw SQL
- **XSS prevention**: Output encoding, CSP headers
- **CSRF protection**: Anti-forgery tokens implemented
- **Command injection**: System calls properly sanitized
- **Path traversal**: File access controls in place
- **Mass assignment**: Strong parameters protecting sensitive fields

### 4. **Data Protection**
- **Sensitive data storage**: PII, passwords, tokens encrypted
- **Data transmission**: HTTPS enforced, secure cookies
- **Logging security**: No sensitive data in logs
- **Database security**: Encrypted sensitive columns
- **File upload security**: Secure file handling and storage
- **Data backup**: Secure backup and recovery processes

### 5. **Rails-Specific Security**
- **Strong parameters**: All controller actions use strong params
- **CSRF tokens**: protect_from_forgery enabled
- **SQL injection**: ActiveRecord used properly, no raw SQL
- **Mass assignment**: Sensitive attributes protected
- **Secure headers**: Security headers configured
- **Asset pipeline**: Secure asset delivery

### 6. **Infrastructure Security**
- **HTTPS enforcement**: SSL/TLS properly configured in Rails
- **PostgreSQL security**: Database server hardening and access controls
- **Security headers**: HSTS, CSP, X-Frame-Options properly set
- **Error handling**: No sensitive info in Rails error pages
- **Environment variables**: Database credentials and secrets not in code
- **Database security**: PostgreSQL user permissions and connection limits
- **Connection pooling**: Secure database connection management

### 7. **API Security** (with HTTParty)
- **Authentication**: API keys, bearer tokens properly secured
- **Rate limiting**: API abuse protection (consider adding rack-attack)
- **Input validation**: API parameters validated and sanitized
- **Output filtering**: Sensitive data not exposed in JSON responses
- **CORS configuration**: rack-cors properly configured for cross-origin requests
- **HTTParty security**: External API calls secure (HTTPS, proper headers)
- **API versioning**: Deprecated endpoints handled securely
- **Error handling**: API errors don't leak sensitive information

## Security Review Format

### 🚨 **Critical Security Issues**
- **Severity**: High/Medium/Low
- **OWASP Category**: [e.g., A01:2021 – Broken Access Control]
- **Description**: [Detailed issue description]
- **Location**: [File/line references]
- **Impact**: [Potential security impact]
- **Fix**: [Specific remediation steps]

### 🛡️ **Security Posture Assessment**

#### Authentication: ⭐⭐⭐⭐⭐
- [Assessment of authentication strength]

#### Authorization: ⭐⭐⭐⭐⭐  
- [Assessment of access control implementation]

#### Input Validation: ⭐⭐⭐⭐⭐
- [Assessment of input handling security]

#### Data Protection: ⭐⭐⭐⭐⭐
- [Assessment of data security measures]

### 🔍 **Detailed Findings**

#### High Priority Issues
1. **[Issue Title]**
   - **Risk**: [High/Medium/Low]
   - **Description**: [What the issue is]
   - **Location**: [Where it's found]
   - **Recommendation**: [How to fix]

#### Medium Priority Issues
- [List of medium priority security concerns]

#### Low Priority Issues  
- [List of minor security improvements]

### 📋 **Rails Security Checklist Status**

#### ✅ **Implemented**
- [ ] CSRF protection enabled
- [ ] Strong parameters used
- [ ] HTTPS enforced
- [ ] Secure session configuration
- [ ] Input validation in place
- [ ] SQL injection prevention
- [ ] XSS protection configured

#### ❌ **Missing/Needs Improvement**
- [ ] [List items that need attention]

### 🔒 **Security Best Practices Compliance**

#### OWASP Top 10 (2021) Assessment
1. **A01:2021 – Broken Access Control**: [Status]
2. **A02:2021 – Cryptographic Failures**: [Status]  
3. **A03:2021 – Injection**: [Status]
4. **A04:2021 – Insecure Design**: [Status]
5. **A05:2021 – Security Misconfiguration**: [Status]
6. **A06:2021 – Vulnerable Components**: [Status]
7. **A07:2021 – Identity/Authentication Failures**: [Status]
8. **A08:2021 – Software/Data Integrity Failures**: [Status]
9. **A09:2021 – Security Logging/Monitoring Failures**: [Status]
10. **A10:2021 – Server-Side Request Forgery**: [Status]

### 🚀 **Immediate Actions Required**
1. **Critical fixes** (fix immediately):
   - [List critical security issues]

2. **High priority** (fix this week):
   - [List high priority items]

3. **Security improvements** (next sprint):
   - [List medium priority improvements]

### 📊 **Security Metrics**
- **Brakeman warnings**: X critical, Y high, Z medium
- **Vulnerable dependencies**: X gems need updates
- **Security test coverage**: X% of security features tested
- **Security headers score**: [A-F grade]

### 🛠️ **Recommended Security Tools**
- **Static analysis**: Brakeman (current status)
- **Dependency scanning**: bundler-audit (current status)
- **Security headers**: secure_headers gem
- **Rate limiting**: rack-attack gem
- **Security monitoring**: Consider application monitoring

---

**Security Review Checklist:**
- [ ] Run automated security scans
- [ ] Review authentication mechanisms  
- [ ] Check authorization controls
- [ ] Validate input handling
- [ ] Assess data protection
- [ ] Review infrastructure security
- [ ] Test security controls
- [ ] Document findings and fixes

---

## Output Instructions

**Save this review as a browser-viewable Markdown file:**
- Create the file in `./reviews/security_reviews` directory
- Use filename format: `[current-branch]_YYYY-MM-DD.md`
- Make sure to use proper Markdown formatting (headings, lists, code blocks, etc.) so it displays correctly in the browser.
- Ensure that code blocks include an extra blank line above and below the opening and closing triple backticks for consistent spacing.
- Examples: 
  - `setup-claude-2024-12-19.md`
  - `main-2024-12-19.md` 
