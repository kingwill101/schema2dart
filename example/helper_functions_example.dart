// Example: Using generated helper functions
import 'dart:convert';

// Example schema with helper functions enabled
const schema = {
  "type": "object",
  "properties": {
    "name": {"type": "string"},
    "age": {"type": "integer"},
    "email": {"type": "string", "format": "email"}
  },
  "required": ["name", "age"]
};

// With generateHelpers: true, this generates:
//
// User userFromJson(String str) => User.fromJson(json.decode(str));
// String userToJson(User data) => json.encode(data.toJson());

void main() {
  // Easy parsing from JSON string
  final jsonString = '{"name": "Alice", "age": 30, "email": "alice@example.com"}';
  
  // Using the generated helper function
  // final user = userFromJson(jsonString);
  
  // Easy serialization to JSON string  
  // final output = userToJson(user);
  
  print('Helper functions make JSON parsing convenient!');
  print('No need to manually call json.decode/json.encode');
  
  // Without helpers, you would need to do:
  // final user = User.fromJson(json.decode(jsonString));
  // final output = json.encode(user.toJson());
}
