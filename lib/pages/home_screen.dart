import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/dummy/dummy_cart.dart';
import '../data/dummy/dummy_kategori.dart';
import '../data/dummy/dummy_produk.dart';
import '../data/models/model_cart_item.dart';
import '../data/models/model_produk.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/voucher_sheet.dart';
import 'cart_page.dart';
import 'detail_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  String _selectedSort = 'default'; // 'default', 'price_asc', 'price_desc', 'rating'

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color deepPurple = Color(0xFF4C1D95);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatRupiah(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'elektronik':
        return Icons.devices_rounded;
      case 'fashion':
        return Icons.shopping_bag_outlined;
      case 'makanan':
        return Icons.restaurant_rounded;
      case 'olahraga':
        return Icons.directions_run_rounded;
      case 'buku':
        return Icons.menu_book_rounded;
      case 'gaming':
        return Icons.sports_esports_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _tambahCepatKeKeranjang(Product product) {
    setState(() {
      final existingIndex = cartItems.indexWhere((item) => item.nama == product.name);
      if (existingIndex != -1) {
        cartItems[existingIndex].jumlah += 1;
      } else {
        cartItems.add(
          CartItem(
            id: cartItems.isEmpty
                ? 1
                : cartItems.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1,
            nama: product.name,
            harga: product.price,
            gambar: product.image,
            jumlah: 1,
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} dimasukkan ke keranjang'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.amberAccent,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
            if (mounted) setState(() {});
          },
        ),
      ),
    );
  }

  void _onPromoBannerTapped() {
    Clipboard.setData(const ClipboardData(text: 'BELANJAHEMAT'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text('Kode kupon "BELANJAHEMAT" berhasil disalin! Diskon hingga 70%'),
            ),
          ],
        ),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'VOUCHER',
          textColor: Colors.amberAccent,
          onPressed: () {
            VoucherBottomSheet.show(context);
          },
        ),
      ),
    );
  }

  void _showSortModal() {
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
              'Urutkan & Filter Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 16),
            _sortOption('Rekomendasi Terbaik', 'default', Icons.thumb_up_alt_outlined),
            _sortOption('Harga: Rendah ke Tinggi', 'price_asc', Icons.arrow_upward_rounded),
            _sortOption('Harga: Tinggi ke Rendah', 'price_desc', Icons.arrow_downward_rounded),
            _sortOption('Rating Tertinggi', 'rating', Icons.star_outline_rounded),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, String value, IconData icon) {
    final isSelected = _selectedSort == value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isSelected ? primaryOrange : Colors.grey.shade600),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? primaryOrange : const Color(0xFF1E1B4B),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: primaryOrange)
          : null,
      onTap: () {
        setState(() {
          _selectedSort = value;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter produk berdasarkan Search Query dan Kategori Terpilih
    List<Product> filteredProducts = products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory = _selectedCategory == null ||
          p.category.toLowerCase() == _selectedCategory!.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    // Pengurutan produk
    if (_selectedSort == 'price_asc') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'price_desc') {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedSort == 'rating') {
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: MyAppBar(
        searchController: _searchController,
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onCartClosed: () {
          setState(() {});
        },
      ),

      // =========================
      // BODY
      // =========================
      body: RefreshIndicator(
        color: primaryOrange,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // PROMO BANNER MODERN
              // =========================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: InkWell(
                  onTap: _onPromoBannerTapped,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryOrange, primaryPurple, deepPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '🔥 PROMO SPESIAL HARI INI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Diskon Hingga 70%\nGratis Ongkir Se-Indonesia',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Gunakan voucher: BELANJAHEMAT',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_mall_rounded,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================
              // KATEGORI
              // ================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori Pilihan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    if (_selectedCategory != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        child: const Text('Reset', style: TextStyle(fontSize: 12, color: primaryOrange, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category.name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = isSelected ? null : category.name;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryPurple.withValues(alpha: 0.15)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected ? primaryPurple : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  category.image,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        _getCategoryIcon(category.name),
                                        color: isSelected ? primaryPurple : primaryOrange,
                                        size: 30,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? primaryPurple : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ================
              // PRODUK REKOMENDASI
              // ================
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Hasil Pencarian (${filteredProducts.length})'
                          : _selectedCategory != null
                              ? 'Kategori: $_selectedCategory (${filteredProducts.length})'
                              : 'Rekomendasi Produk',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    InkWell(
                      onTap: _showSortModal,
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          children: [
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: primaryOrange,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.tune_rounded, size: 16, color: primaryOrange),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              filteredProducts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.search_off_rounded, size: 54, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              _selectedCategory != null
                                  ? 'Belum ada produk untuk kategori "$_selectedCategory"'
                                  : 'Produk "$_searchQuery" tidak ditemukan',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryOrange,
                                side: const BorderSide(color: primaryOrange),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedCategory = null;
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                              child: const Text('Tampilkan Semua Produk'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.63,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _productItemView(product, context);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // KARTU PRODUK MODERN
  // =========================
  Widget _productItemView(Product product, BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProductScreen(product: product),
              ),
            );
            if (mounted) setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar produk dengan Rating Badge
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Icon(_getCategoryIcon(product.category), size: 36, color: primaryOrange),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1B4B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Detail Informasi
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF1E1B4B),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatRupiah(product.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: primaryOrange,
                          ),
                        ),
                        Text(
                          '${product.soldCount} terjual',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Tombol Quick Add
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryOrange,
                          side: BorderSide(color: primaryOrange.withValues(alpha: 0.5)),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _tambahCepatKeKeranjang(product),
                        icon: const Icon(Icons.add_shopping_cart_rounded, size: 14),
                        label: const Text(
                          '+ Keranjang',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
