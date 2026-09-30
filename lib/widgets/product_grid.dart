import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  // Menampung data produk dari API
  List products = [];

  // Menandakan apakah data sedang dimuat
  bool isLoading = true;

  // Menyimpan pesan error jika API gagal
  String? errorMessage;

  // Mengambil data produk dari Fake Store API
  Future<void> fetchProducts() async {
    try {
      final Uri url = Uri.parse('https://fakestoreapi.com/products');

      // Request data ke API
      final response = await http.get(url);

      // Mengecek apakah request berhasil
      if (response.statusCode == 200) {
        // Mengubah JSON menjadi data Dart
        final data = jsonDecode(response.body);

        setState(() {
          products = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data produk.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan koneksi.';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Mengambil data ketika halaman pertama kali dibuka
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Produk',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Temukan produk favoritmu',
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =========================
      // BODY
      // =========================
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4F7CFF)),
      );
    }

    // Error
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 60, color: Colors.grey),

              const SizedBox(height: 16),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });

                  fetchProducts();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // Grid produk
    return RefreshIndicator(
      onRefresh: fetchProducts,

      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),

        itemCount: products.length,

        itemBuilder: (context, index) {
          final product = products[index];

          return _buildProductCard(product);
        },
      ),
    );
  }

  // =========================
  // PRODUCT CARD
  // =========================
  Widget _buildProductCard(dynamic product) {
    final double price = double.tryParse(product['price'].toString()) ?? 0;

    final double rating =
        double.tryParse(product['rating']['rate'].toString()) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // GAMBAR PRODUK
          // =========================
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),

                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),

                    child: Image.network(
                      product['image'],
                      fit: BoxFit.contain,

                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported_outlined,
                          size: 45,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),

                // Badge diskon
                Positioned(
                  top: 16,
                  left: 16,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xFF4F7CFF),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: const Text(
                      'PROMO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Favorite button
                Positioned(
                  top: 14,
                  right: 14,

                  child: Container(
                    width: 32,
                    height: 32,

                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),

                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // INFORMASI PRODUK
          // =========================
          Expanded(
            flex: 4,

            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Kategori
                  Text(
                    product['category'].toString().toUpperCase(),

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Nama produk
                  Text(
                    product['title'],

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const Spacer(),

                  // Rating
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: Colors.amber,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Harga + tombol
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${price.toStringAsFixed(0)}',

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF4F7CFF),
                          ),
                        ),
                      ),

                      Container(
                        width: 34,
                        height: 34,

                        decoration: BoxDecoration(
                          color: const Color(0xFF4F7CFF),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          size: 17,
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
  }
}