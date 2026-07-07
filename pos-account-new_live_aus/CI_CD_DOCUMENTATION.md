# CI/CD Pipeline Documentation

**Last Updated**: 2024-07-06

---

## Overview

The POSApt Flutter application uses GitHub Actions for continuous integration and deployment. This document describes the automated workflows.

---

## Workflows

### 1. Build & Test (`build-test.yml`)

**Trigger**: Push to main/develop/staging, Pull requests

**Jobs**:

#### a) Code Analysis
- Runs `flutter analyze` for static code analysis
- Checks code formatting
- Verifies linting rules
- **Duration**: ~10 minutes

#### b) Unit Tests
- Runs all unit tests
- Generates code coverage report
- Uploads coverage to Codecov
- **Duration**: ~15 minutes

#### c) Widget Tests
- Runs widget tests
- Tests UI components and integrations
- **Duration**: ~20 minutes

#### d) Build UAT APK
- Builds APK for UAT environment
- Splits APK per architecture (arm64, armeabi-v7a, x86)
- **Duration**: ~30 minutes
- **Artifact**: pos-account-uat-apk

#### e) Build PROD APK
- Builds APK for production
- Only triggers on main branch
- **Duration**: ~30 minutes
- **Artifact**: pos-account-prod-apk

#### f) Build iOS (UAT & PROD)
- Builds iOS app for both environments
- Runs on macOS
- **Duration**: ~30 minutes each
- **Note**: Requires codesigning for actual deployment

#### g) Security Scan
- Checks for outdated dependencies
- Runs security audits
- **Duration**: ~15 minutes

---

### 2. Deploy to Production (`deploy-production.yml`)

**Trigger**: Git tag push (e.g., `v1.2.74`)

**Jobs**:

#### a) Create Release
- Creates GitHub Release
- Generates release notes
- **Automatic**: Yes

#### b) Build Production APK
- Builds release APK
- Builds App Bundle (for Google Play)
- Uploads to release
- **Duration**: ~40 minutes

#### c) Build Production iOS
- Builds iOS app
- Uploads to artifacts
- **Duration**: ~40 minutes

#### d) Notify Slack
- Sends deployment notification
- Requires: SLACK_WEBHOOK secret
- **Status**: Success/Failure

---

## Environment Variables

Set these in GitHub Secrets:

```
SLACK_WEBHOOK        - Slack webhook URL for notifications
KEYSTORE_FILE        - Base64 encoded keystore for signing
KEYSTORE_PASSWORD    - Keystore password
KEY_ALIAS            - Key alias in keystore
KEY_PASSWORD         - Key password
```

---

## Dart Defines

Build-time configuration:

```bash
--dart-define=FLAVOR=uat          # UAT environment
--dart-define=FLAVOR=prod         # Production environment
```

---

## Running Tests Locally

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth_test.dart

# Run tests matching pattern
flutter test --name="Auth"
```

---

## Building Locally

```bash
# Build UAT APK
flutter build apk -t lib/main_uat.dart --dart-define=FLAVOR=uat

# Build PROD APK
flutter build apk -t lib/main_prod.dart --dart-define=FLAVOR=prod

# Build AAB for Play Store
flutter build appbundle -t lib/main_prod.dart --dart-define=FLAVOR=prod

# Build iOS
flutter build ios -t lib/main_prod.dart --dart-define=FLAVOR=prod
```

---

## Artifact Retention

- **UAT builds**: 30 days
- **Production builds**: 30 days
- **Test results**: Not retained
- **Coverage reports**: Sent to Codecov

---

## Troubleshooting

### Build Fails - Out of Memory
```bash
export GRADLE_OPTS="-Xmx4g"
flutter build apk --release
```

### Tests Timeout
- Increase timeout in workflow
- Check for infinite loops or blocking operations

### Signing Issues
- Verify keystore file is properly encoded in secrets
- Check keystore password and alias

---

## Code Coverage

Coverage reports are automatically uploaded to [Codecov.io](https://codecov.io)

- **Target**: 70% coverage
- **Current**: Check GitHub Actions output
- **View**: `coverage/lcov.info`

---

## Deployment Process

### Pre-Production Checklist

- [ ] All tests passing
- [ ] Code review approved
- [ ] Security scan passing
- [ ] Coverage > 70%

### Release Steps

1. **Create Release Tag**
   ```bash
   git tag -a v1.2.75 -m "Release v1.2.75"
   git push origin v1.2.75
   ```

2. **Monitor Deployment**
   - Watch GitHub Actions for build completion
   - Check Slack for notification
   - Verify APK/IPA available in release

3. **Upload to Stores**
   - **Google Play**: Upload AAB from artifacts
   - **App Store**: Use Xcode or Transporter

---

## Branching Strategy

```
main                 - Production releases only (tagged)
staging              - Pre-release testing
develop              - Development builds
feature/*            - Feature branches
bugfix/*             - Bug fix branches
```

### Build Matrix

| Branch | UAT | PROD | Test |
|--------|-----|------|------|
| feature/* | ✅ | ❌ | ✅ |
| develop | ✅ | ❌ | ✅ |
| staging | ✅ | ✅ | ✅ |
| main | ✅ | ✅ | ✅ |

---

## Performance

Average Build Times:
- Android Analysis: 10 min
- Unit Tests: 15 min
- Widget Tests: 20 min
- APK Build: 30 min
- iOS Build: 30 min
- **Total**: ~45 min (parallel)

---

## Secrets Management

**Never commit secrets!**

Set in GitHub → Settings → Secrets:

1. Navigate to repo
2. Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add secret name and value

**Required Secrets**:
- `SLACK_WEBHOOK` - For notifications
- `GITHUB_TOKEN` - Automatic (provided)

---

## Monitoring

### GitHub Actions Dashboard
- Build status
- Workflow runs
- Logs and artifacts

### Codecov Dashboard
- Coverage trends
- File coverage
- PR coverage changes

### Slack Integration
- Build notifications
- Deployment status
- Error alerts

---

## FAQ

**Q: How do I skip CI?**
A: Add `[skip ci]` to commit message

**Q: How long do builds take?**
A: ~45 minutes total (parallel jobs)

**Q: Can I deploy without tests?**
A: No, production requires all jobs to pass

**Q: How do I rollback a release?**
A: Create a new tag pointing to previous commit

---

## Contact & Support

- **Issues**: GitHub Issues
- **Questions**: Team Slack
- **Builds**: GitHub Actions
- **Coverage**: Codecov

---

**Related Documents**:
- [COMPREHENSIVE_AUDIT_REPORT.md](../COMPREHENSIVE_AUDIT_REPORT.md)
- [FIXES_APPLIED.md](../FIXES_APPLIED.md)
- [README.md](../README.md)
