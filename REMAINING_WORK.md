# Remaining Test Failures and Fixes Needed

## Summary
We have 141 passing tests and 11 failing tests. Most failures are related to:

1. **Sealed class file organization** (major)
2. **Test expectations needing updates** for new naming conventions (minor)
3. **Contains type naming** issues (minor)

## Test Failures

### 1. GitHub Workflow/Action Tests (Loading Failures)
**Issue**: Sealed classes and their variants are being generated in separate files, which causes:
- Multiple exports of the same sealed class from different files
- Sealed classes can't be extended from other files (Dart restriction)
- Missing type references when variants are in separate files

**Solution**: Keep sealed classes and ALL their variants in the same file. When generating multi-file output:
- Base sealed class + all variants → single file
- Only split regular classes into separate files

**Files affected**:
- `test/github_workflow_test.dart` - compilation errors
- `test/github_action_test.dart` - compilation errors

### 2. Default Value Tests  
**Issue**: Tests expect old class naming (`RootSchemaItem`) but we now generate better names (`Item` after singularization).

**Solution**: Update test expectations to match new naming:
- `test/default_value_test.dart`: Update expected class names from `RootSchemaItem` to `Item`

### 3. Contextual Naming Tests
**Issue**: Similar to #2, tests expect old naming conventions.

**Solution**: Update test expectations:
- `test/contextual_naming_test.dart`: 
  - "nested objects should use property name" - expects `Config` instead of `RootSchemaConfig`
  - "irregular plural singularization" - expects `Child` instead of `RootSchemaChildrenItem`

### 4. GitHub Action Tests (After Compilation Fixed)
**Issue**: Tests expect specific class names like `RootSchemaRuns` but we may generate different names after fixing sealed classes.

**Solution**: After fixing sealed class file organization, verify and update class name expectations.

### 5. Contains Type Naming
**Issue**: Test expects `RootSchemaValue` but we generate `Value` after applying singularization logic.

**Solution**: Verify that `contains` keyword types are properly named, potentially excluding them from root prefix stripping.

## Implementation Plan

### Phase 1: Fix Sealed Class File Organization (HIGH PRIORITY)
1. Update `SchemaGenerator._planMultiFileOutput()` to:
   - Detect when a class is a sealed class (check `isSealed` or similar)
   - Group sealed class with all its variant classes
   - Generate them all in one file
   - Use `part` statements only within sealed class files for variants

2. Update variant class generation to:
   - Not create separate files for sealed class variants
   - Generate them inline in the sealed class file

### Phase 2: Update Test Expectations (LOW PRIORITY)
1. Update test expectations to match new naming:
   - `test/default_value_test.dart` 
   - `test/contextual_naming_test.dart`
   - `test/annotations_test.dart` (contains test)

### Phase 3: Verify and Clean Up
1. Run full test suite
2. Update any remaining expectations
3. Remove debug/temporary code
4. Update documentation

## Technical Notes

### Sealed Class File Structure
```dart
// shape.dart - Base sealed class + variants together
sealed class Shape { ... }

class Circle extends Shape { ... }

class Rectangle extends Shape { ... }

// NO separate files for Circle or Rectangle
```

### Current (Broken) vs. Fixed Structure

**Current (Broken)**:
```
concurrency.dart          // sealed class Concurrency
concurrency2.dart         // class Concurrency extends Concurrency4
concurrency3.dart         // class Concurrency extends Concurrency4 (duplicate!)
concurrency4.dart         // sealed class Concurrency4
```

**Fixed**:
```
concurrency.dart          // sealed class Concurrency + all variants in one file
  - sealed class Concurrency
  - class ConcurrencyString extends Concurrency
  - class ConcurrencyObject extends Concurrency
```

## Complexity Estimate
- **Sealed class fix**: Medium complexity, affects core generation logic
- **Test updates**: Low complexity, simple string replacements
- **Total effort**: ~2-3 hours of focused work

## Priority
**HIGH** - The sealed class issue blocks a significant portion of the test suite and would cause issues in real usage.
