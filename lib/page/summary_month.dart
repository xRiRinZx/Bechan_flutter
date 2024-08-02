import 'dart:convert';
import 'package:bechan/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model_data/api_summarymonth.dart';
import '../service/no_user.dart';
import '../widget/month_picker.dart';
import '../widget/summaryMonth_widget.dart';

class SummaryMonth extends StatefulWidget {
  @override
  _SummaryMonthState createState() => _SummaryMonthState();
}

class _SummaryMonthState extends State<SummaryMonth> {
  SummaryMonthData? summary;
  DateTime? selectedMonth;
  List<CategoryData>? incomeData;
  List<CategoryData>? expenseData;
  List<TagData>? tagData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    DateTime now = DateTime.now();
    selectedMonth = now;
    fetchTransactions();
  }

  Future<void> _fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  print('Current Token: $token');

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
        // Update the token in SharedPreferences if there is a new one
        final newToken = responseData['data']['token'];
        if (newToken != null && newToken != token) {
          await prefs.setString('token', newToken);
        }

        if (mounted) {
          setState(() {
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


  Future<void> fetchTransactions() async {
    if (selectedMonth == null) return;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      navigateToLogin(context);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '${Config.apiUrl}/summarymonth?selected_month=${DateFormat('yyyy-MM').format(selectedMonth!)}'
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
          final summaryType = responseData['data']['summary_type'];
          final tagSummary = responseData['data']['tag_summary'];

          print('Summary Data: $summaryData');

          if (mounted) {
            setState(() {
              summary = SummaryMonthData.fromJson(summaryData);
              if (summaryType is List) {
                final incomeSummary = summaryType.firstWhere(
                    (item) => item['type'] == 'income', orElse: () => null);
                final expenseSummary = summaryType.firstWhere(
                    (item) => item['type'] == 'expense', orElse: () => null);

                incomeData = incomeSummary != null && incomeSummary['categories'] is List
                    ? (incomeSummary['categories'] as List)
                        .map((category) => CategoryData.fromJson(category))
                        .toList()
                    : [];

                expenseData = expenseSummary != null && expenseSummary['categories'] is List
                    ? (expenseSummary['categories'] as List)
                        .map((category) => CategoryData.fromJson(category))
                        .toList()
                    : [];
              } else {
                incomeData = [];
                expenseData = [];
              }

              tagData = tagSummary is List
                  ? tagSummary.map((tag) => TagData.fromJson(tag)).toList()
                  : [];
              isLoading = false;
            });
          }
        } else if (responseData['status'] == 'error') {
          print('Error status: ${responseData['message']}');
          if (mounted) {
            setState(() {
              summary = SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0);
              incomeData = [];
              expenseData = [];
              tagData = [];
              isLoading = false;
            });
          }
        }
      } else {
        navigateToLogin(context);
      }
    } catch (e) {
      print('Exception: $e');
      navigateToLogin(context);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onMonthSelected(DateTime? newMonth) {
    setState(() {
      selectedMonth = newMonth;
    });
      fetchTransactions();
      _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    print('SelectMonth: $selectedMonth');
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 243, 152, 33).withOpacity(0.2),
            padding: const EdgeInsets.all(10),
            child: MonthPickerWidget(
              selectedMonth: selectedMonth,
              onMonthSelected: onMonthSelected,
            ),
          ),
          isLoading
              ? Center(child: CupertinoActivityIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: SummaryMonthWidget(
                              summary: summary ?? SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0),
                            ),
                          ),
                        ),
                        // Display Income Data
                        Container(
                          color: Color.fromARGB(255, 33, 243, 191).withOpacity(0.2),
                          padding: const EdgeInsets.all(10),
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
                            child: Column(
                              children: [
                                incomeData != null && incomeData!.isNotEmpty
                                    ? Container(
                                        height: 300, // Set a fixed height for the chart
                                        child: SfCircularChart(
                                          tooltipBehavior: TooltipBehavior(enable: true),
                                          annotations: <CircularChartAnnotation>[
                                            CircularChartAnnotation(
                                              widget: Center(
                                                child: Text(
                                                  '${summary?.totalIncome ?? 0}',
                                                  style: TextStyle(
                                                    fontSize: 35,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              angle: 90,
                                              radius: '0%',
                                            ),
                                            CircularChartAnnotation(
                                              widget: Center(
                                                child: Text(
                                                  'Income',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(255, 129, 129, 129),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              angle: 90,
                                              radius: '20%',
                                            ),
                                          ],
                                          series: <CircularSeries>[
                                            DoughnutSeries<CategoryData, String>(
                                              dataSource: incomeData!,
                                              xValueMapper: (CategoryData data, _) => data.name,
                                              yValueMapper: (CategoryData data, _) => data.amount,
                                              innerRadius: '80%',
                                              radius: '90%',
                                            )
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'No Data Income',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                if (incomeData != null && incomeData!.isNotEmpty)
                                 Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: incomeData!.map((data) {
                                        return CupertinoListTile(
                                          title: Text(
                                            '${data.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            '${data.amount}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(255, 154, 154, 154),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                        // Display Expense Data
                        Container(
                          color: Color.fromARGB(255, 243, 33, 33).withOpacity(0.2),
                          padding: const EdgeInsets.all(10),
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
                            child: Column(
                              children: [
                                expenseData != null && expenseData!.isNotEmpty
                                    ? Container(
                                        height: 300, // Set a fixed height for the chart
                                        child: SfCircularChart(
                                          tooltipBehavior: TooltipBehavior(enable: true),
                                          annotations: <CircularChartAnnotation>[
                                            CircularChartAnnotation(
                                              widget: Center(
                                                child: Text(
                                                  '${summary?.totalExpense ?? 0}',
                                                  style: TextStyle(
                                                    fontSize: 35,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              angle: 90,
                                              radius: '0%',
                                            ),
                                            CircularChartAnnotation(
                                              widget: Center(
                                                child: Text(
                                                  'Expense',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(255, 129, 129, 129),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              angle: 90,
                                              radius: '20%',
                                            ),
                                          ],
                                          series: <CircularSeries>[
                                            DoughnutSeries<CategoryData, String>(
                                              dataSource: expenseData!,
                                              xValueMapper: (CategoryData data, _) => data.name,
                                              yValueMapper: (CategoryData data, _) => data.amount,
                                              innerRadius: '80%',
                                              radius: '90%',
                                            )
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            'No Data Expense',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                if (expenseData != null && expenseData!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: expenseData!.map((data) {
                                        return CupertinoListTile(
                                          title: Text(
                                            '${data.name}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            '${data.amount}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: const Color.fromARGB(255, 154, 154, 154),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (tagData != null)
                          Container(
                            color: Color.fromARGB(255, 33, 58, 243).withOpacity(0.2),
                            padding: const EdgeInsets.all(10),
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
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Table(
                                      
                                      columnWidths: {
                                        0: FlexColumnWidth(2), // Adjust column width as needed
                                        1: FlexColumnWidth(1),
                                        2: FlexColumnWidth(1),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Tag',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Income',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Expense',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...(tagData?.map((data) {
                                          return TableRow(
                                            children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${data.name}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${data.income}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: const Color.fromARGB(255, 154, 154, 154),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${data.expense}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: const Color.fromARGB(255, 154, 154, 154),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        })?.toList() ?? []),
                                      ],
                                    ),
                                  ),    
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
      ),
    );
  }
}
