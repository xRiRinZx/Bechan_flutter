import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // นำเข้าหน้าจอ Login

class Menu extends StatelessWidget {
  // ฟังก์ชันสำหรับทำการ logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // ลบ token ออกจาก SharedPreferences

    // นำผู้ใช้กลับไปที่หน้า Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Menu Content'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context), // เรียกใช้ฟังก์ชัน logout เมื่อกดปุ่ม
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
