import 'package:flutter/material.dart';
import '../model_data/api_summarymonth.dart'; 

class SummaryMonthWidget extends StatefulWidget {
  final SummaryMonthData? summary;

  SummaryMonthWidget({this.summary}); // Constructor to accept nullable summary

  @override
  _SummaryMonthWidgetState createState() => _SummaryMonthWidgetState();
}

class _SummaryMonthWidgetState extends State<SummaryMonthWidget> {
  double container1Value = 0; // Income
  double container2Value = 0; // Expense
  double container3Value = 0; // Balance

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  @override
  void didUpdateWidget(covariant SummaryMonthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.summary != widget.summary ) {
      _updateValues(); // Update values when widget.summary changes
    }
  }

  void _updateValues() {
    setState(() {
        container1Value = widget.summary!.totalIncome;
        container2Value = widget.summary!.totalExpense;
        container3Value = widget.summary!.balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 156, 33, 243).withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), 
                      offset: const Offset(0, 4), 
                      blurRadius: 8, 
                    ),
                  ],
                ),
                height: 90,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Income', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('$container1Value')
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), 
                      offset: const Offset(0, 4), 
                      blurRadius: 8, 
                    ),
                  ],
                ),
                height: 90,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Expense', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('$container2Value')
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 113, 191, 255),
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), 
                      offset: const Offset(0, 4), 
                      blurRadius: 8, 
                    ),
                  ],
                ),
                height: 90,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Balance', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('$container3Value')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
