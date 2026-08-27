import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';
import 'contact_page.dart';
import 'loading_page.dart';
import 'services_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DrazApp());
}

class DrazApp extends StatelessWidget {
  const DrazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مركز دراز للعلاج الطبيعي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [
        Locale('ar', 'EG'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // More intense Gold
          primary: const Color(0xFFD4AF37),
          secondary: const Color(0xFFB8860B),
          surface: const Color(0xFFFAFAFA),
        ),
        textTheme: GoogleFonts.cairoTextTheme().apply(
          bodyColor: const Color(0xFF2D2D2D),
          displayColor: const Color(0xFFD4AF37),
        ),
      ),
      initialRoute: '/loading',
      routes: {
        '/': (context) => const HomePage(),
        '/contact': (context) => const ContactPage(),
        '/loading': (context) => const LoadingPage(),
        '/services': (context) => const ServicesPage(),
      },
    );
  }
}
