import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allFaqs = [
    {
      'category': 'Pesanan',
      'question': 'Bagaimana cara melacak pesanan saya?',
      'answer':
          'Buka tab "Transaksi" di navigasi bawah aplikasi. Pilih pesanan yang ingin Anda pantau untuk melihat update terkini status pengiriman, kurir, dan nomor resi secara real-time.',
    },
    {
      'category': 'Voucher',
      'question': 'Bagaimana cara menggunakan kupon & voucher diskon?',
      'answer':
          'Kupon dapat disalin dari menu "Voucher" pada halaman Profil. Pada saat checkout di keranjang belanja, tempel atau pilih kode kupon sebelum melakukan pembayaran untuk mendapatkan potongan harga.',
    },
    {
      'category': 'Pembayaran',
      'question': 'Metode pembayaran apa saja yang didukung?',
      'answer':
          'BelanjaMart mendukung Transfer Virtual Account (BCA, Mandiri, BRI, BNI), Dompet Digital (GoPay, OVO, DANA, ShopeePay), Kartu Kredit/Debit, serta COD (Bayar di Tempat) untuk wilayah tertentu.',
    },
    {
      'category': 'Pengembalian',
      'question': 'Bagaimana proses pengembalian barang (retur) dan refund?',
      'answer':
          'Jika pesanan rusak, cacat, atau tidak sesuai, Anda dapat mengajukan komplain maksimal 2x24 jam setelah status barang "Diterima". Lampirkan foto dan video unboxing pada halaman detail transaksi.',
    },
    {
      'category': 'Pengiriman',
      'question': 'Berapa lama estimasi pengiriman pesanan?',
      'answer':
          'Pengiriman Reguler: 2-3 hari kerja untuk Jabodetabek dan 3-5 hari untuk luar pulau Jawa. Pengiriman Instan/Sameday: 2-6 jam sejak paket diserahkan ke kurir.',
    },
    {
      'category': 'Akun',
      'question': 'Bagaimana cara mengubah alamat atau nomor telepon?',
      'answer':
          'Anda dapat mengedit informasi data diri pada menu "Edit Profil Pengguna" dan mengelola alamat rumah maupun kantor melalui menu "Alamat Pengiriman" di halaman profil.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openLiveChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LiveChatSupportScreen()),
    );
  }

  void _showContactChannelDialog({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
    required String actionLabel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1B4B)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$actionLabel: $value berhasil diproses'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _allFaqs.where((faq) {
      final q = _searchQuery.toLowerCase();
      return faq['question']!.toLowerCase().contains(q) ||
          faq['answer']!.toLowerCase().contains(q) ||
          faq['category']!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Pusat Bantuan & CS',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryOrange,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryOrange, primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Sambutan
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryOrange.withValues(alpha: 0.12), primaryPurple.withValues(alpha: 0.12)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryOrange.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Butuh Bantuan Cepat?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tim Customer Care kami siap membantu 24/7!',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Saluran Kontak Cepat
            const Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _contactButton(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Live Chat',
                    subtitle: 'Online 24 Jam',
                    color: primaryPurple,
                    onTap: _openLiveChat,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _contactButton(
                    icon: Icons.phone_in_talk_rounded,
                    label: 'Hotline CS',
                    subtitle: '1500-888',
                    color: primaryOrange,
                    onTap: () {
                      _showContactChannelDialog(
                        title: 'Telepon Hotline',
                        subtitle: 'Hubungi call center resmi BelanjaMart 24 Jam bebas pulsa:',
                        value: '1500-888',
                        icon: Icons.phone_in_talk_rounded,
                        color: primaryOrange,
                        actionLabel: 'Panggil',
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _contactButton(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Support',
                    subtitle: 'support@belanjamart.id',
                    color: Colors.blue.shade700,
                    onTap: () {
                      _showContactChannelDialog(
                        title: 'Kirim Email',
                        subtitle: 'Kirim pertanyaan atau komplain kendala pesanan ke:',
                        value: 'support@belanjamart.id',
                        icon: Icons.mail_outline_rounded,
                        color: Colors.blue.shade700,
                        actionLabel: 'Kirim Email',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _contactButton(
                    icon: Icons.wechat_rounded,
                    label: 'WhatsApp CS',
                    subtitle: '+62 812-9988-7766',
                    color: Colors.green.shade600,
                    onTap: () {
                      _showContactChannelDialog(
                        title: 'WhatsApp Resmi',
                        subtitle: 'Chat langsung via WhatsApp resmi official BelanjaMart:',
                        value: '+62 812-9988-7766',
                        icon: Icons.wechat_rounded,
                        color: Colors.green.shade600,
                        actionLabel: 'Buka WhatsApp',
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bagian FAQ
            const Text(
              'Pertanyaan yang Sering Diajukan (FAQ)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 10),

            // Search Bar FAQ
            TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() {
                  _searchQuery = v;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari topik bantuan (misal: lacak, voucher)...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: primaryPurple, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryPurple, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (filteredFaqs.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text(
                        'Topik pertanyaan tidak ditemukan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coba kata kunci lain atau hubungi Live Chat CS kami',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ).alignment,
              )
            else
              ...filteredFaqs.map((faq) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.help_outline_rounded, color: primaryOrange, size: 18),
                      ),
                      title: Text(
                        faq['question']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            faq['answer']!,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _contactButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// ── SIMULASI LIVE CHAT CS ──
class LiveChatSupportScreen extends StatefulWidget {
  const LiveChatSupportScreen({super.key});

  @override
  State<LiveChatSupportScreen> createState() => _LiveChatSupportScreenState();
}

class _LiveChatSupportScreenState extends State<LiveChatSupportScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'time': 'Sekarang',
      'text': 'Halo Muhammad Rosyid! 👋 Selamat datang di Layanan Customer Service BelanjaMart 24 Jam. Ada yang bisa kami bantu hari ini seputar pesanan atau promo Anda?',
    },
  ];

  static const Color primaryOrange = Color(0xFFFF6B00);
  static const Color primaryPurple = Color(0xFF6C5CE7);

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    _msgCtrl.clear();
    setState(() {
      _messages.add({
        'isUser': true,
        'time': 'Sekarang',
        'text': text,
      });
    });

    _scrollToBottom();

    // Auto reply simulasi CS
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String reply = 'Terima kasih atas pesan Anda. Agen CS kami sedang mengecek detail pesanan Anda. Mohon ditunggu sebentar ya!';
      final lower = text.toLowerCase();
      if (lower.contains('voucher') || lower.contains('kupon') || lower.contains('diskon')) {
        reply = 'Untuk promo voucher aktif, Anda dapat mengklaim kupon DISKON50 atau FREEONGKIR pada halaman Voucher di menu Profil Anda!';
      } else if (lower.contains('ongkir') || lower.contains('kirim')) {
        reply = 'Paket Anda saat ini dikirim via kurir reguler dengan estimasi tiba 1-2 hari kerja. Anda dapat memantaunya di tab Transaksi!';
      } else if (lower.contains('batal') || lower.contains('cancel')) {
        reply = 'Pembatalan pesanan dapat dilakukan jika status barang masih "Belum Bayar" atau "Diproses" melalui tombol Batalkan di detail transaksi.';
      }

      setState(() {
        _messages.add({
          'isUser': false,
          'time': 'Sekarang',
          'text': reply,
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent_rounded, color: primaryPurple, size: 22),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CS BelanjaMart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                Text(
                  '● Aktif Sekarang',
                  style: TextStyle(fontSize: 11, color: Colors.greenAccent),
                ),
              ],
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryOrange,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryOrange, primaryPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? primaryOrange : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFF1E1B4B),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ketik pesan bantuan Anda...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: primaryPurple, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
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
