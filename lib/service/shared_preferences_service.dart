import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // ฟังก์ชันสำหรับเก็บ token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // ฟังก์ชันสำหรับอ่าน token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ฟังก์ชันสำหรับลบ token
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
