---
allowed-tools: Bash(bundle:*), Bash(rails:*), Bash(rake:*), Bash(find:*), Bash(grep:*), Bash(ps:*), Bash(free:*)
description: Comprehensive performance review for Ruby on Rails applications | Run for every release
---

## Context

- Rails version: !`rails --version`
- Ruby version: !`ruby --version`
- Current branch: !`git branch --show-current`
- Environment: !`echo $RAILS_ENV || echo "development"`
- Recent performance changes: !`git log --oneline -10 --grep="performance\|optimize\|slow\|cache\|index"`

## Performance Monitoring Setup

- Performance gems: !`grep -iE "(bullet|rack-mini-profiler|newrelic|skylight|scout|memory_profiler)" Gemfile`
- Database gems: !`grep -E "(pg|mysql|sqlite)" Gemfile`
- Caching setup: !`grep -rE "cache_store|redis|memcache" config/ | head -3`
- Background jobs: !`grep -E "(sidekiq|resque|delayed_job|good_job)" Gemfile`

## Database Performance Analysis

### Database Configuration
- Database config: !`grep -A10 -B2 "production:\|development:" config/database.yml 2>/dev/null | head -15`
- Connection pooling: !`grep -E "pool|timeout" config/database.yml`
- Database size: !`rails db:version 2>/dev/null && echo "DB accessible" || echo "Check DB connection"`

### Query Analysis
- N+1 detection: !`grep -r "bullet" config/ || echo "Consider adding bullet gem for N+1 detection"`
- Slow query logs: !`find ./log -name "*sql*" 2>/dev/null | head -3`
- Missing indexes: !`find . -name "*schema.rb" -exec grep -c "add_index" {} \; 2>/dev/null`

### Model Performance Patterns
- Eager loading: !`grep -r "includes\|joins\|preload" app/models/ app/controllers/ | wc -l`
- Scopes usage: !`grep -r "scope :" app/models/ | wc -l`
- Callbacks: !`grep -rE "(before_|after_|around_)" app/models/ | wc -l`

## Application Performance Analysis  

### Controller Performance
- Controller actions: !`find app/controllers -name "*.rb" -exec grep -l "def " {} \; | wc -l`
- Heavy controllers: !`find app/controllers -name "*.rb" -exec wc -l {} \; | sort -nr | head -5`
- Caching usage: !`grep -r "cache\|expire" app/controllers/ | head -5`

### View Performance
- View count: !`find app/views -name "*.erb" -o -name "*.haml" -o -name "*.slim" | wc -l`
- Partials usage: !`find app/views -name "_*.erb" | wc -l`
- Helper usage: !`find app/helpers -name "*.rb" | wc -l`

### Asset Performance
- Asset pipeline: !`ls -la app/assets/`
- JavaScript files: !`find app/assets/javascripts app/javascript -name "*.js" -o -name "*.coffee" -o -name "*.ts" 2>/dev/null | wc -l`
- CSS files: !`find app/assets/stylesheets -name "*.css" -o -name "*.scss" -o -name "*.sass" 2>/dev/null | wc -l`
- Images: !`find app/assets/images -type f 2>/dev/null | wc -l`

## System Performance

### Memory Analysis
- System memory: !`free -h 2>/dev/null || echo "Memory info not available"`
- Ruby processes: !`ps aux | grep ruby | head -5`

### Background Jobs
- Job classes: !`find app/jobs -name "*.rb" 2>/dev/null | wc -l`
- Queue configuration: !`grep -r "queue_as\|perform_later" app/ | head -5`

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

Perform a comprehensive performance analysis focusing on:

### 1. **Database Performance**
- **Query optimization**: Identify slow queries and N+1 problems
- **Indexing strategy**: Missing indexes on frequently queried columns
- **Connection pooling**: Proper database connection management
- **Query patterns**: Efficient use of ActiveRecord methods
- **Database design**: Normalized vs denormalized trade-offs
- **Bulk operations**: Efficient batch processing methods

### 2. **Application Layer Performance**  
- **Controller efficiency**: Action response times and complexity
- **Model optimization**: Efficient ActiveRecord usage
- **View rendering**: Template rendering performance
- **Memory usage**: Memory leaks and excessive allocations
- **CPU utilization**: Processor-intensive operations
- **Algorithmic complexity**: Big-O analysis of critical paths

### 3. **Caching Strategy**
- **Page caching**: Full page cache opportunities
- **Action caching**: Controller action caching
- **Fragment caching**: View fragment optimization
- **Object caching**: Model and data caching
- **Query caching**: Database query result caching
- **Cache invalidation**: Proper cache expiration strategies

### 4. **Asset Performance**
- **Asset pipeline**: Minification and compression
- **Image optimization**: File sizes and formats
- **JavaScript performance**: Bundle size and execution speed
- **CSS optimization**: Stylesheet efficiency
- **CDN usage**: Content delivery network implementation
- **Browser caching**: HTTP caching headers

### 5. **Background Processing**
- **Job queues**: Efficient background job processing
- **Queue management**: Proper job prioritization
- **Resource usage**: Background job resource consumption
- **Error handling**: Failed job retry strategies
- **Monitoring**: Job processing visibility
- **Scaling**: Background job scaling strategies

### 6. **Infrastructure Performance**
- **Server configuration**: Web server optimization
- **Load balancing**: Traffic distribution efficiency  
- **SSL/TLS performance**: HTTPS overhead optimization
- **Database server**: DB server performance tuning
- **Monitoring**: Application performance monitoring
- **Scaling**: Horizontal and vertical scaling strategies

