import 'package:flutter/material.dart';
import '../data/dummy/dummy_cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Palette warna tema: Oranye, Putih, Ungu
  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color deepPurple = Color(0xFF4C1D95);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  // ==========================================
  // FORMAT RUPIAH
  // ==========================================
  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  // ==========================================
  // HITUNG TOTAL BELANJA
  // ==========================================
  int getTotalBelanja() {
    int total = 0;
    for (final item in cartItems) {
      total += item.harga * item.jumlah;
    }
    return total;
  }

  // ==========================================
  // HITUNG JUMLAH SEMUA ITEM
  // ==========================================
  int getTotalItem() {
    int total = 0;
    for (final item in cartItems) {
      total += item.jumlah;
    }
    return total;
  }

  // ==========================================
  // HAPUS PRODUK
  // ==========================================
  void hapusProduk(int index) {
    final deletedItem = cartItems[index];
    setState(() {
      cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedItem.nama} dihapus dari keranjang'),
        action: SnackBarAction(
          label: 'BATAL',
          textColor: Colors.orangeAccent,
          onPressed: () {
            setState(() {
              cartItems.insert(index, deletedItem);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==========================================
  // KONFIRMASI HAPUS
  // ==========================================
  void konfirmasiHapus(int index) {
    final item = cartItems[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Produk?'),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${item.nama}" dari keranjang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              hapusProduk(index);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODAL SIMULASI CHECKOUT
  // ==========================================
  void tampilkanDialogCheckout() {
    if (cartItems.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryPurple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      Text(
                        'Simulasi Pemesanan E-Commerce',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Produk:'),
                        Text(
                          '${getTotalItem()} barang',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Belanja:'),
                        Text(
                          formatRupiah(getTotalBelanja()),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryOrange,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade800, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Catatan: Ini adalah simulasi alur checkout tugas e-commerce. Transaksi pembayaran riil belum diproses.',
                        style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryOrange, primaryPurple],
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Simulasi pesanan dicatat! Keranjang tetap tersimpan.',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: primaryPurple,
                            ),
                          );
                        },
                        child: const Text(
                          'Konfirmasi Demo',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  // ==========================================
  // WIDGET GAMBAR PRODUK (NETWORK / ASSET)
  // ==========================================
  Widget _buildProductImage(String gambar) {
    if (gambar.startsWith('http://') || gambar.startsWith('https://')) {
      return Image.network(
        gambar,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 100,
            height: 100,
            color: Colors.grey.shade100,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryOrange,
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        gambar,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade100,
      child: Icon(
        Icons.image_outlined,
        size: 36,
        color: Colors.grey.shade400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBelanja = getTotalBelanja();
    final totalItem = getTotalItem();

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================
      // APP BAR MODERN
      // ==========================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'Keranjang',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: primaryOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalItem barang',
                style: const TextStyle(
                  color: primaryOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text('Kosongkan Keranjang?'),
                    content: const Text(
                      'Semua barang di keranjang akan dihapus.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            cartItems.clear();
                          });
                        },
                        child: const Text('Kosongkan'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'Kosongkan',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryOrange.withValues(alpha: 0.15),
                            primaryPurple.withValues(alpha: 0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 56,
                          color: primaryOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Keranjang Masih Kosong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Yuk mulai belanja dan temukan barang favoritmu sekarang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Mulai Belanja'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Banner info promo / gratis ongkir
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: primaryPurple.withValues(alpha: 0.08),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 18,
                        color: primaryPurple,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nikmati Gratis Ongkir & Promo Menarik di Toko Kami!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: deepPurple.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // DAFTAR PRODUK (ListView.builder)
                // ==========================================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final subtotal = item.harga * item.jumlah;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar produk rapi dengan rounded corner
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: _buildProductImage(item.gambar),
                              ),

                              const SizedBox(width: 14),

                              // Info Produk
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Baris Nama Produk & Tombol Hapus
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.nama,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1E1B4B),
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => konfirmasiHapus(index),
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.grey.shade400,
                                            size: 20,
                                          ),
                                          tooltip: 'Hapus produk',
                                          splashRadius: 18,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    // Harga satuan
                                    Text(
                                      formatRupiah(item.harga),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Baris Subtotal & Pengatur Jumlah (- / +)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Subtotal
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Subtotal',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                            Text(
                                              formatRupiah(subtotal),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: primaryOrange,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Pengatur kuantitas
                                        Container(
                                          decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Tombol Minus
                                              InkWell(
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                  left: Radius.circular(10),
                                                ),
                                                onTap: item.jumlah > 1
                                                    ? () {
                                                        setState(() {
                                                          item.jumlah--;
                                                        });
                                                      }
                                                    : null,
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.remove_rounded,
                                                    size: 16,
                                                    color: item.jumlah > 1
                                                        ? Colors.black87
                                                        : Colors.grey.shade400,
                                                  ),
                                                ),
                                              ),

                                              // Teks Jumlah
                                              Container(
                                                width: 34,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${item.jumlah}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1E1B4B),
                                                  ),
                                                ),
                                              ),

                                              // Tombol Plus
                                              InkWell(
                                                borderRadius:
                                                    const BorderRadius.horizontal(
                                                  right: Radius.circular(10),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    item.jumlah++;
                                                  });
                                                },
                                                child: Container(
                                                  width: 32,
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.add_rounded,
                                                    size: 16,
                                                    color: primaryOrange,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ==========================================
                // BOTTOM TOTAL & CHECKOUT
                // ==========================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Rincian Total
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total Belanja ($totalItem barang)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatRupiah(totalBelanja),
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: primaryOrange,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Checkout
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [primaryOrange, primaryPurple],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryOrange.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: tampilkanDialogCheckout,
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}