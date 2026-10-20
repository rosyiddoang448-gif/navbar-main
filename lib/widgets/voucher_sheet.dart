import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/cart_page.dart';

class VoucherBottomSheet extends StatelessWidget {
  const VoucherBottomSheet({super.key});

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  static final List<Map<String, dynamic>> vouchers = [
    {
      'code': 'DISKON50',
      'title': 'Diskon 50% Pengguna Baru',
      'desc': 'Min. belanja Rp 40.000 • Maks. potongan Rp 25.000',
      'validUntil': '31 Des 2026',
      'color': primaryOrange,
      'tag': 'Spesial Baru',
    },
    {
      'code': 'FREEONGKIR',
      'title': 'Gratis Ongkos Kirim',
      'desc': 'Min. belanja Rp 30.000 • Potongan ongkir s/d Rp 20.000',
      'validUntil': '28 Feb 2027',
      'color': Colors.green.shade600,
      'tag': 'Paling Laris',
    },
    {
      'code': 'HEMAT30',
      'title': 'Cashback 30% Koin Mart',
      'desc': 'Min. belanja Rp 100.000 • Maks. koin 30.000',
      'validUntil': '15 Nov 2026',
      'color': primaryPurple,
      'tag': 'Cashback',
    },
    {
      'code': 'GAJIAN50',
      'title': 'Kupon Gajian Rp 50.000',
      'desc': 'Min. belanja Rp 200.000 • Untuk semua produk',
      'validUntil': '05 Nov 2026',
      'color': Colors.deepOrange,
      'tag': 'Payday',
    },
    {
      'code': 'WEEKEND15',
      'title': 'Diskon Weekend 15%',
      'desc': 'Berlaku setiap Sabtu & Minggu • Semua kategori',
      'validUntil': '31 Des 2026',
      'color': Colors.teal,
      'tag': 'Weekend',
    },
  ];

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoucherBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.confirmation_number_outlined, color: primaryOrange, size: 22),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voucher & Promo Saya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    Text(
                      '5 Kupon aktif tersedia untuk belanja hemat',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final v = vouchers[index];
                final Color color = v['color'] as Color;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left banner
                      Container(
                        width: 90,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.discount_rounded, color: color, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              v['tag'] as String,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                v['desc'] as String,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    's/d ${v['validUntil']}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: v['code'] as String));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Kode kupon "${v['code']}" berhasil disalin!'),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: primaryOrange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Salin Kode',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                child: const Text(
                  'Gunakan Voucher di Keranjang',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
