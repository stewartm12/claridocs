---
allowed-tools: Bash(bundle:*), Bash(rake:*), Bash(rails:*), Bash(find:*), Bash(grep:*), Bash(wc:*), Bash(ruby:*),  Bash(rails --version)
description: Comprehensive test coverage review for Ruby on Rails applications | Run weekly
---

## Context

- Current branch: !`git branch --show-current`
- Rails version: !`rails --version`
- Test framework: !`grep -E "(rspec|minitest)" Gemfile | head -5`
- Coverage tools: !`grep -E "(simplecov|coverband)" Gemfile | head -3`
- Recent test changes: !`git diff HEAD~5 --name-only | grep -E "(spec|test)" | head -10`

## Test Environment Setup

- Bundle status: !`bundle check`
- Database status: !`rails db:version 2>/dev/null || echo "Database needs setup"`
- Test database: !`RAILS_ENV=test rails db:version 2>/dev/null || echo "Test DB needs setup"`

## Coverage Analysis

### Current Coverage Stats
- Run coverage: !`RAILS_ENV=test bundle exec rake test:coverage 2>/dev/null || bundle exec rspec --format progress 2>/dev/null || echo "Run: RAILS_ENV=test bundle exec rake test:coverage"`
- Coverage files: !`find . -name "coverage" -type d 2>/dev/null || echo "No coverage directory found"`
- Recent coverage: !`find ./coverage -name "*.html" -mtime -1 2>/dev/null | head -5`

### Test File Statistics
- Total spec/test files: !`find . -path "./vendor" -prune -o -name "*_spec.rb" -o -name "*_test.rb" | grep -v vendor | wc -l`
- Model tests: !`find . -path "./spec/models" -name "*_spec.rb" 2>/dev/null | wc -l || find . -path "./test/models" -name "*_test.rb" 2>/dev/null | wc -l`
- Controller tests: !`find . -path "./spec/controllers" -name "*_spec.rb" 2>/dev/null | wc -l || find . -path "./test/controllers" -name "*_test.rb" 2>/dev/null | wc -l`
- Request/Integration tests: !`find . -path "./spec/requests" -name "*_spec.rb" 2>/dev/null | wc -l || find . -path "./test/integration" -name "*_test.rb" 2>/dev/null | wc -l`
- Feature/System tests: !`find . -path "./spec/features" -name "*_spec.rb" -o -path "./spec/system" -name "*_spec.rb" 2>/dev/null | wc -l`

### Model Coverage Analysis
- Models without tests: !`find ./app/models -name "*.rb" -exec basename {} .rb \; | sort > /tmp/models.txt && find . -name "*_spec.rb" -o -name "*_test.rb" | grep -E "(model|unit)" | sed 's/.*\///; s/_spec\.rb//; s/_test\.rb//' | sort > /tmp/tested_models.txt && comm -23 /tmp/models.txt /tmp/tested_models.txt 2>/dev/null | head -10`

### Controller Coverage Analysis  
- Controllers: !`find ./app/controllers -name "*_controller.rb" | wc -l`
- Controller tests: !`find . -name "*controller*" -path "*/spec/*" -o -name "*controller*" -path "*/test/*" | wc -l`

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

Perform a comprehensive test coverage analysis focusing on:

### 1. **Overall Coverage Assessment**
- **Coverage percentage**: What's the current line/branch coverage?
- **Trend analysis**: Is coverage improving or declining?
- **Coverage distribution**: Which areas have good/poor coverage?
- **Critical paths**: Are the most important code paths tested?

### 2. **Test Quality Analysis**
- **Test types balance**: Right mix of unit/integration/system tests?
- **Test isolation**: Are tests independent and not coupled?
- **Test speed**: Are tests running efficiently?
- **Flaky tests**: Are there unstable/intermittent failures?
- **Test data**: Are fixtures/factories well-organized?

### 3. **Rails-Specific Coverage**
- **Models**: Are validations, associations, scopes tested?
- **Controllers**: Are all actions and edge cases covered?
- **Routes**: Are all routes tested through request specs?
- **Views**: Are view components and helpers tested?
- **Background jobs**: Are ActiveJob classes tested?
- **Mailers**: Are ActionMailer classes covered?

