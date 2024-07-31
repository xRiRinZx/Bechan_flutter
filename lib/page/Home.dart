import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model_data/api_summaryday.dart';
import '../service/no_user.dart';
import '../widget/transaction_list.dart';
import '/widget/date_picker.dart';
import 'package:bechan/config.dart';
import '/widget/summary_widget.dart';

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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    DateTime now = DateTime.now();
    startDate = now;
    endDate = now;
    fetchTransactions();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (!isLoading && (pagination == null || currentPage < pagination!.pageTotal)) {
        setState(() {
          isLoading = true; // ตั้งค่า isLoading เป็น true เพื่อป้องกันการเรียกซ้ำ
        });
        fetchTransactions(page: currentPage + 1); // เรียกใช้หน้าใหม่
      }
    }
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      navigateToLogin(context);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${Config.apiUrl}/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'ok') {
          if (mounted) {
            setState(() {
              _userData = responseData;
              isLoading = false;
            });
          }
        } else if (responseData['status'] == 'error') {
          navigateToLogin(context);
        }
      } else {
        navigateToLogin(context);
      }
    } catch (e) {
      navigateToLogin(context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchTransactions({int page = 1}) async {
    if (startDate == null || endDate == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(
          '${Config.apiUrl}/summaryday?selected_date_start=${DateFormat('yyyy-MM-dd').format(startDate!)}&selected_date_end=${DateFormat('yyyy-MM-dd').format(endDate!)}&page=$page&pageSize=10',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'ok') {
          final summaryData = responseData['data']['summary'];
          final transactionsData = responseData['data']['transactions'];
          final paginationData = Pagination.fromJson(responseData['data']['pagination']);

          if (mounted) {
            setState(() {
              if (page == 1) {
                transactions = [];
              }
              summary = Summary.fromJson(summaryData);
              transactions.addAll(
                transactionsData.map<Transaction>((json) => Transaction.fromJson(json)).toList(),
              );
              pagination = paginationData;
              isLoading = false;
              currentPage = page;
            });
          }
        } else if (responseData['status'] == 'error') {
          if (mounted) {
            setState(() {
              summary = Summary(totalIncome: 0, totalExpense: 0);
              transactions = [];
              isLoading = false;
            });
          }
        }
      } else {
        navigateToLogin(context);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      navigateToLogin(context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onDateRangeSelected(DateTime? start, DateTime? end) {
    setState(() {
      startDate = start;
      endDate = end;
      currentPage = 1;
      fetchTransactions(page: currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String day = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    String year = DateFormat('yyyy').format(now);

    return Scaffold(
      body: _userData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.blue.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
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
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_userData != null && _userData!['data'] != null && _userData!['data']['user'] != null)
                                      ClipOval(
                                        child: Image.network(
                                          '${Config.apiUrl}/${_userData!['data']['user']['profile_path']}',
                                          width: 50,
                                          height: 50,
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
                          const SizedBox(width: 10),
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
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 243, 152, 33).withOpacity(0.2),
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: DatePickerWidget(
                      onDateRangeSelected: onDateRangeSelected,
                    ),
                  ),
                  Center(
                    child: SummaryWidget(
                      summary: summary ?? Summary(totalIncome: 0, totalExpense: 0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 243, 33, 103).withOpacity(0.2),
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
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
                        child: Column(
                          children: [
                            Expanded(
                              child: TransactionList(
                                transactions: transactions,
                                scrollController: _scrollController, // ส่ง scrollController ไปที่ TransactionList
                              ),
                            ),
                            if (isLoading)
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: const CircularProgressIndicator(),
                              ),
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
