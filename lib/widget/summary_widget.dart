import 'package:flutter/material.dart';

class SummaryWidget extends StatefulWidget {
  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  int container1Value = 0; // Income
  int container2Value = 0; // Expense
  late int container3Value; // Balance

  @override
  void initState() {
    super.initState();
    _updateBalance(); // คำนวณค่าเริ่มต้นของ Balance
  }

  void _updateBalance() {
    setState(() {
      container3Value = container1Value - container2Value;
    });
  }

  void _updateIncome(int newValue) {
    setState(() {
      container1Value = newValue;
      _updateBalance(); // อัพเดต Balance เมื่อ Income เปลี่ยน
    });
  }

  void _updateExpense(int newValue) {
    setState(() {
      container2Value = newValue;
      _updateBalance(); // อัพเดต Balance เมื่อ Expense เปลี่ยน
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
                height: 100,
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
                height: 100,
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
                height: 100,
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
