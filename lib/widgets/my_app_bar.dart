import 'package:flutter/material.dart';
import '../data/dummy/dummy_cart.dart';
import '../pages/cart_page.dart';
import '../pages/help_center_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final VoidCallback? onCartClosed;

  const MyAppBar({
    super.key,
    this.onSearchChanged,
    this.searchController,
    this.onCartClosed,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = cartItems.fold<int>(0, (sum, item) => sum + item.jumlah);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Search Bar Modern
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cari barang, brand, atau kategori...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFFFF6B00),
                        size: 22,
                      ),
                      suffixIcon: searchController?.text.isNotEmpty == true
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                              onPressed: () {
                                searchController?.clear();
                                onSearchChanged?.call('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Tombol Chat (Buka Live Chat CS)
              IconButton(
                tooltip: 'Pesan / Live Chat CS',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LiveChatSupportScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF1E1B4B),
                  size: 22,
                ),
              ),

              // Tombol Keranjang dengan Badge Interaktif
              IconButton(
                tooltip: 'Keranjang Belanja',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                  onCartClosed?.call();
                },
                icon: Badge(
                  isLabelVisible: totalItems > 0,
                  backgroundColor: const Color(0xFFFF6B00),
                  label: Text(
                    '$totalItems',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF1E1B4B),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
