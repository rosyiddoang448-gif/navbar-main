import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // Simpen Session login
  static Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('islogin', true);
    await prefs.setString('username', username);
    if (!prefs.containsKey('user_name') || (prefs.getString('user_name') ?? '').isEmpty) {
      await prefs.setString('user_name', username);
    }
  }

  // Cek sudah login atau belum
  static Future<bool> islogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('islogin') ?? false;
  }

  // Ambil username yang tersimpan
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null && name.isNotEmpty) return name;
    return prefs.getString('username') ?? 'MUHAMMAD Rosyid';
  }

  // Logout - hapus sesi login (namun data profil dan alamat tersimpan)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('islogin');
  }

  // ── USER PROFILE ──
  static Future<Map<String, String>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final usernameFallback = prefs.getString('username') ?? 'MUHAMMAD Rosyid';

    return {
      'name': prefs.getString('user_name') ?? usernameFallback,
      'email': prefs.getString('user_email') ?? 'rosyid@belanjamart.id',
      'phone': prefs.getString('user_phone') ?? '0812-3456-7890',
      'gender': prefs.getString('user_gender') ?? 'Laki-laki',
      'birthdate': prefs.getString('user_birthdate') ?? '24 Agustus 2003',
      'bio': prefs.getString('user_bio') ?? 'Member setia BelanjaMart sejak 2024 ✨',
      'membership': prefs.getString('user_membership') ?? 'Member Platinum • BelanjaMart',
    };
  }

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String birthdate,
    required String bio,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('username', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    await prefs.setString('user_gender', gender);
    await prefs.setString('user_birthdate', birthdate);
    await prefs.setString('user_bio', bio);
  }

  // ── PROFILE IMAGE (Base64) ──
  static Future<String?> getProfileImageBase64() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image_base64');
  }

  static Future<void> saveProfileImageBase64(String base64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_base64', base64);
  }

  static Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_base64');
  }

  // ── ALAMAT PENGIRIMAN ──
  static List<Map<String, dynamic>> defaultAddresses = [
    {
      'id': 'addr_1',
      'label': 'Rumah',
      'recipient': 'MUHAMMAD Rosyid',
      'phone': '0812-3456-7890',
      'street': 'Jl. Mawar No. 12, RT 03/RW 05, Menteng',
      'city': 'Jakarta Pusat',
      'postalCode': '10350',
      'isDefault': true,
    },
    {
      'id': 'addr_2',
      'label': 'Kantor',
      'recipient': 'MUHAMMAD Rosyid (Admin BelanjaMart)',
      'phone': '0812-9876-5432',
      'street': 'Cyber Tower Lt. 5, Jl. H.R. Rasuna Said Kav. X-5',
      'city': 'Jakarta Selatan',
      'postalCode': '12950',
      'isDefault': false,
    },
  ];

  static Future<List<Map<String, dynamic>>> getAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user_addresses');
    if (jsonStr == null || jsonStr.isEmpty) {
      // Simpan default awal
      await saveAddresses(defaultAddresses);
      return List<Map<String, dynamic>>.from(defaultAddresses);
    }
    try {
      final decoded = jsonDecode(jsonStr) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return List<Map<String, dynamic>>.from(defaultAddresses);
    }
  }

  static Future<void> saveAddresses(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_addresses', jsonEncode(list));
  }

  // ── PENGATURAN APLIKASI ──
  static Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('app_settings');
    if (jsonStr == null || jsonStr.isEmpty) {
      return {
        'orderNotif': true,
        'promoNotif': true,
        'soundVibrate': true,
        'biometric': false,
        'language': 'Bahasa Indonesia',
        'cacheSize': '24.8 MB',
      };
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(jsonStr) as Map);
    } catch (_) {
      return {
        'orderNotif': true,
        'promoNotif': true,
        'soundVibrate': true,
        'biometric': false,
        'language': 'Bahasa Indonesia',
        'cacheSize': '24.8 MB',
      };
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', jsonEncode(settings));
  }
}