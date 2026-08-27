import 'package:flutter/material.dart';
import 'home_page.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ServicesHero(),
            _ServicesDetailedList(),
            _FooterReplacement(),
          ],
        ),
      ),
    );
  }
}

class _ServicesHero extends StatelessWidget {
  const _ServicesHero();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      height: 350,
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AdvancedFloatingNavBar(isServicesPage: true),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'خدماتنا',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: isMobile ? 40 : 60,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'حلول طبية متكاملة لاستعادة صحتك وحيويتك',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.w300,
                        fontSize: isMobile ? 18 : 24,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesDetailedList extends StatelessWidget {
  const _ServicesDetailedList();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    final List<Map<String, String>> services = [
      {
        'title': 'العلاج الطبيعي (Physical Therapy)',
        'desc': 'جلسات علاج يدوي وتمارين علاجية مخصصة لاستعادة الحركة وتقليل الألم.',
        'icon': 'healing'
      },
      {
        'title': 'التأهيل البدني (Rehabilitation)',
        'desc': 'برامج تأهيلية متكاملة لما بعد العمليات الجراحية والإصابات المزمنة.',
        'icon': 'accessibility'
      },
      {
        'title': 'الإبر الصينية (Acupuncture)',
        'desc': 'استخدام الطب الصيني التقليدي بالتكامل مع العلاج الطبيعي لتخفيف الآلام.',
        'icon': 'medical_services'
      },
      {
        'title': 'الموجات التصادمية (Shockwave Therapy)',
        'desc': 'تقنية غير جراحية لعلاج آلام المفاصل، شوكة الكعب، والتهابات الأوتار.',
        'icon': 'flash_on'
      },
      {
        'title': 'التغذية العلاجية (Therapeutic Nutrition)',
        'desc': 'برامج غذائية مخصصة لدعم الصحة البدنية والوصول للوزن المثالي.',
        'icon': 'restaurant'
      },
      {
        'title': 'جلسات الاستشفاء (Recovery Sessions)',
        'desc': 'استشفاء عضلي عميق للرياضيين والأشخاص ذوي المجهود البدني العالي.',
        'icon': 'battery_charging_full'
      },
      {
        'title': 'الحجامة الطبية (Cupping Therapy)',
        'desc': 'جلسات حجامة احترافية لتحسين الدورة الدموية وتقليل التشنجات العضلية.',
        'icon': 'opacity'
      },
      {
        'title': 'الجلسات المنزلية (Home Sessions)',
        'desc': 'نوفر خدمة العلاج الطبيعي في منزلك بأحدث الأجهزة المحمولة لراحتك.',
        'icon': 'home'
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 20 : 80),
      color: Colors.white,
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: services.map((s) => _DetailedServiceCard(
          title: s['title']!,
          desc: s['desc']!,
          iconName: s['icon']!,
        )).toList(),
      ),
    );
  }
}

class _DetailedServiceCard extends StatelessWidget {
  final String title;
  final String desc;
  final String iconName;

  const _DetailedServiceCard({required this.title, required this.desc, required this.iconName});

  IconData _getIcon() {
    switch (iconName) {
      case 'healing': return Icons.healing;
      case 'accessibility': return Icons.accessibility_new;
      case 'medical_services': return Icons.medical_services;
      case 'flash_on': return Icons.flash_on;
      case 'restaurant': return Icons.restaurant;
      case 'battery_charging_full': return Icons.battery_charging_full;
      case 'opacity': return Icons.opacity;
      case 'home': return Icons.home;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width < 900 ? width - 40 : (width - 220) / 2;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(_getIcon(), color: const Color(0xFFD4AF37), size: 35),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterReplacement extends StatelessWidget {
  const _FooterReplacement();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      color: const Color(0xFFFAFAFA),
      child: Center(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png', height: 60),
            const SizedBox(height: 20),
            const Text(
              'جميع الحقوق محفوظة © 2026 مركز دراز',
              style: TextStyle(color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
