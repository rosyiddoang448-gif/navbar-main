import 'package:flutter/material.dart';

class HalamanStatusTransaksi extends StatelessWidget {
  final String status;
  final String nama;
  final int harga;
  final String tanggal;

  const HalamanStatusTransaksi({
    super.key,
    required this.status,
    required this.nama,
    required this.harga,
    required this.tanggal,
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

  // Ikon berdasarkan status
  IconData get ikonStatus {
    switch (statusNormal) {
      case 'belum bayar':
        return Icons.payment;
      case 'dikemas':
        return Icons.inventory_2;
      case 'diproses':
        return Icons.hourglass_top;
      case 'dikirim':
        return Icons.local_shipping;
      case 'selesai':
        return Icons.check_circle;
      case 'dibatalkan':
        return Icons.cancel;
      case 'pengembalian':
        return Icons.assignment_return;
      default:
        return Icons.info;
    }
  }

  // Pesan sesuai status
  String get pesanStatus {
    switch (statusNormal) {
      case 'belum bayar':
        return 'Pesanan menunggu pembayaran.';
      case 'dikemas':
        return 'Pesanan sedang disiapkan oleh penjual.';
      case 'diproses':
        return 'Pesanan sedang diproses oleh penjual.';
      case 'dikirim':
        return 'Pesanan sedang dalam proses pengiriman.';
      case 'selesai':
        return 'Pesanan telah selesai. Terima kasih sudah berbelanja!';
      case 'dibatalkan':
        return 'Pesanan ini telah dibatalkan.';
      case 'pengembalian':
        return 'Pesanan sedang dalam proses pengembalian.';
      default:
        return 'Status transaksi tidak tersedia.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Transaksi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon dan keterangan status
            Center(
              child: Column(
                children: [
                  Icon(
                    ikonStatus,
                    size: 75,
                    color: warnaStatus,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    status.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: warnaStatus,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pesanStatus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),

            // Informasi pesanan
            const Text(
              'Informasi Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            barisInfo('Nama Produk', nama),
            barisInfo('Tanggal Transaksi', tanggal),
            barisInfo('Status', status),
            barisInfo('Total Belanja', formatRupiah(harga)),

            const SizedBox(height: 30),

            // Tombol kembali
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali ke Transaksi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Baris informasi pesanan
  Widget barisInfo(String judul, String isi) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              judul,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            flex: 3,
            child: Text(
              isi,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}