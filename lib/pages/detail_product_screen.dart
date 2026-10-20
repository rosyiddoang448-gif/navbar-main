import 'package:flutter/material.dart';

import '../data/dummy/dummy_cart.dart';
import '../data/models/model_cart_item.dart';
import '../data/models/model_produk.dart';
import 'cart_page.dart';

class DetailProductScreen extends StatefulWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  int quantity = 1;
  bool isFavorite = false;
  String selectedVariant = 'Default';

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color deepPurple = Color(0xFF4C1D95);

  String formatRupiah(int price) {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $formatted';
  }

  void _tambahKeKeranjang({bool bukaKeranjang = false}) {
    final product = widget.product;
    final existingIndex = cartItems.indexWhere((item) => item.nama == product.name);

    setState(() {
      if (existingIndex != -1) {
        cartItems[existingIndex].jumlah += quantity;
      } else {
        final newId = cartItems.isEmpty
            ? 1
            : cartItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
        cartItems.add(
          CartItem(
            id: newId,
            nama: product.name,
            harga: product.price,
            gambar: product.image,
            jumlah: quantity,
          ),
        );
      }
    });

    if (bukaKeranjang) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$quantity x ${product.name} berhasil ditambahkan!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'LIHAT',
            textColor: Colors.amberAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final totalItems = cartItems.fold<int>(0, (sum, item) => sum + item.jumlah);

    return Scaffold(
      backgroundColor: Colors.white,

      // =========================================================
      // BOTTOM ACTION BAR MODERN
      // =========================================================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity Selector
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    IconButton(
                      splashRadius: 18,
                      onPressed: quantity > 1
                          ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                          : null,
                      icon: Icon(
                        Icons.remove_rounded,
                        size: 18,
                        color: quantity > 1 ? Colors.black87 : Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    IconButton(
                      splashRadius: 18,
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Tombol Tambah ke Keranjang
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _tambahKeKeranjang(bukaKeranjang: false),
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  label: const Text(
                    '+ Keranjang',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryOrange,
                    side: const BorderSide(color: primaryOrange, width: 1.5),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Tombol Beli Sekarang
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryOrange, primaryPurple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: primaryOrange.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => _tambahKeKeranjang(bukaKeranjang: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: CustomScrollView(
        slivers: [
          // =====================================================
          // SLIVER APP BAR DENGAN GAMBAR PRODUK
          // =====================================================
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E1B4B),
            title: const Text(
              'Detail Produk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1E1B4B),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              // Tombol Keranjang di AppBar dengan Badge
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.35),
                  child: IconButton(
                    icon: Badge(
                      isLabelVisible: totalItems > 0,
                      backgroundColor: primaryOrange,
                      label: Text('$totalItems'),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartPage()),
                      );
                    },
                  ),
                ),
              ),

              // Tombol Share
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.35),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan produk disalin ke papan klip!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // RINCIAN PRODUK
          // =====================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk & Tombol Favorit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1B4B),
                            height: 1.3,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Ditambahkan ke wishlist'
                                    : 'Dihapus dari wishlist',
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? Colors.red : Colors.grey.shade600,
                          size: 26,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Harga
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: primaryOrange,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Rating & Ulasan
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF1E1B4B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '128 Ulasan',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Text('•', style: TextStyle(color: Colors.grey.shade400)),
                      const SizedBox(width: 8),
                      Text(
                        '350 Terjual',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Varian
                  const Text(
                    'Pilih Varian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _variantButton('Default'),
                      _variantButton('Midnight Black'),
                      _variantButton('Pure White'),
                      _variantButton('Sunset Orange'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Deskripsi
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Produk original bergaransi resmi dengan material premium berkualitas tinggi. '
                    'Didesain secara ergonomis untuk kenyamanan maksimal pemakaian sehari-hari. '
                    'Dilengkapi dengan teknologi terkini yang memberikan performa terbaik di kelasnya.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Informasi Toko
                  const Text(
                    'Informasi Toko',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [primaryOrange, primaryPurple],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Official Store Indonesia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '⭐ 4.9 Rating • Pengiriman dari Jakarta',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryPurple,
                            side: const BorderSide(color: primaryPurple),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Kunjungi'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ulasan Pembeli
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ulasan Pembeli (3)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(color: primaryOrange, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _reviewItem(
                    name: 'Ahmad Fauzi',
                    rating: 5,
                    comment: 'Barang asli dan original! Pengiriman super cepat.',
                  ),
                  _reviewItem(
                    name: 'Siti Rahmawati',
                    rating: 5,
                    comment: 'Sangat memuaskan, kualitas materialnya juara.',
                  ),
                  _reviewItem(
                    name: 'Budi Santoso',
                    rating: 4,
                    comment: 'Packaging rapi dan aman, seller sangat ramah.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _variantButton(String variant) {
    final selected = selectedVariant == variant;
    return ChoiceChip(
      label: Text(variant),
      selected: selected,
      selectedColor: primaryOrange.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? primaryOrange : Colors.black87,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: selected ? primaryOrange : Colors.grey.shade300,
      ),
      onSelected: (_) {
        setState(() {
          selectedVariant = variant;
        });
      },
    );
  }

  Widget _reviewItem({
    required String name,
    required int rating,
    required String comment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: primaryPurple.withValues(alpha: 0.2),
            child: Text(
              name[0],
              style: const TextStyle(color: deepPurple, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Row(
                      children: List.generate(
                        rating,
                        (index) => const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
