import 'package:flutter/material.dart';

import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      body: Center(
        child: Image.asset(
          'assets/images/popcorn 1.png',
          width: 170,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.local_movies_outlined, size: 100, color: Colors.white);
          },
        ),
      ),
    );
  }
}
