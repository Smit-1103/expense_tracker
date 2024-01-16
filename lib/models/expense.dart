import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences package
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'date': date.toString(),
        'title': title,
        'category': category.toString(),
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        amount: json['amount'],
        date: DateTime.parse(json['date']),
        title: json['title'],
        category: Category.values.firstWhere((e) {
          return e.toString() == json['category'];
        }),
      );

  // Function to save the expenses list to SharedPreferences
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedExpenses =
        expenses.map((e) => jsonEncode(e.toJson())).toList();
    print('encoded string : $encodedExpenses');
    await prefs.setStringList('expenses', encodedExpenses);
    var tempExpense = await prefs.getStringList('expenses');
    print('get expense : $tempExpense');
  }

  // Function to load the expenses list from SharedPreferences
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedExpenses = prefs.getStringList('expenses');
    print('Loaded expenses : $encodedExpenses ');
    if (encodedExpenses == null) {
      return [];
    }
    return encodedExpenses
        .map((String encodedExpense) =>
            Expense.fromJson(jsonDecode(encodedExpense)))
        .toList();
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
