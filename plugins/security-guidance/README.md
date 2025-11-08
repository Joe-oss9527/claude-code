# Security Guidance Plugin

Proactive security warnings for common vulnerabilities in frontend and backend code. This plugin uses PreToolUse hooks to catch security issues before they're committed.

## Overview

This plugin implements a security reminder system that checks file edits for dangerous patterns and warns developers **before** the code is written. It helps prevent common security vulnerabilities in both frontend (React/JavaScript) and backend (Node.js/Python) code.

### Key Features

- 🛡️ **Proactive Prevention**: Blocks risky operations with clear warnings
- 🎯 **Smart Pattern Matching**: Detects dangerous code patterns in real-time
- 📚 **Educational**: Explains WHY patterns are dangerous and HOW to fix them
- 🔄 **Session-Scoped**: Shows each warning once per session to avoid noise
- 🎨 **Frontend-Focused**: Extensive coverage of React/JavaScript security issues
- 🔧 **Backend Coverage**: Node.js command injection, Python unsafe patterns

## How It Works

The plugin uses a **PreToolUse hook** that intercepts Edit, Write, and MultiEdit operations. When you attempt to write code containing dangerous patterns:

1. **Pattern Detection**: Scans code for security anti-patterns
2. **First-Time Warning**: Shows detailed warning on first occurrence
3. **Blocking**: Prevents tool execution (exit code 2)
4. **Session Memory**: Remembers warnings shown to avoid repetition
5. **User Override**: You can proceed after reading the warning

**Example workflow:**

```
You: "Add authentication token to localStorage"
↓
Security hook detects: localStorage.setItem
↓
Shows warning: "Don't store auth tokens in localStorage - use httpOnly cookies"
↓
Blocks operation until you acknowledge
↓
You can: Fix the code OR proceed if intentional
```

## Security Rules

### Frontend Security (8 Rules)

#### 1. unsafe_href
**Detects**: Dynamic `href` values (`href={userInput}`)

**危险性**: XSS via javascript: URLs

**Safe pattern**:
```typescript
const isValidUrl = (url: string) => {
  try {
    const parsed = new URL(url);
    return ['http:', 'https:', 'mailto:', 'tel:'].includes(parsed.protocol);
  } catch {
    return false;
  }
};
```

#### 2. unsafe_target_blank
**Detects**: `target="_blank"` without `rel="noopener noreferrer"`

**危险性**: Tabnapping attacks, performance issues

**Safe pattern**:
```typescript
<a href={url} target="_blank" rel="noopener noreferrer">
  Link
</a>
```

#### 3. localstorage_sensitive_data
**Detects**: `localStorage.setItem()`, `sessionStorage.setItem()`

**危险性**: XSS access to sensitive data, no encryption

**Never store**:
- ❌ Authentication tokens
- ❌ API keys
- ❌ Passwords
- ❌ PII data

**Safe alternatives**:
- ✅ httpOnly cookies for auth tokens
- ✅ User preferences only

#### 4. react_refs_dom_manipulation
**Detects**: `ref.current.innerHTML`, `.outerHTML =`

**危险性**: XSS via direct DOM manipulation

**Safe pattern**:
```typescript
// Use textContent
ref.current.textContent = userContent;

// Or let React handle it
<div>{userContent}</div>
```

#### 5. postmessage_origin
**Detects**: `postMessage()`, `addEventListener('message')`

**危险性**: Cross-origin message injection

**Safe pattern**:
```typescript
window.addEventListener('message', (event) => {
  const trustedOrigins = ['https://app.example.com'];

  if (!trustedOrigins.includes(event.origin)) {
    return; // Reject untrusted origins
  }

  processData(event.data);
});
```

#### 6. react_key_index
**Detects**: `key={index}`, `key={i}`

**Best Practice Warning**: Can cause state bugs and performance issues

**Safe pattern**:
```typescript
// ❌ Bad
{items.map((item, i) => <Item key={i} {...item} />)}

// ✅ Good
{items.map((item) => <Item key={item.id} {...item} />)}
```

