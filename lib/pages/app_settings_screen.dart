import 'package:flutter/material.dart';
import '../services/session_service.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _orderNotif = true;
  bool _promoNotif = true;
  bool _soundVibrate = true;
  bool _biometric = false;
  String _language = 'Bahasa Indonesia';
  String _cacheSize = '24.8 MB';
  bool _isLoading = true;

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SessionService.getSettings();
    if (!mounted) return;
    setState(() {
      _orderNotif = settings['orderNotif'] ?? true;
      _promoNotif = settings['promoNotif'] ?? true;
      _soundVibrate = settings['soundVibrate'] ?? true;
      _biometric = settings['biometric'] ?? false;
      _language = settings['language'] ?? 'Bahasa Indonesia';
      _cacheSize = settings['cacheSize'] ?? '24.8 MB';
      _isLoading = false;
    });
  }

  Future<void> _saveCurrentSettings() async {
    await SessionService.saveSettings({
      'orderNotif': _orderNotif,
      'promoNotif': _promoNotif,
      'soundVibrate': _soundVibrate,
      'biometric': _biometric,
      'language': _language,
      'cacheSize': _cacheSize,
    });
  }

  void _showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureOld = true;
    bool obscureNew = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.lock_reset_rounded, color: primaryOrange),
              SizedBox(width: 8),
              Text('Ubah Kata Sandi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPassCtrl,
                    obscureText: obscureOld,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Saat Ini',
                      hintText: 'Default demo: 12345',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: () => setDialogState(() => obscureOld = !obscureOld),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPassCtrl,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi Baru',
                      prefixIcon: const Icon(Icons.vpn_key_outlined, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                      ),
                    ),
                    validator: (v) {
                      if (v!.length < 5) return 'Minimal 5 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPassCtrl,
                    obscureText: obscureNew,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Sandi Baru',
                      prefixIcon: Icon(Icons.check_circle_outline, size: 20),
                    ),
                    validator: (v) {
                      if (v != newPassCtrl.text) return 'Kata sandi tidak cocok';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kata sandi berhasil diperbarui!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pilih Bahasa Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
              title: const Text('Bahasa Indonesia', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: _language == 'Bahasa Indonesia'
                  ? const Icon(Icons.check_circle, color: primaryOrange)
                  : null,
              onTap: () {
                setState(() => _language = 'Bahasa Indonesia');
                _saveCurrentSettings();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English (US)', style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: _language == 'English (US)'
                  ? const Icon(Icons.check_circle, color: primaryOrange)
                  : null,
              onTap: () {
                setState(() => _language = 'English (US)');
                _saveCurrentSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cleaning_services_rounded, color: primaryPurple),
            SizedBox(width: 8),
            Text('Bersihkan Cache'),
          ],
        ),
        content: Text('Apakah Anda ingin menghapus file sampah dan cache aplikasi sebesar $_cacheSize?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              setState(() {
                _cacheSize = '0 KB';
              });
              await _saveCurrentSettings();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Cache aplikasi berhasil dibersihkan!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Bersihkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Pengaturan Aplikasi',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryOrange,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryOrange, primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── SECTION NOTIFIKASI ──
                  _sectionHeader('Notifikasi & Pesan'),
                  _settingsCard([
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryOrange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_shipping_outlined, color: primaryOrange, size: 20),
                      ),
                      title: const Text('Status Pesanan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Pemberitahuan perubahan status pengiriman', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      value: _orderNotif,
                      onChanged: (v) {
                        setState(() => _orderNotif = v);
                        _saveCurrentSettings();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryOrange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.discount_outlined, color: primaryPurple, size: 20),
                      ),
                      title: const Text('Promo & Diskon', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Update penawaran kilat dan voucher harian', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      value: _promoNotif,
                      onChanged: (v) {
                        setState(() => _promoNotif = v);
                        _saveCurrentSettings();
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryOrange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.volume_up_outlined, color: Colors.teal, size: 20),
                      ),
                      title: const Text('Suara & Getar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Efek suara saat ada notifikasi masuk', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      value: _soundVibrate,
                      onChanged: (v) {
                        setState(() => _soundVibrate = v);
                        _saveCurrentSettings();
                      },
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── SECTION KEAMANAN ──
                  _sectionHeader('Keamanan Akun'),
                  _settingsCard([
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryOrange,
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.fingerprint_rounded, color: Colors.blue, size: 20),
                      ),
                      title: const Text('Kunci Biometrik / PIN', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Minta verifikasi sidik jari saat membuka aplikasi', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      value: _biometric,
                      onChanged: (v) {
                        setState(() => _biometric = v);
                        _saveCurrentSettings();
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.lock_reset_rounded, color: Colors.orange, size: 20),
                      ),
                      title: const Text('Ubah Kata Sandi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Perbarui kata sandi login Anda secara berkala', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      onTap: _showChangePasswordDialog,
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── SECTION UMUM & PREFERENSI ──
                  _sectionHeader('Preferensi Aplikasi'),
                  _settingsCard([
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.language_rounded, color: primaryPurple, size: 20),
                      ),
                      title: const Text('Bahasa', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text(_language, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      onTap: _showLanguageSelector,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.cleaning_services_outlined, color: Colors.red, size: 20),
                      ),
                      title: const Text('Bersihkan Cache', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('Ukuran cache saat ini: $_cacheSize', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      trailing: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: primaryPurple,
                          side: const BorderSide(color: primaryPurple),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _clearCache,
                        child: const Text('Bersihkan', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E1B4B),
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}
