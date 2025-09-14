---
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(find:*), Bash(grep:*), Bash(wc:*)
description: Comprehensive Rails code review following Sandi Metz principles and best practices | Run for every PR
---

## Context Analysis

### Repository State
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`
- Changed files: !`git diff --name-only HEAD~1`
- Files by type: !`git diff --name-only HEAD~1 | grep -E '\.(rb|erb|haml|slim)$' | sort`
- Migration files: !`git diff --name-only HEAD~1 | grep -E 'db/migrate' | head -5`

### Rails Environment
- Rails version: !`rails --version`
- Ruby version: !`ruby --version`
- Gemfile changes: !`git diff HEAD~1 -- Gemfile Gemfile.lock | head -20`

### Code Changes Overview
- Ruby files changed: !`git diff --name-only HEAD~1 | grep '\.rb$' | wc -l`
- View files changed: !`git diff --name-only HEAD~1 | grep -E '\.(erb|haml|slim)$' | wc -l`
- Lines added/removed: !`git diff --stat HEAD~1`
- Recent code diff: !`git diff HEAD~1 --stat --summary`

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

Perform a comprehensive Rails code review following **Sandi Metz principles** and Rails best practices. Focus on object-oriented design, maintainability, and Rails conventions.

### Core Review Areas

#### 1. **Sandi Metz Rules Compliance**
- **Classes**: No longer than 100 lines
- **Methods**: No longer than 5 lines
- **Parameters**: No more than 4 parameters
- **Instance variables**: No more than 4 per controller action
- **Lines**: No more than 80 characters per line

#### 2. **Object-Oriented Design**
- **Single Responsibility**: Each class/method has one reason to change
- **Tell, Don't Ask**: Objects handle their own data and behavior
- **Law of Demeter**: Avoid chaining method calls
- **Composition over Inheritance**: Prefer composition and modules
- **Dependency Injection**: Avoid hard-coded dependencies

#### 3. **Rails-Specific Patterns**
- **Fat Models, Skinny Controllers**: Business logic in models, not controllers
- **RESTful Design**: Proper use of Rails REST conventions
- **ActiveRecord Best Practices**: Efficient queries, proper associations
- **Strong Parameters**: Proper parameter filtering and security
- **Service Objects**: Complex business logic extracted to services

#### 4. **Rails 8 + PostgreSQL + RSpec Quality**
- **ActiveRecord Efficiency**: N+1 queries, proper includes/joins
- **PostgreSQL Features**: Appropriate use of JSONB, arrays, indexes
- **Solid Queue Jobs**: Proper background job patterns
- **Solid Cache**: Efficient caching strategies
- **RSpec Testing**: Well-structured, readable tests
- **FactoryBot Usage**: Clean, maintainable test factories

#### 5. **Security & Performance**
- **Rails Security**: CSRF, mass assignment, SQL injection prevention
- **Authentication**: Secure bcrypt implementation
- **Authorization**: Proper access control patterns
- **Performance**: Database queries, caching, memory usage
- **Error Handling**: Graceful failure and proper logging

#### 6. **Code Style & Maintainability**
- **Naming**: Clear, intention-revealing names
- **Comments**: Code explains why, not what
- **Duplication**: DRY principle application
- **Complexity**: Cyclomatic complexity kept low
- **Refactoring**: Code smells identification

## Review Output Format

### 🌟 **What's Working Well**
*Highlight positive aspects of the code changes*

- **Good Practices**: [List well-implemented patterns]
- **Clean Code**: [Examples of readable, maintainable code]
- **Rails Conventions**: [Proper use of Rails patterns]
- **Testing**: [Well-written specs and good coverage]
- **Performance**: [Efficient implementations]

### 🚨 **Critical Issues** *(Must Fix Before Merge)*
*Issues that could cause bugs, security vulnerabilities, or major performance problems*

#### Issue #1: [Title]
- **Location**: `app/models/user.rb:25-30`
- **Problem**: [Detailed description of the issue]
- **Impact**: [Why this is critical - security/performance/reliability]
- **Solution**: [Specific fix with code example]
- **Sandi Metz Violation**: [If applicable - which rule is broken]

#### Issue #2: [Title]
- **Location**: [File:line]
- **Problem**: [Description]
- **Impact**: [Impact assessment]
- **Solution**: [Recommended fix]

### ⚠️ **Medium Priority Issues** *(Should Fix This Sprint)*
*Issues that affect maintainability, readability, or minor performance*

#### Issue #1: [Title]
- **Location**: [File:line]
- **Problem**: [Description]
- **Rails Pattern**: [Which Rails convention is not followed]
- **Refactoring**: [How to improve following Sandi Metz principles]

### 📝 **Minor Issues** *(Nice to Have / Future Improvement)*
*Style issues, minor optimizations, or suggestions for better practices*

- **Style Improvements**: [List of style suggestions]
- **Potential Optimizations**: [Minor performance improvements]
- **Code Organization**: [Suggestions for better structure]

### 🔄 **Refactoring Opportunities**
*Code that works but could be improved following OOD principles*

#### Extract Service Object
- **Current**: [Description of current implementation]
- **Suggested**: [Service object pattern implementation]
- **Benefit**: [Why this improves the code]

#### Composition over Inheritance
- **Current**: [Current inheritance usage]
- **Suggested**: [Module/composition approach]
- **Benefit**: [Flexibility and maintainability gains]

### 🧪 **Testing Assessment**
- **Coverage**: [Assessment of test coverage for changes]
- **Quality**: [Test readability and maintainability]
- **Missing Tests**: [What test scenarios are missing]
- **RSpec Patterns**: [Proper use of RSpec best practices]

### 📊 **Metrics Summary**

#### Sandi Metz Rules Compliance
- **Classes > 100 lines**: [Count and list]
- **Methods > 5 lines**: [Count and examples]
- **4+ parameters**: [Methods that exceed parameter limit]
- **4+ instance variables**: [Controller actions with too many ivars]
- **Lines > 80 chars**: [Count of long lines]

#### Rails Health Indicators
- **Controller Complexity**: [Assessment of controller actions]
- **Model Responsibilities**: [Single responsibility adherence]
- **Query Efficiency**: [N+1 issues, missing includes]
- **Security Patterns**: [Strong params, authorization]

### 🎯 **Immediate Action Plan**

#### Today (Critical Fixes)
1. **[Priority 1]**: [Specific action with file/line]
2. **[Priority 2]**: [Specific action]
3. **[Priority 3]**: [Specific action]

#### This Week (Medium Priority)
1. **Refactor**: [Specific refactoring task]
2. **Extract**: [Service objects or modules to create]
3. **Test**: [Missing test coverage to add]

#### Next Sprint (Improvements)
1. **Optimize**: [Performance improvements]
2. **Enhance**: [Code quality improvements]
3. **Document**: [Documentation needs]

### 🛠️ **Recommended Tools & Patterns**

#### For Current Issues
- **RuboCop Rules**: [Specific cops to enable/configure]
- **Reek Smells**: [Code smells to watch for]
- **Rails Best Practices**: [Specific patterns to implement]

#### For Future Development
- **Service Objects**: [When and how to use them]
- **Form Objects**: [For complex form handling]
- **Decorators**: [For view logic organization]
- **Policy Objects**: [For authorization logic]

### 📚 **Learning Resources**
- **Sandi Metz**: [Specific talks/books relevant to issues found]
- **Rails Guides**: [Relevant guides for patterns used]
- **Refactoring**: [Specific refactoring techniques to study]

---

## Code Review Summary

### Overall Assessment: ⭐⭐⭐⭐⭐ (1-5 stars)

### Key Metrics
- **Maintainability**: [High/Medium/Low]
- **Rails Conventions**: [Excellent/Good/Needs Work]
- **OOD Principles**: [Strong/Adequate/Weak]
- **Security**: [Secure/Minor Issues/Major Concerns]
- **Performance**: [Optimized/Good/Needs Improvement]

### Recommendation
- [ ] **Approve**: Ready to merge
- [ ] **Approve with Minor Changes**: Fix small issues then merge
- [ ] **Request Changes**: Address medium/critical issues before merge
- [ ] **Major Refactoring Needed**: Significant changes required

---

## Output Instructions

**Save this review as a browser-viewable Markdown file:**
- Create the file in `./reviews/code_reviews` directory
- Use filename format: `[current-branch]_YYYY-MM-DD.md`
- Make sure to use proper Markdown formatting (headings, lists, code blocks, etc.) so it displays correctly in the browser.
- Ensure that code blocks include an extra blank line above and below the opening and closing triple backticks for consistent spacing.
- Examples: 
  - `setup-claude-2024-12-19.md`
  - `main-2024-12-19.md` 
