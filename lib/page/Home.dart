import 'dart:convert';
import 'package:bechan/page/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../model_data/api_summaryday.dart';
import '../widget/transaction_list.dart';
import '/widget/date_picker.dart';
import 'package:bechan/config.dart';
import '/widget/summary_widget.dart';
import '/service/shared_preferences_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserDataState();
  }
}

class _UserDataState extends State<Home> {
  Map<String, dynamic>? _userData;
  List<Transaction> transactions = [];
  Summary? summary;
  int currentPage = 1;
  bool isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  Pagination? pagination;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    // Default startDate and endDate to the current month
    DateTime now = DateTime.now();
    startDate = now;
    endDate = now;
    fetchTransactions(); // Initial fetch with default dates
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _navigateToLogin();
      return; // No token, return early
    }

    final response = await http.get(
      Uri.parse('${Config.apiUrl}/user'), // Adjust URL as necessary
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status'] == 'ok') {
        setState(() {
          _userData = responseData;
        });
      } else if (responseData['status'] == 'error') {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Future<void> fetchTransactions({int page = 1}) async {
    print("FETCH ---- page : $page");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (startDate == null || endDate == null) return; // Ensure dates are selected

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        '${Config.apiUrl}/summaryday?selected_date_start=${DateFormat('yyyy-MM-dd').format(startDate!)}&selected_date_end=${DateFormat('yyyy-MM-dd').format(endDate!)}&page=$page&pageSize=10',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Fetch token from shared preferences
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'ok') {
      final summaryData = responseData['data']['summary'];
      final transactionsData = responseData['data']['transactions'];
      final paginationData = Pagination.fromJson(responseData['data']['pagination']);

      print('Summary Data: $summaryData');
      print('Transactions Data: $transactionsData');
      print('Pagination Data: $paginationData');

      if (page == 1) {
        transactions = [];
      }

      setState(() {
        summary = Summary.fromJson(summaryData);
        transactions.addAll(
          transactionsData.map<Transaction>((json) => Transaction.fromJson(json)).toList(),
        );
        isLoading = false;
        pagination = paginationData;
      });
    } else if (responseData['status'] == 'error') {
      setState(() {
        summary = Summary(totalIncome: 0,totalExpense: 0,);
        transactions = [];
        isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('No transactions found for the selected date.'),
      //   ),
      // );
    }
    } else {
       _navigateToLogin();
      setState(() {
        isLoading = false;
      });
    }
  }

  void onDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      startDate = start;
      endDate = end;
      currentPage = 1; // Reset to page 1 when dates change
      fetchTransactions(page: currentPage);
    });
  }

  @override
Widget build(BuildContext context) {
  DateTime now = DateTime.now();
  String day = DateFormat('dd').format(now);
  String month = DateFormat('MMMM').format(now);
  String year = DateFormat('yyyy').format(now);

  print('Current Summary: $summary');
  print('Current Transaction: $transactions');


  return Scaffold(
    body: _userData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Column(
              children: [
                Container(
                  color: Colors.blue.withOpacity(0.2), // Background color of the row
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // Add padding around the Row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute content evenly
                      children: [
                        //=====User======
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3), // Shadow color
                                  offset: const Offset(0, 4), // Shadow position
                                  blurRadius: 8, // Blur radius of the shadow
                                ),
                              ],
                            ),
                            height: 90,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0), // Add padding around the content
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_userData != null && _userData!['data'] != null && _userData!['data']['user'] != null)
                                    ClipOval(
                                      child: Image.network(
                                        '${Config.apiUrl}/${_userData!['data']['user']['profile_path']}', // Add the URL of the desired image
                                        width: 50, // Diameter of the circle
                                        height: 50, // Diameter of the circle
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (_userData != null && _userData!['data'] != null && _userData!['data']['user'] != null)
                                        Text(
                                          _userData!['data']['user']['firstname'],
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      const Text(
                                        'Welcome back!',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //===============
                        const SizedBox(width: 10),
                        //====DateNow====
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    day,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        month,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        year,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //===============
                      ],
                    ),
                  ),
                ),
                // ====== DatePickerWidget=======
                Container(
                  color: const Color.fromARGB(255, 243, 152, 33).withOpacity(0.2),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: DatePickerWidget(
                    onDateRangeSelected: onDateRangeSelected, // Set date range selection callback
                  ),
                ),
                //===============================
                Center(
                  child: SummaryWidget(
                    summary: summary ?? Summary(totalIncome: 0, totalExpense: 0),
                  ),
                ),
                //======Transaction==========
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 243, 33, 103).withOpacity(0.2),
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (!isLoading &&
                              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                              pagination != null &&
                              currentPage < pagination!.pageTotal) { // Check if there are more pages
                              print("Current 1 : $currentPage" );
                            currentPage++;
                              print("Current 2 : $currentPage" );
                            fetchTransactions(page: currentPage);
                          return false;
                          }
                            return true;
                        },
                        child: TransactionList(transactions: transactions),
                      ),
                    ),
                  ),
                ),
                        // child: TransactionList(transactions: transactions),
                      // child: NotificationListener<ScrollNotification>(
                      //   onNotification: (scrollInfo) {
                      //     if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      //       currentPage++;
                      //       fetchTransactions(page: currentPage);
                      //     }
                      //     return false;
                      //   },
                      // ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
  );
}
}