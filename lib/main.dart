import 'package:bechan/page/router_page.dart';
import 'package:flutter/material.dart';
import '/page/login.dart';
import 'package:bechan/service/get_user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: checkUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // โหลดข้อมูล
          } else if (snapshot.hasData) {
            if (snapshot.data == true) {
              print('Navigating to MainPage');
              return MainPage(); // มี token และสามารถดึงข้อมูลผู้ใช้ได้
            } else {
              print('Navigating to Login');
              return Login(); // ไม่มี token หรือไม่สามารถดึงข้อมูลผู้ใช้ได้
            }
          } else {
            print('Error occurred');
            return Login(); // แสดงหน้า Login หากมีข้อผิดพลาด
          }
        },
      ),
    );
  }
}


