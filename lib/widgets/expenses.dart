import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      amount: 19.99,
      date: DateTime.now(),
      title: "Flight ticket",
      category: Category.travel,
    ),
    Expense(
      amount: 29,
      date: DateTime.now(),
      title: "Restaurant",
      category: Category.food,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 4 / 5, // Adjust the fraction as needed
        child: NewExpense(onAddExpense: _addExpense),
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
  leading: Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return GestureDetector(
        onTap: () {
          themeProvider.toggleTheme();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            themeProvider.themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode,
            size: 22,
          ),
        ),
      );
    },
  ),
  title: const Text(
    "Expenses Tracker",
  ),
  centerTitle: true,
  actions: [
    Tooltip(
      message: 'Click here to add a new item',
      child: IconButton(
        icon: const Icon(
          Icons.add,
          size: 25,
        ),
        onPressed: _openAddExpensesOverlay,
      ),
    )
  ],
),

      body: width < 600
          ? Column(
              children: [
                Visibility(
                  visible: _registeredExpenses.isNotEmpty,
                  child: Chart(expenses: _registeredExpenses),
                ),
                _registeredExpenses.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              MyImages.addDataAnimation,
                              width: 350,
                              height: 350,
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Please add some expenses!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: MyColors.hintTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ExpensesList(
                          expenses: _registeredExpenses,
                          onRemovedExpense: _removeExpense,
                        ),
                      ),
              ],
            )
          : Row(
              children: [
                Visibility(
                  visible: _registeredExpenses.isNotEmpty,
                  child: Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                ),
                _registeredExpenses.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              MyImages.addDataAnimation,
                              width: 350,
                              height: 350,
                            ),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Please add some expenses!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: MyColors.hintTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ExpensesList(
                          expenses: _registeredExpenses,
                          onRemovedExpense: _removeExpense,
                        ),
                      ),
              ],
            ),
    );
  }
}
