import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../model_data/api_summaryday.dart'; 

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final ScrollController scrollController; // เพิ่มพารามิเตอร์ใหม่

  TransactionList({
    required this.transactions,
    required this.scrollController, // เพิ่มพารามิเตอร์ใหม่
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return Center(
        child: Text('No transactions available.'),
      );
    }

    return ListView.builder(
      controller: widget.scrollController, // ใช้ scrollController ที่ได้รับ
      padding: const EdgeInsets.all(10),
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final transaction = widget.transactions[index];
        final isIncome = transaction.categorieType == 'income';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Slidable(
            key: ValueKey(transaction.transactionsId),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Implement edit functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit functionality not implemented')),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                ),
                SlidableAction(
                  onPressed: (context) {
                    // Implement delete functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete functionality not implemented')),
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
              ],
            ),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Implement duplicate functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Duplicate functionality not implemented')),
                    );
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.copy,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.circle_rounded,
                          color: isIncome ? Color.fromARGB(255, 96, 194, 148) : Color.fromARGB(255, 194, 96, 107),
                          size: 17,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10,bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.note,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  DateFormat('dd MMM yyyy').format(DateTime.parse(transaction.transactionDatetime)),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 137, 137, 137),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  transaction.categoriename,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 137, 137, 137),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              (isIncome ? '+' : '-') + transaction.amount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