#### 7. cors_credentials
**Detects**: `credentials: 'include'`, `withCredentials: true`

**危险性**: CSRF vulnerabilities, improper CORS configuration

**Requirements**:
1. Server must NOT use `Access-Control-Allow-Origin: *`
2. Must implement CSRF protection
3. Use HTTPS in production

#### 8. window_name_xss
**Detects**: `window.name` usage

**危险性**: Persists across navigations, can be set by any page

**Safe pattern**:
```typescript
const name = window.name;
if (typeof name === 'string' && name.length < 100) {
  const sanitized = DOMPurify.sanitize(name);
  element.textContent = sanitized;
}
```

### Frontend XSS Prevention (3 Rules)

#### 9. react_dangerously_set_html
**Detects**: `dangerouslySetInnerHTML`

**Solution**: Use DOMPurify or avoid HTML injection

#### 10. document_write_xss
**Detects**: `document.write()`

**Solution**: Use createElement() and appendChild()

#### 11. innerHTML_xss
**Detects**: `.innerHTML =`

**Solution**: Use textContent for text, or sanitize HTML

### Backend Security (6 Rules)

#### 12. github_actions_workflow
**Detects**: Editing `.github/workflows/*.yml`

**危险性**: Command injection in CI/CD

**Safe pattern**: Use environment variables, not direct interpolation

#### 13. child_process_exec
**Detects**: `exec()`, `execSync()`

**Solution**: Use `execFile()` to prevent shell injection

#### 14. new_function_injection
**Detects**: `new Function()`

**危险性**: Code injection

#### 15. eval_injection
**Detects**: `eval()`

**危险性**: Arbitrary code execution

**Solution**: Use JSON.parse() or safe alternatives

#### 16. pickle_deserialization
**Detects**: Python `pickle` usage

**危险性**: Arbitrary code execution

**Solution**: Use JSON for untrusted data

#### 17. os_system_injection
**Detects**: `os.system()` in Python

**危险性**: Command injection

**Solution**: Use subprocess with argument lists

## Installation

The plugin is already installed in this repository. To use in other projects:

```bash
cp -r plugins/security-guidance ~/.claude/plugins/
```

## Configuration

### Enable/Disable Security Reminders

Set environment variable:

```bash
# Disable all security warnings
export ENABLE_SECURITY_REMINDER=0

# Enable (default)
export ENABLE_SECURITY_REMINDER=1
```

### State Management

The plugin tracks shown warnings per session in:

```
~/.claude/security_warnings_state_{session_id}.json
```

State files older than 30 days are automatically cleaned up.

## Usage Examples

### Example 1: Preventing localStorage Token Storage

```typescript
You: "Store the JWT token in localStorage"

Security hook detects: localStorage.setItem
↓
⚠️ Security Warning: Don't store sensitive data in localStorage/sessionStorage.

Why it's dangerous:
1. Accessible to all JavaScript (including third-party scripts)
2. Vulnerable to XSS attacks
...

Never store:
- ❌ Authentication tokens (use httpOnly cookies instead)
...

For authentication tokens:
```typescript
// ❌ Bad: Store in localStorage
localStorage.setItem('authToken', token);

// ✅ Good: Use httpOnly cookies set by backend
// Server sets: Set-Cookie: authToken=xxx; HttpOnly; Secure; SameSite=Strict
```

You: "OK, I'll use httpOnly cookies instead"
```

### Example 2: Fixing target="_blank" Security

```typescript
You: "Add external link with target blank"

Security hook detects: target="_blank"
↓
⚠️ Security Best Practice: Always use rel="noopener noreferrer" with target="_blank".

Why this matters:
1. **Tabnapping Prevention**: Without rel="noopener", the new page can access window.opener
...

Safe pattern:
```typescript
<a href={url} target="_blank" rel="noopener noreferrer">
  Link text
</a>
```
```

### Example 3: React Key Warning

