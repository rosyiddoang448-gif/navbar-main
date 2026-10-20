import 'package:flutter/material.dart';

class HalamanStatusTransaksi extends StatelessWidget {
  final String status;
  final String nama;
  final int harga;
  final String tanggal;
  final String foto;

  const HalamanStatusTransaksi({
    super.key,
    required this.status,
    required this.nama,
    required this.harga,
    required this.tanggal,
    this.foto = '',
  });

  String get statusNormal => status.toLowerCase().trim();

  // Format harga Rupiah
  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  // Warna halaman berdasarkan status
  Color get warnaStatus {
    switch (statusNormal) {
      case 'selesai':
        return const Color(0xFF10B981);
      case 'dikirim':
        return const Color(0xFF3B82F6);
      case 'dikemas':
        return const Color(0xFFF59E0B);
      case 'diproses':
        return const Color(0xFFF97316);
      case 'belum bayar':
        return const Color(0xFFEF4444);
      case 'dibatalkan':
        return const Color(0xFFEF4444);
      case 'pengembalian':
        return const Color(0xFF8B5CF6);
      default:
        return Colors.grey;
    }
  }

  // Ikon berdasarkan status
  IconData get ikonStatus {
    switch (statusNormal) {
      case 'belum bayar':
        return Icons.payment_rounded;
      case 'dikemas':
        return Icons.inventory_2_rounded;
      case 'diproses':
        return Icons.hourglass_top_rounded;
      case 'dikirim':
        return Icons.local_shipping_rounded;
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'dibatalkan':
        return Icons.cancel_rounded;
      case 'pengembalian':
        return Icons.assignment_return_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  // Pesan sesuai status
  String get pesanStatus {
    switch (statusNormal) {
      case 'belum bayar':
        return 'Pesanan menunggu pembayaran.\nSegera selesaikan pembayaran Anda.';
      case 'dikemas':
        return 'Pesanan sedang disiapkan oleh penjual.\nHarap menunggu proses pengemasan.';
      case 'diproses':
        return 'Pesanan sedang diproses oleh penjual.\nEstimasi pengiriman 1-2 hari.';
      case 'dikirim':
        return 'Pesanan sedang dalam perjalanan.\nPaket akan segera tiba di alamat Anda.';
      case 'selesai':
        return 'Pesanan telah diterima.\nTerima kasih sudah berbelanja!';
      case 'dibatalkan':
        return 'Pesanan ini telah dibatalkan.\nDana akan dikembalikan dalam 1-3 hari.';
      case 'pengembalian':
        return 'Pesanan sedang dalam proses pengembalian.\nTim kami akan segera memproses.';
      default:
        return 'Status transaksi tidak tersedia.';
    }
  }

  // Steps timeline
  List<Map<String, dynamic>> get timelineSteps {
    final allSteps = [
      {
        'label': 'Pesanan Dibuat',
        'icon': Icons.receipt_long_rounded,
      },
      {
        'label': 'Pembayaran',
        'icon': Icons.payment_rounded,
      },
      {
        'label': 'Diproses',
        'icon': Icons.hourglass_top_rounded,
      },
      {
        'label': 'Dikemas',
        'icon': Icons.inventory_2_rounded,
      },
      {
        'label': 'Dikirim',
        'icon': Icons.local_shipping_rounded,
      },
      {
        'label': 'Selesai',
        'icon': Icons.check_circle_rounded,
      },
    ];

    int currentStep;
    switch (statusNormal) {
      case 'belum bayar':
        currentStep = 1;
        break;
      case 'diproses':
        currentStep = 2;
        break;
      case 'dikemas':
        currentStep = 3;
        break;
      case 'dikirim':
        currentStep = 4;
        break;
      case 'selesai':
        currentStep = 5;
        break;
      case 'dibatalkan':
      case 'pengembalian':
        currentStep = -1; // special
        break;
      default:
        currentStep = 0;
    }

    for (int i = 0; i < allSteps.length; i++) {
      allSteps[i]['completed'] = i <= currentStep;
      allSteps[i]['isCurrent'] = i == currentStep;
    }

    return allSteps;
  }

  bool get isSpecialStatus =>
      statusNormal == 'dibatalkan' || statusNormal == 'pengembalian';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: CustomScrollView(
        slivers: [
          // Status Header
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            backgroundColor: warnaStatus,
            leading: Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      warnaStatus,
                      warnaStatus.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background circles
                    Positioned(
                      right: -40,
                      top: -20,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: 20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      bottom: 60,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),

                    // Status content
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated icon container
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration:
                                  const Duration(milliseconds: 800),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withValues(alpha: 0.12),
                                    ),
                                  ),
                                  Container(
                                    width: 76,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      ikonStatus,
                                      size: 30,
                                      color: warnaStatus,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40),
                              child: Text(
                                pesanStatus,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color:
                                      Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Timeline tracker (jika bukan status spesial)
                if (!isSpecialStatus)
                  Container(
                    margin:
                        const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: warnaStatus.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.timeline_rounded,
                                size: 18,
                                color: warnaStatus,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Status Pengiriman',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3D3027),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          timelineSteps.length,
                          (index) {
                            final step = timelineSteps[index];
                            final isCompleted =
                                step['completed'] as bool;
                            final isCurrent =
                                step['isCurrent'] as bool;
                            final isLast =
                                index == timelineSteps.length - 1;

                            return Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // Timeline line & dot
                                Column(
                                  children: [
                                    Container(
                                      width: isCurrent ? 28 : 22,
                                      height: isCurrent ? 28 : 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? warnaStatus
                                            : const Color(
                                                0xFFE8E0D8),
                                        border: isCurrent
                                            ? Border.all(
                                                color: warnaStatus
                                                    .withValues(alpha: 
                                                        0.3),
                                                width: 3,
                                              )
                                            : null,
                                        boxShadow: isCurrent
                                            ? [
                                                BoxShadow(
                                                  color: warnaStatus
                                                      .withValues(alpha: 
                                                          0.3),
                                                  blurRadius: 8,
                                                  offset:
                                                      const Offset(
                                                          0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Icon(
                                        isCompleted
                                            ? Icons.check_rounded
                                            : step['icon']
                                                as IconData,
                                        size: isCurrent ? 14 : 11,
                                        color: isCompleted
                                            ? Colors.white
                                            : const Color(
                                                0xFFBBB0A5),
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 30,
                                        margin:
                                            const EdgeInsets
                                                .symmetric(
                                                vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? warnaStatus
                                                  .withValues(alpha: 0.4)
                                              : const Color(
                                                  0xFFE8E0D8),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  1),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                // Label
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: isCurrent ? 4 : 2),
                                    child: Text(
                                      step['label'] as String,
                                      style: TextStyle(
                                        fontSize:
                                            isCurrent ? 14 : 13,
                                        fontWeight: isCurrent
                                            ? FontWeight.w700
                                            : isCompleted
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                        color: isCompleted
                                            ? const Color(
                                                0xFF3D3027)
                                            : const Color(
                                                0xFFB8A99E),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Informasi Produk
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFD4A574).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              size: 18,
                              color: Color(0xFFD4A574),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Detail Produk',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3D3027),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Produk card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF0EBE5),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Image
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(12),
                                child: foto.isNotEmpty
                                    ? Image.network(
                                        foto,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context,
                                            error, stackTrace) {
                                          return Container(
                                            color: const Color(
                                                0xFFF0EBE5),
                                            child: const Icon(
                                              Icons.image_rounded,
                                              color:
                                                  Color(0xFFCBC0B5),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color:
                                            const Color(0xFFF0EBE5),
                                        child: const Icon(
                                          Icons.image_rounded,
                                          color: Color(0xFFCBC0B5),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF3D3027),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4A574)
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '1 barang',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB8865E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Informasi Pesanan
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6)
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.receipt_rounded,
                              size: 18,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Informasi Pesanan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3D3027),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInfoRow(
                          Icons.calendar_today_rounded,
                          'Tanggal Transaksi',
                          tanggal),
                      _buildInfoRow(
                          Icons.info_outline_rounded,
                          'Status',
                          status,
                          valueColor: warnaStatus),
                      _buildInfoRow(
                          Icons.shopping_bag_outlined,
                          'Nama Produk',
                          nama),

                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              warnaStatus.withValues(alpha: 0.06),
                              warnaStatus.withValues(alpha: 0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: warnaStatus.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Belanja',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B5B4F),
                              ),
                            ),
                            Text(
                              formatRupiah(harga),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: warnaStatus,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol kembali
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 20, 16, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                          Icons.arrow_back_rounded, size: 18),
                      label: const Text(
                        'Kembali ke Transaksi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor:
                            const Color(0xFFFF6B00).withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Baris informasi pesanan — redesign
  Widget _buildInfoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF9B8B7E),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9B8B7E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFF3D3027),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
