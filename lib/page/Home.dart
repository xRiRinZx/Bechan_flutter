import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateTime
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // DatePicker
import '/widget/date_picker.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String day = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    String year = DateFormat('yyyy').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
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
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // เพิ่ม padding รอบเนื้อหา
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'images/user.jpg', // ใส่ URL ของรูปที่ต้องการ
                                width: 50, // ขนาดเส้นผ่านศูนย์กลางของวงกลม
                                height: 50, // ขนาดเส้นผ่านศูนย์กลางของวงกลม
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 15, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      'Welcome',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 12, 
                                      ),
                                    ),
                                  Text(
                                      'back!',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 12, 
                                      ),
                                    ),
                                ],
                              ),
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
                      height: 100,
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
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0), 
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Month Text
                                    Text(
                                      month,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20, 
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0), 
                                      child: Text(
                                        year,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 22, 
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
          // เพิ่มปุ่มที่เรียกใช้ DatePickerWidget
          Container(
                color: const Color.fromARGB(255, 243, 152, 33).withOpacity(0.2),
                padding: const EdgeInsets.all(10.0),
                child: DatePickerWidget(),
          ),
        ],
      ),
      
    );
  }
}
