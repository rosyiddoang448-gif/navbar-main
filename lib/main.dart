import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'pages/app_settings_screen.dart';
import 'pages/cart_page.dart';
import 'pages/edit_profile_screen.dart';
import 'pages/feeds_sreen.dart';
import 'pages/help_center_screen.dart';
import 'pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/mall_sreen.dart';
import 'pages/profile_screen.dart';
import 'pages/register_screen.dart';
import 'pages/shipping_addresses_screen.dart';
import 'pages/splash_screen.dart';
import 'pages/transactions_screen.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BelanjaMart',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // Memaksa selalu light mode (cerah)
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B00),
          primary: const Color(0xFFFF6B00),
          secondary: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E1B4B),
          elevation: 0,
        ),
      ),
      // Halaman pertama yang dibuka
      initialRoute: '/splash',

      // Daftar route
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const NavigationExample(),
        '/splash': (context) => const SplashScreen(),
        '/cart': (context) => const CartPage(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/shipping-addresses': (context) => const ShippingAddressesScreen(),
        '/app-settings': (context) => const AppSettingsScreen(),
        '/help-center': (context) => const HelpCenterScreen(),
      },
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  // kondisi navbar muncul atau tidak
  bool _showNavigationBar = true;

  // penentu kemunculan navbar
  void _handleScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      // jika scroll kebawah (layar ke atas)
      if (notification.direction == ScrollDirection.reverse) {
        // sembunyikan navbar
        setState(() {
          _showNavigationBar = false;
        });
      } else if (notification.direction == ScrollDirection.forward) {
        // jika scroll keatas (layar ke bawah)
        // tampilkan navbar
        setState(() {
          _showNavigationBar = true;
        });
      }
    }
  }

  bool dialogSudahMuncul = false; // Variabel untuk melacak apakah dialog sudah muncul

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Jika dialog sudah muncul, hentikan eksekusi lebih lanjut
    if (dialogSudahMuncul) return;
    dialogSudahMuncul = true;

    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final dataDiri = arguments?['data'];
    final sesi = arguments?['sesi'];
    final tanggal = arguments?['tanggal'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dataDiri != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Login Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text.rich(
                    TextSpan(
                      text: 'Selamat datang ',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                      ),
                      children: [
                        TextSpan(
                          text: '${dataDiri['name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const TextSpan(text: ',\nAnda berhasil masuk pada '),
                        TextSpan(
                          text: '$tanggal',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const TextSpan(text: ' sesi '),
                        TextSpan(
                          text: '$sesi',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: Colors.green.withValues(alpha: 0.4),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'LANJUTKAN',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScroll(notification);
          return false;
        },
        child: Stack(
          children: [
            pages[currentPageIndex],
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                offset: _showNavigationBar ? Offset.zero : const Offset(0, 1.5),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: _showNavigationBar ? 1.0 : 0.0,
                  child: _navBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBar() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25),
      clipBehavior: Clip.antiAlias,
      child: NavigationBar(
        onDestinationSelected: (int selectedMenu) {
          setState(() {
            currentPageIndex = selectedMenu;
          });
        },
        indicatorColor: const Color(0xFFFF6B00),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.video_collection, color: Colors.white),
            icon: Icon(Icons.video_collection_outlined),
            label: 'Feeds',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.store, color: Colors.white),
            icon: Icon(Icons.store_outlined),
            label: 'Mall',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            icon: Badge(label: Text('5'), child: Icon(Icons.list_alt_outlined)),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Colors.white),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
