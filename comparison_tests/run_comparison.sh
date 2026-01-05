#!/bin/bash

# Script to compare our JSON Schema generator with quicktype

cd "$(dirname "$0")"

echo "=== JSON Schema Generator Comparison ==="
echo ""

# Array of test cases
tests=(
  "nested_objects"
  "array_of_objects"
  "union_types"
  "any_of_objects"
  "all_of_composition"
  "additional_properties"
  "definitions_refs"
)

# Generate individual schema files from test_cases.json
echo "=== Generating individual schema files ==="
for test in "${tests[@]}"; do
  echo "Extracting schema for $test..."
  node -e "
    const fs = require('fs');
    const cases = JSON.parse(fs.readFileSync('schemas/test_cases.json', 'utf8'));
    const testCase = cases.test_cases.find(t => t.name === '$test');
    if (testCase) {
      fs.writeFileSync('schemas/${test}.json', JSON.stringify(testCase.schema, null, 2));
      console.log('Created schemas/${test}.json');
    } else {
      console.error('Test case $test not found');
    }
  "
done

echo ""
echo "=== Running quicktype on all schemas ==="
for test in "${tests[@]}"; do
  if [ -f "schemas/${test}.json" ]; then
    echo "Processing $test with quicktype..."
    npx quicktype schemas/${test}.json -o quicktype_output/${test}.dart --lang dart
  fi
done

echo ""
echo "=== Comparison complete ==="
echo "Generated files:"
echo "  - quicktype_output/ contains quicktype generated Dart code"
echo ""
echo "Next steps:"
echo "1. Review quicktype output to see their approach"
echo "2. Generate our output for the same schemas"
echo "3. Compare differences in approach"
