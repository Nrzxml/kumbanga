import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  static const String baseUrl = 'http://10.0.2.2/kumbanga_api/';

  /// 🔹 LOGIN
  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}login.php'),
        body: {'email': email, 'password': password},
      );

      final data = json.decode(response.body);
      _isLoading = false;

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = User(
          id: data['user']['id'].toString(),
          fullName: data['user']['name'],
          email: data['user']['email'],
          phone: data['user']['phone'],
          role: data['user']['role'],
          createdAt: DateTime.now(),
          lastCheckIn: DateTime.now(),
        );

        // ✅ Simpan userId ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', data['user']['id'].toString());
        debugPrint("✅ userId disimpan setelah login: ${data['user']['id']}");

        notifyListeners();
        return {
          'success': true,
          'user': data['user'],
          'message': data['message'] ?? 'Login berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      debugPrint("Login error: $e");
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  /// 🔹 REGISTER
  Future<Map<String, dynamic>> register(
      String fullName, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}register.php'),
        body: {
          'name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      final data = json.decode(response.body);
      _isLoading = false;

      if (response.statusCode == 200 && data['success'] == true) {
        _currentUser = User(
          id: data['user']['id'].toString(),
          fullName: data['user']['name'],
          email: data['user']['email'],
          phone: data['user']['phone'],
          role: data['user']['role'],
          createdAt: DateTime.now(),
          lastCheckIn: DateTime.now(),
        );

        // ✅ Simpan userId ke SharedPreferences juga setelah register
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', data['user']['id'].toString());
        debugPrint("✅ userId disimpan setelah register: ${data['user']['id']}");

        notifyListeners();
        return {
          'success': true,
          'user': data['user'],
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      debugPrint("Register error: $e");
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'Terjadi kesalahan koneksi: $e',
      };
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // 🧹 hapus saat logout
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
