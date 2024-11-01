import 'dart:developer';

void main() {
  var name = "John";

  // First list with name and email
  List<Map<String, dynamic>> list1 = [
    {'name': 'John', 'email': 'john@example.com'},
    {'name': 'Alice', 'email': 'alice@example.com'},
    {'name': 'Bob', 'email': 'bob@example.com'},
    {'name': 'Emma', 'email': 'emma@example.com'},
  ];

  // Second list with name and email
  List<Map<String, dynamic>> list2 = [
    {'name': 'David', 'email': 'david@example.com'},
    {'name': 'Eva', 'email': 'eva@example.com'},
    {'name': 'Grace', 'email': 'grace@example.com'},
  ];

  // Combine two lists into a single list
  List<Map<String, dynamic>> combinedList = [];
  combinedList.addAll(list1);
  combinedList.addAll(list2);

  // List to store matching items
  List<Map<String, dynamic>> matchingList = [];

  // Search for matching items and add them to matchingList
  for (var item in combinedList) {
    if (item['name'] == name) {
      matchingList.add(item);
    }
  }

  // Print matchingList
  log(matchingList.toString());
}