### 4. **Critical Gap Analysis**
- **Untested models**: Which models lack adequate tests?
- **Controller gaps**: Which controller actions aren't tested?
- **Edge cases**: What error conditions aren't covered?
- **Authentication/Authorization**: Are security layers tested?
- **API endpoints**: Are all API responses tested?

### 5. **Test Infrastructure**
- **Test setup**: Is test environment properly configured?
- **Database cleanup**: Are tests cleaning up properly?
- **External dependencies**: Are external services mocked appropriately?
- **Test helpers**: Are shared test utilities effective?

### 6. **Coverage Tools Assessment**
- **SimpleCov/Coverband**: Is coverage reporting accurate?
- **CI integration**: Is coverage tracked in CI/CD?
- **Coverage thresholds**: Are minimum coverage requirements set?
- **Exclusions**: Are coverage exclusions justified?

## Analysis Format

### 📊 **Coverage Dashboard**
- **Overall Coverage**: X% lines, Y% branches
- **Trend**: Increasing/Decreasing/Stable
- **Quality Score**: 1-5 stars based on coverage + quality

### 🎯 **Coverage by Component**
```
Models:      XX% (X/Y files covered)
Controllers: XX% (X/Y actions covered)  
Views:       XX% (X/Y templates covered)
Jobs:        XX% (X/Y jobs covered)
Mailers:     XX% (X/Y mailers covered)
APIs:        XX% (X/Y endpoints covered)
```

### ⚠️ **Critical Coverage Gaps**
- **Untested Models**: [List models without tests]
- **Controller Actions**: [List untested controller actions]
- **Critical Paths**: [Important user flows without tests]

### 🧪 **Test Quality Issues**
- **Slow tests**: [Tests taking >5 seconds]
- **Flaky tests**: [Intermittent failures]
- **Coupling issues**: [Tests dependent on others]

### 💡 **Improvement Recommendations**

#### High Priority
- [Critical missing tests that should be added]
- [Coverage gaps in core business logic]

#### Medium Priority  
- [Test quality improvements]
- [Refactoring opportunities]

#### Low Priority
- [Nice-to-have test additions]
- [Infrastructure improvements]

### 🚀 **Action Plan**
1. **Immediate**: [Must-fix coverage gaps]
2. **This Sprint**: [Quick wins and important additions]  
3. **Next Quarter**: [Major test infrastructure improvements]

### 📈 **Coverage Goals**
- **Target Coverage**: Recommend overall % target
- **Per-Component Targets**: Specific goals for models/controllers/etc
- **Timeline**: Realistic timeframe to reach targets

---

**Rails 8 + RSpec + PostgreSQL Testing Checklist:**
- [ ] Models test validations, associations, scopes with shoulda-matchers
- [ ] Request specs test all endpoints with proper HTTP status codes  
- [ ] System specs cover critical user journeys (consider adding capybara if needed)
- [ ] Solid Queue jobs are tested with proper job specs
- [ ] Solid Cache caching strategies are tested
- [ ] Database constraints and PostgreSQL features are tested
- [ ] External HTTP calls are mocked with WebMock
- [ ] FactoryBot factories are used consistently with proper traits
- [ ] Database cleaner properly manages test database state
- [ ] SimpleCov provides adequate coverage reporting
- [ ] Rails 8 authentication with bcrypt is tested
- [ ] Turbo and Stimulus components are tested (if using system specs)

---

## Output Instructions

**Save this review as a browser-viewable Markdown file:**
- Create the file in `./reviews/test_coverage_reviews` directory
- Use filename format: `[current-branch]_YYYY-MM-DD.md`
- Make sure to use proper Markdown formatting (headings, lists, code blocks, etc.) so it displays correctly in the browser.
- Ensure that code blocks include an extra blank line above and below the opening and closing triple backticks for consistent spacing.
- Examples: 
  - `setup-claude-2024-12-19.md`
  - `main-2024-12-19.md` 
