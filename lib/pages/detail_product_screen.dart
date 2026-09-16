import 'package:flutter/material.dart';

import '../data/models/model_produk.dart';

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

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,

      // =========================================================
      // BOTTOM ACTION
      // =========================================================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity
              Container(
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 1
                          ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                    ),

                    Text(
                      '$quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Keranjang
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk ditambahkan ke keranjang'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Keranjang'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Beli
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Melanjutkan ke pembelian')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Beli'),
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
          // IMAGE + APP BAR
          // =====================================================
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            elevation: 0,

            backgroundColor: Colors.white,

            // Judul muncul ketika sudah scroll
            title: const Text(
              'Detail Produk',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            // Transparan ketika berada di atas
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(product.image, fit: BoxFit.cover),

                  // Gradient supaya icon terlihat jelas
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.25),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tombol di atas gambar
            actions: [
              _circleButton(
                icon: Icons.shopping_cart_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka keranjang')),
                  );
                },
              ),

              _circleButton(
                icon: Icons.share_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membagikan produk')),
                  );
                },
              ),

              const SizedBox(width: 8),
            ],
          ),

          // =====================================================
          // PRODUCT INFORMATION
          // =====================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + Favorite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Harga
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 5),
                      const Text(
                        '4.8',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '128 ulasan',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• 350 terjual',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 18),

                  // =================================================
                  // DESKRIPSI
                  // =================================================
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Produk berkualitas dengan bahan terbaik dan '
                    'desain yang nyaman digunakan. Produk ini cocok '
                    'digunakan untuk kebutuhan sehari-hari dan '
                    'memiliki kualitas yang tahan lama.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // VARIANT
                  // =================================================
                  const Text(
                    'Varian',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: [
                      _variantButton('Default'),
                      _variantButton('Merah'),
                      _variantButton('Hitam'),
                      _variantButton('Putih'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // TOKO
                  // =================================================
                  const Text(
                    'Toko',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=12',
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Toko Berkah Jaya',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Bekasi, Jawa Barat',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Kunjungi'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // ULASAN
                  // =================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ulasan Pembeli',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      TextButton(
                        onPressed: () {},
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  _reviewItem(
                    name: 'Ahmad',
                    rating: 5,
                    comment:
                        'Barang bagus, sesuai dengan deskripsi. '
                        'Pengiriman juga cepat.',
                  ),

                  _reviewItem(
                    name: 'Siti',
                    rating: 4,
                    comment: 'Kualitas produknya bagus dan packing rapi.',
                  ),

                  _reviewItem(
                    name: 'Budi',
                    rating: 5,
                    comment: 'Puas dengan produknya. Recommended!',
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // PRODUK MIRIP
                  // =================================================
                  const Text(
                    'Produk Mirip',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 230,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _similarProductItem(
                          image: product.image,
                          name: 'Produk Mirip ${index + 1}',
                          price: 75000 + (index * 10000),
                        );
                      },
                    ),
                  ),

                  // Ruang tambahan karena bottom bar
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // CIRCLE BUTTON APP BAR
  // ===============================================================
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 21),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // VARIANT BUTTON
  // ===============================================================
  Widget _variantButton(String variant) {
    final selected = selectedVariant == variant;

    return ChoiceChip(
      label: Text(variant),
      selected: selected,
      onSelected: (_) {
        setState(() {
          selectedVariant = variant;
        });
      },
    );
  }

  // ===============================================================
  // REVIEW
  // ===============================================================
  Widget _reviewItem({
    required String name,
    required int rating,
    required String comment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20, child: Text(name[0])),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Row(
                  children: List.generate(
                    rating,
                    (index) =>
                        const Icon(Icons.star, size: 16, color: Colors.orange),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  comment,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // SIMILAR PRODUCT
  // ===============================================================
  Widget _similarProductItem({
    required String image,
    required String name,
    required int price,
  }) {
    return SizedBox(
      width: 145,
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              width: double.infinity,
              height: 135,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatRupiah(price),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================================
// FORMAT RUPIAH
// ===============================================================
String formatRupiah(int price) {
  final formatted = price.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  );

  return 'Rp $formatted';
}
