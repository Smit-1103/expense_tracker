import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

//validation of the input fields
  void _submitExpenseData() {
    final enteredAmount =
        double.tryParse(_amountController.text); // convert the text into int
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Invalid Input',
            style: TextStyle(
              color: MyColors.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Please make sure a valid title, amount, date, and category is inserted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(MyColors.errorColor),
                overlayColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  return MyColors.errorLightColor;
                }),
              ),
              child: const Text('Okay'),
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)), // Rounded corners
        ),
      );
      return;
      // after thhis return no other code is executed further
    }

    widget.onAddExpense(
      Expense(
          amount: enteredAmount,
          date: _selectedDate!,
          title: _titleController.text,
          category: _selectedCategory),
    );
    // to close the overlay
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Add new expense',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(
            color: MyColors.textColor,
            thickness: 1,
            height: 32,
          ),
          TextField(
            controller: _titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.add_box_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
                borderSide: const BorderSide(
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: MyColors.primaryColor,
                  width: 2.0,
                ),
              ),
              hintText: 'Enter the expense title',
              hintStyle: const TextStyle(
                fontSize: 14.0,
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // prefixText: '₹ ',
                    prefixIcon: const Icon(Icons.currency_rupee_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(80.0),
                      borderSide: const BorderSide(
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: MyColors.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter the amount',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
  child: OutlinedButton.icon(
    onPressed: _presentDatePicker,
    icon: const Icon(
      Icons.calendar_month,
    ),
    label: Text(
      _selectedDate == null
          ? 'Select Date'
          : formatter.format(_selectedDate!),
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80.0),
      ),
      backgroundColor: Colors.transparent, // Set background color to transparent
      foregroundColor: const Color.fromARGB(255, 4, 79, 141), // Set the text color to blue
    ),
  ),
),

            ],
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField<Category>(
            value: _selectedCategory,
            items: Category.values
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(categoryIcons[
                              category]), // Display icon for each category
                          const SizedBox(
                              width: 10), // Add spacing between icon and text
                          Text(
                            category.name.toString(),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value as Category;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80.0),
                borderSide: const BorderSide(
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: MyColors.primaryColor,
                  width: 2.0,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(MyColors.errorColor),
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return MyColors.errorLightColor;
                  }),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8), // Adjust the space between buttons
              OutlinedButton(
                onPressed: _submitExpenseData,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 23, 56, 107)),
                  foregroundColor:
                      MaterialStateProperty.all(MyColors.backgroundColor),
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    return MyColors.accentColor;
                  }),
                  side: MaterialStateProperty.all(BorderSide.none),
                ),
                child: const Text(
                  'Save Expense',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
