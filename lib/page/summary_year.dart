import 'dart:convert';

import 'package:bechan/config.dart';
import 'package:bechan/page/summary_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model_data/api_summaeryear.dart';
import '../model_data/api_summarymonth.dart';
import '../service/no_user.dart';
import '../widget/summaryMonth_widget.dart';
import '../widget/year_picker.dart';

String monthNumberToAbbreviation(int monthNumber) {
  final date = DateTime(2024, monthNumber); // Use any year for conversion
  return DateFormat('MMM').format(date); // Get abbreviated month name (e.g., Jan)
}

String monthNumberToName(int monthNumber) {
  try {
    // Create a DateTime object with the given month number
    DateTime date = DateTime(2024, monthNumber); // Use any year, month number is the key
    // Format the month to a full month name
    return DateFormat('MMMM').format(date);
  } catch (e) {
    return ''; // Handle any potential error
  }
}

class SummaryYear extends StatefulWidget {
  @override
  _SummaryYearState createState() => _SummaryYearState();
}

class _SummaryYearState extends State<SummaryYear> {
  SummaryMonthData? summary;
  DateTime? selectedYear;
  bool isLoading = false; // Add loading state
  List<MonthlySummary>? monthlyData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    DateTime now = DateTime.now();
    selectedYear = now;
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
    if (selectedYear == null) return;

    if (mounted) {
      setState(() {
        isLoading = true; // Set loading state to true
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
          '${Config.apiUrl}/summaryyear?selected_year=${DateFormat('yyyy').format(selectedYear!)}'
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
          final summaryMonthly = responseData['data']['monthly_summary'];

          print('Summary Data: $summaryData');

          if (mounted) {
            setState(() {
              summary = SummaryMonthData.fromJson(summaryData);
              monthlyData = summaryMonthly is List
                ? summaryMonthly.map((monthly) => MonthlySummary.fromJson(monthly)).toList()
                : [];
              isLoading = false; // Set loading state to false
            });
          }
        } else if (responseData['status'] == 'error') {
          print('Error status: ${responseData['message']}');
          if (mounted) {
            setState(() {
              summary = SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0);
              monthlyData = [];
              isLoading = false; // Set loading state to false
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

  void onYearSelected(DateTime? newYear) {
    setState(() {
      selectedYear = newYear;
    });
    fetchTransactions(); // Fetch transactions after setting the selected month
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    print('SelectMonth: $selectedYear');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 243, 152, 33).withOpacity(0.2),
              padding: const EdgeInsets.all(10),
              child: YearPickerWidget(
                selectedMonth: selectedYear,
                onYearSelected: onYearSelected,
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                : Container(
                    child: Center(
                      child: SummaryMonthWidget(
                        summary: summary ?? SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0),
                      ),
                    ),
                  ),
            Container(
              color: const Color.fromARGB(255, 243, 33, 72).withOpacity(0.2),
              padding: const EdgeInsets.all(10),
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
                child: Column(
                  children: [
                    monthlyData != null && monthlyData!.isNotEmpty
                        ? Container(
                            height: 300, // Set a fixed height for the chart
                            padding: const EdgeInsets.all(10.0),
                            child: SfCartesianChart(
                              tooltipBehavior: TooltipBehavior(enable: true),
                              zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true, // Enable zooming
                                enablePanning: true, // Enable panning
                                zoomMode: ZoomMode.x, // Enable zooming along X-axis
                              ),
                              primaryXAxis: CategoryAxis(
                                labelRotation: 90, // Rotate labels if needed
                                // title: AxisTitle(text: 'Month'), 
                              ),
                              primaryYAxis: NumericAxis(
                                numberFormat: NumberFormat.compact(), // Format y-axis values in compact form (e.g., 1k)
                                // title: AxisTitle(text: 'Amount'), 
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<MonthlySummary, String>(
                                  dataSource: monthlyData!,
                                  xValueMapper: (MonthlySummary data, _) => monthNumberToAbbreviation(data.month),
                                  yValueMapper: (MonthlySummary data, _) => data.income,
                                  name: 'Income',
                                  color: Color.fromARGB(255, 96, 194, 148),
                                ),
                                ColumnSeries<MonthlySummary, String>(
                                  dataSource: monthlyData!,
                                  xValueMapper: (MonthlySummary data, _) => monthNumberToAbbreviation(data.month),
                                  yValueMapper: (MonthlySummary data, _) => data.expense,
                                  name: 'Expense',
                                  color: Color.fromARGB(255, 194, 96, 107),
                                ),
                                ColumnSeries<MonthlySummary, String>(
                                  dataSource: monthlyData!,
                                  xValueMapper: (MonthlySummary data, _) => monthNumberToAbbreviation(data.month),
                                  yValueMapper: (MonthlySummary data, _) => data.balance,
                                  name: 'Balance',
                                  color: Color.fromARGB(255, 113, 191, 255),
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No Data This Year',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                    if (monthlyData != null && monthlyData!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.5), // Adjust column width as needed
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Month',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Income',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Expense',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Balance',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...(monthlyData?.map((data) {
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${DateFormat('MMMM').format(DateTime(2024, data.month))}',
                                        style: const TextStyle(
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
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 154, 154, 154),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${data.expense}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 154, 154, 154),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${data.balance}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(255, 154, 154, 154),
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
    );
  }
}
