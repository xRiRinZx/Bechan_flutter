import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 233, 243, 33).withOpacity(0.2),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Slidable(
        key: ValueKey('transaction-item'),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // Implement edit functionality
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
                    color: const Color.fromARGB(255, 233, 243, 33).withOpacity(0.2),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 255, 119, 119),
                      size: 20,
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 33, 243, 184).withOpacity(0.2),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Row(
                          children: [
                            const Text(
                              '25 July 2024',
                              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 137, 137, 137)),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'TypeCategory',
                              style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 137, 137, 137)),
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
                    color: const Color.fromARGB(255, 243, 163, 33).withOpacity(0.2),
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '-0.00',
                          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
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
  }
}
