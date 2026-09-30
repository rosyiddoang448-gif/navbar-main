import 'package:flutter/material.dart';
import '../data/dummy/dummy_teransaksi.dart';
import 'halaman_status_transaksi.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

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
        return Colors.green;
      case 'dikirim':
        return Colors.blue;
      case 'dikemas':
        return Colors.orange;
      case 'diproses':
        return Colors.amber;
      case 'belum bayar':
        return Colors.amber;
      case 'dibatalkan':
        return Colors.red;
      case 'pengembalian':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Nama tombol sesuai status transaksi
  String getTombolStatus(String status) {
    switch (status.toLowerCase().trim()) {
      case 'belum bayar':
        return 'Bayar';
      case 'dikemas':
      case 'diproses':
        return 'Batalkan';
      case 'dikirim':
        return 'Lacak';
      case 'selesai':
        return 'Beli Lagi';
      case 'dibatalkan':
      case 'pengembalian':
        return 'Lihat Rincian';
      default:
        return '';
    }
  }

  // Method untuk membuka halaman sesuai status
  void tampilkanHalamanSesuaiStatus(
    BuildContext context,
    dynamic item,
  ) {
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
          MaterialPageRoute(
            builder: (context) => HalamanStatusTransaksi(
              status: item.status,
              nama: item.nama,
              harga: item.harga,
              tanggal: item.tanggal,
            ),
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status transaksi tidak tersedia'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final item = transactions[index];
          final status =
              item.status.toString().toLowerCase().trim();
          final teksTombol = getTombolStatus(status);

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tanggal dan status
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.tanggal,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(status)
                              .withAlpha(40),
                          borderRadius:
                              BorderRadius.circular(20),
                          border: Border.all(
                            color: getStatusColor(status)
                                .withAlpha(180),
                          ),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(status),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(),

                  // Informasi produk
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),
                          child: Image.network(
                            item.foto,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '1 barang',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(),

                  // Total belanja dan tombol sesuai status
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Belanja',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatRupiah(item.harga),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tombol tampil sesuai status
                      if (teksTombol.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            tampilkanHalamanSesuaiStatus(
                              context,
                              item,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            backgroundColor:
                                getStatusColor(status),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(teksTombol),
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