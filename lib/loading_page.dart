import 'package:flutter/material.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Simulate a loading delay then navigate to home
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.medical_services,
                        size: 80,
                        color: Color(0xFFC59F54),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Center Name
            const Text(
              'مركز دراز',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2D2D2D),
                letterSpacing: 2,
              ),
            ),
            const Text(
              'للعلاج الطبيعي والتأهيل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Color(0xFFC59F54),
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 50),
            // Premium Progress Indicator
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xFFEEEEEE),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC59F54)),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
