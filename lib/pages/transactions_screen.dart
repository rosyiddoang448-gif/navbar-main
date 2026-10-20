import 'package:flutter/material.dart';
import '../data/dummy/dummy_teransaksi.dart';
import 'halaman_status_transaksi.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'Semua';

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color deepPurple = Color(0xFF4C1D95);

  final List<String> _filters = [
    'Semua',
    'Belum Bayar',
    'Diproses',
    'Dikemas',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  // Mengubah angka menjadi format Rupiah
  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  // Warna status transaksi
  Color getStatusColor(String status) {
    switch (status.toLowerCase().trim()) {
      case 'selesai':
        return const Color(0xFF10B981);
      case 'dikirim':
        return const Color(0xFF3B82F6);
      case 'dikemas':
        return const Color(0xFFF59E0B);
      case 'diproses':
        return const Color(0xFFFF6B00);
      case 'belum bayar':
        return const Color(0xFFEF4444);
      case 'dibatalkan':
        return const Color(0xFFEF4444);
      case 'pengembalian':
        return primaryPurple;
      default:
        return Colors.grey;
    }
  }

  // Icon status transaksi
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'selesai':
        return Icons.check_circle_rounded;
      case 'dikirim':
        return Icons.local_shipping_rounded;
      case 'dikemas':
        return Icons.inventory_2_rounded;
      case 'diproses':
        return Icons.hourglass_top_rounded;
      case 'belum bayar':
        return Icons.payment_rounded;
      case 'dibatalkan':
        return Icons.cancel_rounded;
      case 'pengembalian':
        return Icons.assignment_return_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  // Nama tombol sesuai status transaksi
  String getTombolStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'belum bayar':
        return 'Bayar Sekarang';
      case 'dikemas':
      case 'diproses':
        return 'Batalkan';
      case 'dikirim':
        return 'Lacak Paket';
      case 'selesai':
        return 'Beli Lagi';
      case 'dibatalkan':
      case 'pengembalian':
        return 'Lihat Rincian';
      default:
        return '';
    }
  }

  // Icon tombol sesuai status
  IconData? getTombolIcon(String status) {
    switch (status.toLowerCase().trim()) {
      case 'belum bayar':
        return Icons.payment_rounded;
      case 'dikemas':
      case 'diproses':
        return Icons.close_rounded;
      case 'dikirim':
        return Icons.pin_drop_rounded;
      case 'selesai':
        return Icons.shopping_cart_rounded;
      case 'dibatalkan':
      case 'pengembalian':
        return Icons.receipt_long_rounded;
      default:
        return null;
    }
  }

  // Method untuk membuka halaman sesuai status
  void tampilkanHalamanSesuaiStatus(BuildContext context, dynamic item) {
    final status = item.status.toString().toLowerCase().trim();

    switch (status) {
      case 'belum bayar':
      case 'dikemas':
      case 'diproses':
      case 'dikirim':
      case 'selesai':
      case 'dibatalkan':
      case 'pengembalian':
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HalamanStatusTransaksi(
              status: item.status,
              nama: item.nama,
              harga: item.harga,
              tanggal: item.tanggal,
              foto: item.foto,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Status transaksi tidak tersedia'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  List<dynamic> get filteredTransactions {
    if (_selectedFilter == 'Semua') return transactions;
    return transactions
        .where((t) =>
            t.status.toLowerCase().trim() ==
            _selectedFilter.toLowerCase().trim())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          // App Bar Modern dengan Gradient Oranye - Ungu
          SliverAppBar(
            expandedHeight: 125,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: primaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Daftar Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryOrange,
                      primaryPurple,
                      deepPurple,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 50,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12, top: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.search_rounded, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              height: 56,
              margin: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: primaryOrange,
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? primaryOrange
                              : Colors.grey.shade300,
                        ),
                      ),
                      elevation: isSelected ? 2 : 0,
                      pressElevation: 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Jumlah transaksi
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${filtered.length} Transaksi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (_selectedFilter != 'Semua')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryOrange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedFilter,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: primaryOrange,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Transaction Cards
          filtered.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded,
                            size: 64,
                            color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Transaksi dengan status "$_selectedFilter"\nbelum tersedia',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filtered[index];
                        final status =
                            item.status.toString().toLowerCase().trim();
                        final teksTombol = getTombolStatus(status);
                        final statusColor = getStatusColor(status);
                        final statusIcon = getStatusIcon(status);
                        final tombolIcon = getTombolIcon(status);

                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(
                              milliseconds: 300 + (index * 80)),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 16 * (1 - value)),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(18),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () =>
                                    tampilkanHalamanSesuaiStatus(context, item),
                                child: Column(
                                  children: [
                                    // Header dengan status
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.05),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              item.tanggal,
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                color: statusColor.withValues(alpha: 0.25),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  statusIcon,
                                                  size: 13,
                                                  color: statusColor,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  item.status,
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Informasi produk
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                                      child: Row(
                                        children: [
                                          // Gambar produk
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              item.foto,
                                              width: 68,
                                              height: 68,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 68,
                                                  height: 68,
                                                  color: Colors.grey.shade100,
                                                  child: const Icon(
                                                    Icons.image_rounded,
                                                    color: Colors.grey,
                                                    size: 28,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 14),

                                          // Info produk
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.nama,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF1E1B4B),
                                                    height: 1.25,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    '1 barang',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.grey.shade700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Chevron
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 22,
                                            color: Colors.grey.shade400,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Divider halus
                                    Divider(height: 1, color: Colors.grey.shade200),

                                    // Total belanja dan tombol
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Belanja',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  formatRupiah(item.harga),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    color: primaryOrange,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Tombol aksi
                                          if (teksTombol.isNotEmpty)
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                tampilkanHalamanSesuaiStatus(context, item);
                                              },
                                              icon: Icon(tombolIcon, size: 14),
                                              label: Text(
                                                teksTombol,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 8,
                                                ),
                                                backgroundColor: statusColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 1,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}