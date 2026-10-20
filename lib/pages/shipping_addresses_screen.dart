import 'package:flutter/material.dart';
import '../services/session_service.dart';

class ShippingAddressesScreen extends StatefulWidget {
  const ShippingAddressesScreen({super.key});

  @override
  State<ShippingAddressesScreen> createState() => _ShippingAddressesScreenState();
}

class _ShippingAddressesScreenState extends State<ShippingAddressesScreen> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final list = await SessionService.getAddresses();
    if (!mounted) return;
    setState(() {
      _addresses = list;
      _isLoading = false;
    });
  }

  Future<void> _saveAndRefresh(List<Map<String, dynamic>> list) async {
    await SessionService.saveAddresses(list);
    setState(() {
      _addresses = list;
    });
  }

  void _setDefaultAddress(String id) {
    final updated = _addresses.map((item) {
      return {
        ...item,
        'isDefault': item['id'] == id,
      };
    }).toList();

    _saveAndRefresh(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alamat utama berhasil diperbarui'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteAddress(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Alamat'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin menghapus alamat pengiriman ini?'),
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
              final updated = _addresses.where((item) => item['id'] != id).toList();
              // Jika yang dihapus default dan masih ada alamat lain, jadikan yg pertama default
              if (updated.isNotEmpty && !updated.any((a) => a['isDefault'] == true)) {
                updated[0]['isDefault'] = true;
              }
              _saveAndRefresh(updated);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alamat berhasil dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog({Map<String, dynamic>? existingAddress}) {
    final isEditing = existingAddress != null;

    final labelCtrl = TextEditingController(text: existingAddress?['label'] ?? 'Rumah');
    final recipientCtrl = TextEditingController(text: existingAddress?['recipient'] ?? 'MUHAMMAD Rosyid');
    final phoneCtrl = TextEditingController(text: existingAddress?['phone'] ?? '0812-3456-7890');
    final streetCtrl = TextEditingController(text: existingAddress?['street'] ?? '');
    final cityCtrl = TextEditingController(text: existingAddress?['city'] ?? 'Jakarta Barat');
    final postalCtrl = TextEditingController(text: existingAddress?['postalCode'] ?? '11530');
    bool isDefault = existingAddress?['isDefault'] ?? (_addresses.isEmpty);

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
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
                    Text(
                      isEditing ? 'Ubah Alamat Pengiriman' : 'Tambah Alamat Baru',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pastikan alamat pengiriman lengkap agar kurir mudah menemukan lokasi',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),

                    // Label Alamat (Pilihan Cepat)
                    const Text(
                      'Label Alamat',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Rumah', 'Kantor', 'Apartemen', 'Kos'].map((lbl) {
                        final isSel = labelCtrl.text == lbl;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lbl),
                            selected: isSel,
                            selectedColor: primaryPurple.withValues(alpha: 0.15),
                            labelStyle: TextStyle(
                              color: isSel ? primaryPurple : Colors.grey.shade700,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: isSel ? primaryPurple : Colors.grey.shade300,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setModalState(() {
                                  labelCtrl.text = lbl;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Penerima & No HP
                    Row(
                      children: [
                        Expanded(
                          child: _modalInput(
                            controller: recipientCtrl,
                            label: 'Nama Penerima',
                            icon: Icons.person_outline,
                            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _modalInput(
                            controller: phoneCtrl,
                            label: 'Nomor Telepon',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Alamat Lengkap
                    _modalInput(
                      controller: streetCtrl,
                      label: 'Alamat Lengkap & Patokan',
                      hint: 'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validator: (v) => v!.isEmpty ? 'Alamat lengkap wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // Kota & Kode Pos
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _modalInput(
                            controller: cityCtrl,
                            label: 'Kota / Kabupaten',
                            icon: Icons.location_city_outlined,
                            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: _modalInput(
                            controller: postalCtrl,
                            label: 'Kode Pos',
                            icon: Icons.markunread_mailbox_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Wajib' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Jadikan Alamat Utama Switch
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: primaryOrange,
                      title: const Text(
                        'Jadikan sebagai Alamat Utama',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      value: isDefault,
                      onChanged: (val) {
                        setModalState(() {
                          isDefault = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          final newAddress = {
                            'id': isEditing ? existingAddress['id'] : 'addr_${DateTime.now().millisecondsSinceEpoch}',
                            'label': labelCtrl.text.trim(),
                            'recipient': recipientCtrl.text.trim(),
                            'phone': phoneCtrl.text.trim(),
                            'street': streetCtrl.text.trim(),
                            'city': cityCtrl.text.trim(),
                            'postalCode': postalCtrl.text.trim(),
                            'isDefault': isDefault,
                          };

                          List<Map<String, dynamic>> updated = List.from(_addresses);
                          if (isEditing) {
                            final idx = updated.indexWhere((a) => a['id'] == newAddress['id']);
                            if (idx != -1) updated[idx] = newAddress;
                          } else {
                            updated.add(newAddress);
                          }

                          if (isDefault) {
                            updated = updated.map((a) {
                              return {
                                ...a,
                                'isDefault': a['id'] == newAddress['id'],
                              };
                            }).toList();
                          }

                          Navigator.pop(context);
                          _saveAndRefresh(updated);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEditing ? 'Alamat berhasil diperbarui' : 'Alamat baru berhasil ditambahkan'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Text(
                          isEditing ? 'Simpan Perubahan' : 'Tambahkan Alamat',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _modalInput({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B)),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: Icon(icon, size: 18, color: primaryPurple),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Alamat Pengiriman',
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
            icon: const Icon(Icons.add_location_alt_rounded),
            label: const Text(
              'Tambah Alamat Baru',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onPressed: () => _showAddressDialog(),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryOrange))
          : _addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined, size: 70, color: Colors.grey.shade400),
                      const SizedBox(height: 14),
                      const Text(
                        'Belum Ada Alamat Tersimpan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tambahkan alamat pengiriman Anda sekarang',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    final item = _addresses[index];
                    final isDefault = item['isDefault'] == true;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDefault ? primaryOrange : Colors.grey.shade200,
                          width: isDefault ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Label & Badges
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryPurple.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['label'] ?? 'Rumah',
                                    style: const TextStyle(
                                      color: primaryPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryOrange.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Alamat Utama',
                                      style: TextStyle(
                                        color: primaryOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600, size: 20),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  onSelected: (val) {
                                    if (val == 'default') {
                                      _setDefaultAddress(item['id']);
                                    } else if (val == 'edit') {
                                      _showAddressDialog(existingAddress: item);
                                    } else if (val == 'delete') {
                                      _deleteAddress(item['id']);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (!isDefault)
                                      const PopupMenuItem(
                                        value: 'default',
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle_outline, size: 18, color: primaryOrange),
                                            SizedBox(width: 8),
                                            Text('Jadikan Utama'),
                                          ],
                                        ),
                                      ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 18, color: primaryPurple),
                                          SizedBox(width: 8),
                                          Text('Ubah Alamat'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Hapus', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Nama & HP
                            Text(
                              '${item['recipient']} • ${item['phone']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1E1B4B),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Alamat Jalan
                            Text(
                              '${item['street']}, ${item['city']} ${item['postalCode']}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Quick actions
                            Row(
                              children: [
                                if (!isDefault)
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      foregroundColor: primaryOrange,
                                      side: const BorderSide(color: primaryOrange),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _setDefaultAddress(item['id']),
                                    child: const Text('Atur Sebagai Utama', style: TextStyle(fontSize: 12)),
                                  ),
                                const Spacer(),
                                TextButton.icon(
                                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                  onPressed: () => _showAddressDialog(existingAddress: item),
                                  icon: const Icon(Icons.edit, size: 14, color: primaryPurple),
                                  label: const Text('Ubah', style: TextStyle(fontSize: 12, color: primaryPurple)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
