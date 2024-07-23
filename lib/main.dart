import 'package:bechan/page/home.dart';
import 'package:bechan/page/router_page.dart';
import 'package:flutter/material.dart';
import '/page/router_page.dart'; // นำเข้าคลาส MainPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(), 
    );
  }
}
