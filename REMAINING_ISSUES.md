# Remaining Test Failures - Summary

## Status
- **Tests Passing**: 140/152
- **Tests Failing**: 12

## Main Issues

### 1. Sealed Class File Organization
**Problem**: Sealed classes and their variants are being split into separate files, causing:
- Missing file imports
- Sealed classes that can't be extended from other files
- Build failures

**Solution Needed**: 
- Keep sealed class base and all variants in the same file
- Don't generate separate files for union variants
- Example: `Configuration`, `ConfigurationString`, `ConfigurationNum`, `ConfigurationBool` should all be in `configuration.dart`

### 2. Name Collisions
**Problem**: Multiple classes named the same thing in different contexts:
- `Concurrency` appears in both `normal_job_concurrency.dart` and `reusable_workflow_call_job_concurrency.dart`
- Both get exported, causing collision

**Solution Options**:
a) Use fully qualified names like `NormalJobConcurrency` and `ReusableWorkflowCallJobConcurrency`
b) Use prefixed imports
c) Don't export union variants that are contextual

### 3. Missing Type References
**Problem**: `ContainerEnv` type not found
- Likely a sealed class that should have been generated
- Or a reference to a class that wasn't created

**Solution**: Debug why `ContainerEnv` isn't being generated or properly referenced

### 4. Validate Method Implementation
**Problem**: Sealed class variants missing `validate()` method implementation

**Solution**: When generating sealed class variants, ensure they implement all abstract methods from the base sealed class

## Test Files Affected
- `test/github_workflow_test.dart` - Can't load due to missing imports
- `test/github_action_test.dart` - Class naming expectations
- `test/annotations_test.dart` - Contains type naming issue

## Recent Progress
✅ Fixed: Nested class naming (e.g., `RootSchemaItem` instead of `Item`)
✅ Fixed: Default value generation
✅ Fixed: Multiple test suites now passing

## Next Steps (Priority Order)
1. **Fix sealed class file organization** - Keep variants with base class
2. **Resolve name collisions** - Use qualified names for contextual classes  
3. **Debug missing types** - Find why `ContainerEnv` and others aren't generated
4. **Add validate methods** - Ensure sealed variants implement base class methods
5. **Regenerate examples** - Run generator on example schemas after fixes
6. **Verify all tests pass** - Aim for 152/152
