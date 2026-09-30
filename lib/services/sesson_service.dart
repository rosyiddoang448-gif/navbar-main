import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Simpen Session
  // static untuk bisa mengakses method dari luar
  static Future<void> login(String username) async {
    // membuat objek shared preference
    final prefs = await SharedPreferences.getInstance();
    // mengatur user sudah login
    // dipakai nanti untuk menentukan login (islogin ? home: login)
    await prefs.setBool('islogin', true);
    // menyimpan akun
    await prefs.setString('username', username);
    // await prefs.setString('password', pass);
    // await prefs.setString('alamat', address);
    // await prefs.setString('nohp', hp);
  }

  // Cek sudah login atau belum
  // ✅ FIX: return type diubah dari Future<void> menjadi Future<bool>
  static Future<bool> islogin() async {
    final prefs = await SharedPreferences.getInstance();

    // cek apakah sudah login
   //?? berfungsi untuk jika null maka akan mengambil falce
    return prefs.getBool('islogin') ?? false;
  }

  // Ambil username yang tersimpan
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  // Logout - hapus semua data sesi
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    //hapus data session
    await prefs.remove('islogin');
    await prefs.remove('username');
  }
}