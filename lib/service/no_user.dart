import 'package:flutter/material.dart';

import '../page/login.dart'; // แก้ไขเส้นทางนี้ตามที่เหมาะสม

void navigateToLogin(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
}
