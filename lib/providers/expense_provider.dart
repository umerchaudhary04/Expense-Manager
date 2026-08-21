import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/tag.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of expenses
  List<Expense> _expenses = [];

  // List of categories
  List<ExpenseCategory> _categories = [];

  // List of tags
  List<Tag> _tags = [];

  // Getters
  List<Expense> get expenses => _expenses;
  List<ExpenseCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  ExpenseProvider(this.storage) {
    _loadExpensesFromStorage();
    _loadCategoriesFromStorage();
    _loadTagsFromStorage();
  }

  void _loadCategoriesFromStorage() {
    var storedCategories = storage.getItem('categories');
    if (storedCategories != null) {
      final List<dynamic> decoded = jsonDecode(storedCategories);
      _categories = decoded.map((item) => ExpenseCategory.fromJson(Map<String, dynamic>.from(item))).toList();
    } else {
      _categories = [
        ExpenseCategory(id: '1', name: 'Food', isDefault: true),
        ExpenseCategory(id: '2', name: 'Transport', isDefault: true),
        ExpenseCategory(id: '3', name: 'Entertainment', isDefault: true),
        ExpenseCategory(id: '4', name: 'Office', isDefault: true),
        ExpenseCategory(id: '5', name: 'Gym', isDefault: true),
      ];
    }
  }

  void _saveCategoriesToStorage() {
    storage.setItem('categories', jsonEncode(_categories.map((e) => e.toJson()).toList()));
  }

  void _loadTagsFromStorage() {
    var storedTags = storage.getItem('tags');
    if (storedTags != null) {
      final List<dynamic> decoded = jsonDecode(storedTags);
      _tags = decoded.map((item) => Tag.fromJson(Map<String, dynamic>.from(item))).toList();
    } else {
      _tags = [
        Tag(id: '1', name: 'Breakfast'),
        Tag(id: '2', name: 'Lunch'),
        Tag(id: '3', name: 'Dinner'),
        Tag(id: '4', name: 'Treat'),
        Tag(id: '5', name: 'Cafe'),
        Tag(id: '6', name: 'Restaurant'),
        Tag(id: '7', name: 'Train'),
        Tag(id: '8', name: 'Vacation'),
        Tag(id: '9', name: 'Birthday'),
        Tag(id: '10', name: 'Diet'),
        Tag(id: '11', name: 'MovieNight'),
        Tag(id: '12', name: 'Tech'),
        Tag(id: '13', name: 'CarStuff'),
        Tag(id: '14', name: 'SelfCare'),
        Tag(id: '15', name: 'Streaming'),
      ];
    }
  }

  void _saveTagsToStorage() {
    storage.setItem('tags', jsonEncode(_tags.map((e) => e.toJson()).toList()));
  }

  void _loadExpensesFromStorage() {
    var storedExpenses = storage.getItem('expenses');
    if (storedExpenses != null) {
      final List<dynamic> decoded = jsonDecode(storedExpenses);
      _expenses = decoded
          .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      notifyListeners();
    }
  }

  // Add an expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void _saveExpensesToStorage() {
    storage.setItem(
      'expenses',
      jsonEncode(_expenses.map((e) => e.toJson()).toList()),
    );
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      // Add new expense
      _expenses.add(expense);
    }
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete an expense
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a category
  void addCategory(ExpenseCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      _saveCategoriesToStorage();
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _saveCategoriesToStorage();
    notifyListeners();
  }

  // Add a tag
  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      _saveTagsToStorage();
      notifyListeners();
    }
  }

  // Delete a tag
  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    _saveTagsToStorage();
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }
}
