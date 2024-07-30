import 'dart:convert';

import 'package:bechan/config.dart';
import 'package:bechan/page/login.dart';
import 'package:bechan/widget/month_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model_data/api_summarymonth.dart';
import '../widget/summaryMonth_widget.dart';
import '../widget/year_picker.dart';

class SummaryYear extends StatefulWidget {
  @override
  _SummaryYearState createState() => _SummaryYearState();
}

class _SummaryYearState extends State<SummaryYear> {
  Map<String, dynamic>? _userData;
  SummaryMonthData? summary;
  DateTime? selectedYear;
  bool isLoading = false; // Add loading state

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

    if (token == null) {
      _navigateToLogin();
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
        if (mounted){
          setState(() {
            _userData = responseData;
            isLoading = false;
          });
        }
      } else if (responseData['status'] == 'error') {
        _navigateToLogin();
      }
    } else {
      _navigateToLogin();
    }
  } catch (e) {
    _navigateToLogin();
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
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
      _navigateToLogin();
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

        print('Summary Data: $summaryData');

      if (mounted) {
        setState(() {
          summary = SummaryMonthData.fromJson(summaryData);
          isLoading = false; // Set loading state to false
        });
      }
      } else if (responseData['status'] == 'error') {
        if (mounted) {
        setState(() {
          summary = SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0);
          isLoading = false; // Set loading state to false
        });
      }
    }
    } else {
      _navigateToLogin();
    }
  } catch (e) {
    _navigateToLogin();
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
  }

  @override
  Widget build(BuildContext context) {
    print('SelectMonth: $selectedYear');
    return Scaffold(
      body: Column(
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
              ? Center(child: CircularProgressIndicator()) // Show loading indicator
              : Container(
                  child: Center(
                    child: SummaryMonthWidget(
                      summary: summary ?? SummaryMonthData(totalIncome: 0, totalExpense: 0, balance: 0),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
