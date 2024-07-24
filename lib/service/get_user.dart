import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:bechan/page/home.dart';
import 'package:bechan/page/login.dart'; // นำเข้าคลาส Login
import 'package:bechan/config.dart';

Future<bool> checkUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    return false; // ไม่มี token
  }

  final response = await http.get(
    Uri.parse('${Config.apiUrl}/user'), // ปรับ URL ตามที่ใช้
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('User successfully retrieved');
    return true; // สามารถดึงข้อมูลผู้ใช้ได้
  } else {
    print('Failed to retrieve user data');
    return false; // การดึงข้อมูลผู้ใช้ล้มเหลว
  }
}
