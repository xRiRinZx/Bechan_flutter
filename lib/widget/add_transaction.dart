
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page/add_expense.dart';
import '../page/add_income.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddTransaction'),
      ),
      body: Column(
        children: [
          Container(
            child: CupertinoSlidingSegmentedControl<int>(
              children: {
                0: Text('Income'),
                1: Text('Expense'),
              },
              groupValue: _selectedSegment,
              onValueChanged: (int? newValue) {
                setState(() {
                  if (newValue != null) {
                    _selectedSegment = newValue;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedSegment,
              children: [
                AddIncome(),
                AddExpense(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
