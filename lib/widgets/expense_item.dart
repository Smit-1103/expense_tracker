import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {Key? key}) : super(key: key);

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          expense.title,
          style: Theme.of(context).textTheme.headline6,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(
              categoryIcons[expense.category],
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 96, 145, 235)
                  : const Color.fromARGB(255, 30, 71, 138),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(expense.formattedDate),
          ],
        ),
        trailing: Text(
          '₹${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.green, // Adjust the color based on your design
          ),
        ),
      ),
    );
  }
}
