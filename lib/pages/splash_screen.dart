import 'package:flutter/material.dart';
import 'package:mysample/services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    // cek sesi yang tersimpan di shared preferences
      Future<void> checkSession() async {
        // Simulasi delay untuk menampilkan splash screen selama 3 detik
        await Future.delayed(Duration(seconds: 3));
        // buat variable untuk menyimpan status login
        final islogin = await SessionService.islogin();
        if (!mounted) return;
        if (islogin) {
          // jika sudah login, arahkan ke halaman home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // jika belum login, arahkan ke halaman login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    
    @override
    void initState() {
      // TOOD: implement initState
      super.initState();
      checkSession();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'BelanjaMart',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belanja Mudah, Cepat & Nyaman',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 36),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}