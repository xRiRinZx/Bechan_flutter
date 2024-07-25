import 'dart:convert';
import 'package:bechan/page/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // DateTime
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // DatePicker
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _navigateToLogin();
      return; // No token, return early
    }

    final response = await http.get(
      Uri.parse('${Config.apiUrl}/user'), // ปรับ URL ตามที่ใช้
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
    } else if (responseData['status'] == 'error'){
      _navigateToLogin();
    }
  } else 
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
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
                    color: Colors.blue.withOpacity(0.2), // สีพื้นหลังของแถว
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // เพิ่ม padding รอบ Row
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // กระจายเนื้อหาให้ห่างเท่าๆ กัน
                        children: [
                          //=====User======
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3), // สีเงา
                                    offset: const Offset(0, 4), // ตำแหน่งเงา
                                    blurRadius: 8, // ระยะการเบลอของเงา
                                  ),
                                ],
                              ),
                              height: 90,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0), // เพิ่ม padding รอบเนื้อหา
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_userData != null && _userData!['data'] != null && _userData!['data']['user'] != null)
                                      ClipOval(
                                        child: Image.network(
                                          '${Config.apiUrl}/${_userData!['data']['user']['profile_path']}', // ใส่ URL ของรูปที่ต้องการ
                                          width: 50, // ขนาดเส้นผ่านศูนย์กลางของวงกลม
                                          height: 50, // ขนาดเส้นผ่านศูนย์กลางของวงกลม
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
                    child: DatePickerWidget(),
                  ),
                  //===============================
                  Center(
                    child: SummaryWidget(),
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
                        //======================================
                        child: ListView(
                          children: [
                            //รอใส่listview
                            TransactionList(),
                            TransactionList(),
                            
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