### 7. **Rails-Specific Optimizations**
- **Eager loading**: Proper use of includes/joins/preload
- **Counter caches**: Efficient count operations
- **STI vs Polymorphic**: Inheritance pattern performance
- **Serialization**: Efficient object serialization
- **Middleware**: Custom middleware performance impact
- **Configuration**: Rails configuration optimizations

## Performance Review Format

### ⚡ **Performance Summary**
- **Overall Rating**: ⭐⭐⭐⭐⭐ (1-5 stars)
- **Response Time**: Average XX ms
- **Throughput**: X requests/second
- **Memory Usage**: XXX MB average
- **Major Bottlenecks**: [Top 3 performance issues]

### 📊 **Performance Metrics**

#### Database Performance
- **Query Count**: Average X queries per request
- **Query Time**: Average XX ms per query  
- **Slow Queries**: X queries >100ms
- **N+1 Queries**: X detected instances
- **Index Usage**: XX% of queries use indexes

#### Application Performance  
- **Response Times**: 
  - P50: XX ms
  - P95: XX ms  
  - P99: XX ms
- **Memory Usage**: XX MB per request
- **CPU Usage**: XX% average load
- **Error Rate**: X.X% of requests

#### Rails 8 Asset Optimization
- **Propshaft Performance**: [Asset delivery efficiency analysis]
- **ImportMap Optimization**: [JavaScript module loading performance]
- **TailwindCSS Optimization**: [CSS bundle size and purging effectiveness]
- **Turbo Performance**: [SPA navigation speed and cache utilization]
- **Stimulus Efficiency**: [JavaScript controller performance]

#### Solid Cache Performance
- **Cache Hit Rates**: [solid_cache effectiveness metrics]
- **Cache Storage**: [Database-backed cache performance]
- **Cache Invalidation**: [Cache expiration strategy efficiency]

### 🚨 **Critical Performance Issues**

#### High Impact (Fix Immediately)
1. **[Issue Title]**
   - **Impact**: [Performance impact description]
   - **Location**: [File/method references]
   - **Fix**: [Specific optimization steps]
   - **Expected Improvement**: [Quantified improvement]

#### Medium Impact (Fix This Sprint)
- [List of medium priority performance issues]

#### Low Impact (Future Optimization)
- [List of minor performance improvements]

### 🔍 **Detailed Analysis**

#### Database Optimization Opportunities
- **Missing Indexes**: [List columns that need indexes]
- **Query Optimization**: [Specific slow queries to optimize]
- **N+1 Problems**: [Controllers/actions with N+1 issues]
- **Unused Indexes**: [Indexes that can be removed]

#### Application Code Optimizations
- **Controller Improvements**: [Specific controller optimizations]
- **Model Optimizations**: [ActiveRecord usage improvements]
- **View Optimizations**: [Template rendering improvements]
- **Algorithm Improvements**: [Algorithmic complexity reductions]

#### Caching Opportunities
- **Fragment Caching**: [Views that would benefit from caching]
- **Object Caching**: [Expensive computations to cache]
- **Query Caching**: [Frequently accessed data to cache]
- **Page Caching**: [Static/semi-static pages to cache]

### 📈 **Performance Recommendations**

#### Quick Wins (1-2 days)
1. **Add Database Indexes**: [Specific indexes to add]
2. **Enable Query Caching**: [Controllers to add caching]
3. **Optimize N+1 Queries**: [Add includes/joins where needed]

#### Medium Effort (1-2 weeks)
1. **Implement Fragment Caching**: [Views to cache]
2. **Optimize Background Jobs**: [Job performance improvements]
3. **Asset Optimization**: [Bundle size reductions]

#### Long Term (1-2 months)
1. **Database Sharding**: [If needed for scale]
2. **Microservice Split**: [If monolith is too large]
3. **CDN Implementation**: [For static assets]

### 🛠️ **Performance Tools Recommendations**

#### Monitoring (Currently Missing)
- **APM**: NewRelic, Skylight, or Scout APM
- **Database**: pgHero for PostgreSQL insights
- **Profiling**: rack-mini-profiler for development
- **N+1 Detection**: bullet gem

#### Optimization Tools
- **PostgreSQL Analysis**: pg_stat_statements, pgHero, or pgbadger
- **Query Performance**: EXPLAIN (ANALYZE, BUFFERS) for slow queries
- **Memory Profiling**: memory_profiler gem for Rails apps
- **Load Testing**: Apache Bench, wrk, or artillery for performance testing
- **Asset Analysis**: webpack-bundle-analyzer or similar tools

### 🎯 **Performance Goals**

#### Target Metrics (Next Quarter)
- **Response Time**: <200ms for 95% of requests
- **Database**: <50ms average query time
- **Memory**: <500MB per process
- **Throughput**: 100+ requests/second
- **Error Rate**: <0.1%

#### Monitoring Thresholds
- **Alert**: Response time >500ms
- **Warning**: Memory usage >800MB
- **Critical**: Error rate >1%

---

**Performance Review Action Items:**
- [ ] Set up performance monitoring
- [ ] Add missing database indexes  
- [ ] Implement caching where beneficial
- [ ] Optimize identified N+1 queries
- [ ] Review and optimize background jobs
- [ ] Implement asset optimization
- [ ] Set up performance alerting

---

## Output Instructions

**Save this review as a browser-viewable Markdown file:**
- Create the file in `./reviews/performance_reviews` directory
- Use filename format: `[current-branch]_YYYY-MM-DD.md`
- Make sure to use proper Markdown formatting (headings, lists, code blocks, etc.) so it displays correctly in the browser.
- Ensure that code blocks include an extra blank line above and below the opening and closing triple backticks for consistent spacing.
- Examples: 
  - `setup-claude-2024-12-19.md`
  - `main-2024-12-19.md` 