```typescript
You: "Map over items array using index as key"

Security hook detects: key={index}
↓
⚠️ Best Practice Warning: Using array index as React key can cause issues.

Problems with index keys:
1. **State bugs**: Component state persists incorrectly when list reorders
2. **Performance**: React can't optimize reconciliation
...

Correct approach:
```typescript
// ✅ Good: Using stable, unique identifier
{items.map((item) => (
  <TodoItem key={item.id} {...item} />
))}
```
```

## Testing the Plugin

You can test the security rules by attempting to write code with dangerous patterns:

```typescript
// Test localStorage warning
localStorage.setItem('token', 'abc123');

// Test target="_blank" warning
<a href="https://example.com" target="_blank">Link</a>

// Test index key warning
{items.map((item, i) => <div key={i}>{item.name}</div>)}

// Test dangerouslySetInnerHTML warning
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// Test postMessage warning
window.postMessage(data, '*');
```

Each pattern should trigger a warning on first occurrence.

## Design Philosophy

### 1. Educational, Not Just Blocking

Every warning includes:
- ✅ **Why** it's dangerous
- ✅ **What** the vulnerability is
- ✅ **How** to fix it securely
- ✅ Code examples (bad vs good)

### 2. Session-Scoped Warnings

- First occurrence: Full detailed warning
- Same pattern, same file: Shown once per session
- Different files: New warning (different context)
- Prevents warning fatigue while maintaining security

### 3. Graceful Degradation

- Hook failures don't break workflow
- Errors are logged but silently handled
- State file issues don't block operations

### 4. Performance Optimized

- Pattern matching is O(n) with early exits
- State files cleaned up automatically
- Minimal overhead on tool operations

## Troubleshooting

### Warnings Not Showing

**Check:**
1. `ENABLE_SECURITY_REMINDER` env var is not set to `0`
2. Hook is properly configured in `hooks/hooks.json`
3. Python 3 is available
4. Plugin is in correct directory

### Too Many Warnings

**Solution:**
- Warnings are shown once per session per file
- If you see repeated warnings, it's for different contexts
- Set `ENABLE_SECURITY_REMINDER=0` to disable temporarily

### False Positives

Some patterns are intentional. If you understand the risk:
1. Read the warning carefully
2. Proceed with the operation
3. The warning won't show again this session

## Contributing

To add new security rules:

1. **Add pattern to `SECURITY_PATTERNS` list**:
   ```python
   {
       "ruleName": "unique_rule_name",
       "substrings": ["pattern1", "pattern2"],  # OR
       "path_check": lambda path: condition,    # Path-based check
       "reminder": """Your detailed warning message...""",
   }
   ```

2. **Test the rule** with example code

3. **Update this README** with the new rule

### Rule Design Guidelines

- ✅ Include context (why it's dangerous)
- ✅ Provide safe alternatives with code
- ✅ Be specific, not vague
- ✅ Include links to resources when relevant
- ✅ Use emoji for visual scanning (⚠️, ✅, ❌)

## Integration with Other Plugins

Works well with:
- **frontend-dev-guidelines**: Security warnings + best practices
- **code-review**: Additional security checks during PR review
- **commit-commands**: Ensure secure code before committing

## Version History

### 2.0.0 (Current) - Frontend Security Enhancement

- ✅ Added 8 frontend-specific security rules
- ✅ React/JavaScript XSS prevention
- ✅ CORS and localStorage warnings
- ✅ postMessage security
- ✅ React best practices (keys, refs)
- ✅ Comprehensive educational content

### 1.0.0 - Initial Release

- ✅ Basic security patterns
- ✅ Backend security (exec, eval, pickle)
- ✅ Session-scoped warnings
- ✅ PreToolUse hook integration

## Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [React Security Best Practices](https://react.dev/learn/security)
- [MDN Web Security](https://developer.mozilla.org/en-US/docs/Web/Security)
- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

## License

This plugin is part of the Claude Code project. See repository LICENSE for details.

## Feedback

Found a security pattern we should cover? Please open an issue in the main repository.

---

**Security is everyone's responsibility.** This plugin helps catch common mistakes early. Stay vigilant! 🛡️
