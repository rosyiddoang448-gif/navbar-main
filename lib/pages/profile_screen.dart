import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/dummy/dummy_cart.dart';
import '../data/dummy/dummy_teransaksi.dart';
import '../services/session_service.dart';
import '../widgets/voucher_sheet.dart';
import 'app_settings_screen.dart';
import 'cart_page.dart';
import 'edit_profile_screen.dart';
import 'help_center_screen.dart';
import 'shipping_addresses_screen.dart';
import 'transactions_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'MUHAMMAD Rosyid';
  String _membership = 'Member Platinum • BelanjaMart';
  Uint8List? _profileImageBytes;
  bool _isLoading = true;

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  // Mengambil data user dan foto dari session / SharedPreferences
  Future<void> loadUserData() async {
    final profile = await SessionService.getUserProfile();
    final imgBase64 = await SessionService.getProfileImageBase64();

    Uint8List? decodedBytes;
    if (imgBase64 != null && imgBase64.isNotEmpty) {
      try {
        decodedBytes = base64Decode(imgBase64);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _username = profile['name']?.isNotEmpty == true ? profile['name']! : 'MUHAMMAD Rosyid';
      _membership = profile['membership'] ?? 'Member Platinum • BelanjaMart';
      _profileImageBytes = decodedBytes;
      _isLoading = false;
    });
  }

  // Logout dengan konfirmasi
  void logout() async {
    await SessionService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Fungsi untuk mengganti foto dari galeri atau kamera
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64String = base64Encode(bytes);
        await SessionService.saveProfileImageBase64(base64String);

        if (!mounted) return;
        setState(() {
          _profileImageBytes = bytes;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Foto profil berhasil diperbarui!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengganti foto: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Modal pemilihan sumber foto (Kamera, Galeri, Hapus Foto)
  void _showImagePickerSheet() {
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
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ganti Foto Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih sumber foto yang ingin Anda gunakan',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: primaryOrange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryOrange.withValues(alpha: 0.25)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.camera_alt_rounded, color: primaryOrange, size: 28),
                          SizedBox(height: 8),
                          Text(
                            'Kamera',
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryOrange),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: primaryPurple.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryPurple.withValues(alpha: 0.25)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.photo_library_rounded, color: primaryPurple, size: 28),
                          SizedBox(height: 8),
                          Text(
                            'Galeri',
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryPurple),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_profileImageBytes != null) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text('Hapus Foto Profil'),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(context);
                    await SessionService.removeProfileImage();
                    setState(() {
                      _profileImageBytes = null;
                    });
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Foto profil berhasil dihapus'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Dialog Informasi Tentang Aplikasi
  void _showAboutAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(colors: [primaryOrange, primaryPurple]),
                boxShadow: [
                  BoxShadow(
                    color: primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'BelanjaMart Mobile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Versi 1.0.0 (Build 2026)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Aplikasi e-commerce modern, cepat, dan terpercaya untuk memenuhi seluruh kebutuhan belanja Anda setiap hari.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pengembang', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const Text('MUHAMMAD Rosyid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Framework', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const Text('Flutter & Dart (M3)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryPurple,
                    side: const BorderSide(color: primaryPurple),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Terima kasih atas penilaian bintang 5 Anda! ⭐⭐⭐⭐⭐'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Beri Rating ⭐', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final totalCartItems = cartItems.fold<int>(0, (sum, item) => sum + item.jumlah);
    final totalTransactions = transactions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 19),
        ),
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
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Konfirmasi Logout'),
                    ],
                  ),
                  content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        logout();
                      },
                      child: const Text('Ya, Keluar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  // Header Profil dengan Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryOrange, primaryPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              child: CircleAvatar(
                                radius: 52,
                                backgroundColor: Colors.white,
                                backgroundImage: _profileImageBytes != null
                                    ? MemoryImage(_profileImageBytes!)
                                    : const AssetImage('assets/images/app_icon.png') as ImageProvider,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: _showImagePickerSheet,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: primaryOrange,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _membership,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Kartu Ringkasan Aktivitas (Quick Stats)
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickStat(
                              icon: Icons.shopping_cart_outlined,
                              color: primaryOrange,
                              label: 'Keranjang',
                              value: '$totalCartItems Item',
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CartPage()),
                                );
                                if (mounted) setState(() {});
                              },
                            ),
                            Container(height: 36, width: 1, color: Colors.grey.shade200),
                            _buildQuickStat(
                              icon: Icons.receipt_long_outlined,
                              color: primaryPurple,
                              label: 'Transaksi',
                              value: '$totalTransactions Pesanan',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TransactionsScreen()),
                                );
                              },
                            ),
                            Container(height: 36, width: 1, color: Colors.grey.shade200),
                            _buildQuickStat(
                              icon: Icons.confirmation_number_outlined,
                              color: Colors.green.shade600,
                              label: 'Voucher',
                              value: '5 Kupon',
                              onTap: () {
                                VoucherBottomSheet.show(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bagian Menu Navigasi Profil
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Akun & Preferensi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildProfileMenuItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Edit Profil Pengguna',
                          subtitle: 'Ubah nama, email, dan nomor telepon',
                          onTap: () async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                            if (res == true || mounted) {
                              loadUserData();
                            }
                          },
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Alamat Pengiriman',
                          subtitle: 'Kelola alamat rumah dan kantor',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ShippingAddressesScreen()),
                            );
                          },
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Pengaturan Aplikasi',
                          subtitle: 'Notifikasi, keamanan, dan bahasa',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AppSettingsScreen()),
                            );
                          },
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Pusat Bantuan & CS',
                          subtitle: 'FAQ dan layanan bantuan 24 jam',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                            );
                          },
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.info_outline_rounded,
                          title: 'Tentang Aplikasi',
                          subtitle: 'BelanjaMart Mobile v1.0.0',
                          onTap: _showAboutAppDialog,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryPurple, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xFF1E1B4B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 22,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }
}