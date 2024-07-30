import 'package:bechan/page/summary_month.dart';
import 'package:bechan/page/summary_year.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Container(
            child: CupertinoSlidingSegmentedControl<int>(
              children: {
                0: Text('Month'),
                1: Text('Year'),
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
                SummaryMonth(),
                SummaryYear(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
