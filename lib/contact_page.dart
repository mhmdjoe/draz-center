import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ContactHero(),
            _ContactContent(),
            _FooterReplacement(),
          ],
        ),
      ),
    );
  }
}

class _ContactHero extends StatelessWidget {
  const _ContactHero();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Container(
      width: double.infinity,
      height: isMobile ? 350 : 450,
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: AdvancedFloatingNavBar(isContactPage: true),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'تواصل معنا',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: isMobile ? 40 : 60,
                      ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'نحن هنا للإجابة على جميع استفساراتكم وتحديد موعدكم القادم',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFFD4AF37),
                          fontWeight: FontWeight.w300,
                          fontSize: isMobile ? 18 : 24,
                        ),
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

class _ContactContent extends StatefulWidget {
  const _ContactContent();

  @override
  State<_ContactContent> createState() => _ContactContentState();
}

class _ContactContentState extends State<_ContactContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _typeController = TextEditingController();
  final _dateController = TextEditingController();
  final _descController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String message = 
          "*طلب حجز جديد من الموقع الإلكتروني*\n"
          "----------------------------------\n"
          "*الاسم:* ${_nameController.text}\n"
          "*الهاتف:* ${_phoneController.text}\n"
          "*العمر:* ${_ageController.text}\n"
          "*نوع الاستشارة:* ${_typeController.text}\n"
          "*الموعد المفضل:* ${_dateController.text}\n"
          "*الحالة الصحية:* ${_descController.text}\n";

      final String phone = "201234567890";
      final Uri url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        
        if (mounted) {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: "Success",
            barrierColor: Colors.black.withValues(alpha: 0.5),
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, anim1, anim2) => const SizedBox(),
            transitionBuilder: (context, anim1, anim2, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10 * anim1.value, sigmaY: 10 * anim1.value),
                child: ScaleTransition(
                  scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
                  child: FadeTransition(
                    opacity: anim1,
                    child: AlertDialog(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded, color: Color(0xFFD4AF37), size: 100),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'تم توجيهك بنجاح',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2D2D2D)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'يرجى النقر على زر "إرسال" في واتساب لإتمام الحجز. نحن في انتظارك!',
                            style: TextStyle(fontSize: 17, color: Colors.black54, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _nameController.clear();
                                _phoneController.clear();
                                _ageController.clear();
                                _typeController.clear();
                                _dateController.clear();
                                _descController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4AF37),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                elevation: 15,
                                shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('فهمت، شكراً لك', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isMobile ? 20 : 80,
      ),
      color: Colors.white,
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactCard(
                  iconWidget: const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 28),
                  title: 'واتساب',
                  value: '01234567890',
                  actionUrl: 'https://wa.me/201234567890',
                ),
                _ContactCard(
                  iconWidget: const Icon(Icons.phone, color: Color(0xFFD4AF37), size: 28),
                  title: 'اتصل بنا',
                  value: '02-23456789',
                  actionUrl: 'tel:+20223456789',
                ),
                _ContactCard(
                  iconWidget: const Icon(Icons.location_on, color: Color(0xFF2D2D2D), size: 28),
                  title: 'موقعنا',
                  value: 'القاهرة، التجمع الخامس، شارع التسعين',
                  actionUrl: 'https://maps.google.com/?q=Tagamoa+Fifth+Settlement+Cairo',
                ),
                _ContactCard(
                  iconWidget: const Icon(Icons.access_time, color: Color(0xFFD4AF37), size: 28),
                  title: 'ساعات العمل',
                  value: 'السبت - الخميس: 10:00 ص - 10:00 م\nالجمعة: مغلق',
                  actionUrl: '',
                ),
                const SizedBox(height: 40),
                const Text(
                  'تابعنا على وسائل التواصل الاجتماعى',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _SocialIcon(icon: FontAwesomeIcons.facebookF, actionUrl: 'https://facebook.com'),
                    const SizedBox(width: 15),
                    _SocialIcon(icon: FontAwesomeIcons.instagram, actionUrl: 'https://instagram.com'),
                    const SizedBox(width: 15),
                    _SocialIcon(icon: FontAwesomeIcons.whatsapp, actionUrl: 'https://wa.me/201234567890'),
                    const SizedBox(width: 15),
                    _SocialIcon(icon: FontAwesomeIcons.youtube, actionUrl: 'https://youtube.com'),
                  ],
                ),
                if (isMobile) const SizedBox(height: 60),
              ],
            ),
          ),
          if (!isMobile) const SizedBox(width: 80),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 30 : 60),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أرسل لنا رسالة',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _CustomTextField(label: 'الاسم بالكامل', controller: _nameController),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(child: _CustomTextField(label: 'رقم الهاتف', controller: _phoneController)),
                        const SizedBox(width: 20),
                        SizedBox(width: 120, child: _CustomTextField(label: 'العمر', controller: _ageController)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    _CustomTextField(label: 'نوع الاستشارة (عظام، رياضي، إلخ)', controller: _typeController),
                    const SizedBox(height: 25),
                    _CustomTextField(label: 'الموعد المفضل (مثلاً: مساء الاثنين)', controller: _dateController),
                    const SizedBox(height: 25),
                    _CustomTextField(label: 'وصف موجز للحالة الصحية', maxLines: 4, controller: _descController),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'إرسال الآن',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatefulWidget {
  final Widget iconWidget;
  final String title;
  final String value;
  final String actionUrl;

  const _ContactCard({
    required this.iconWidget,
    required this.title,
    required this.value,
    required this.actionUrl,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    if (widget.actionUrl.isEmpty) return;
    final Uri url = Uri.parse(widget.actionUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: _isHovered ? const Color(0xFFD4AF37) : const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ] : [],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: widget.iconWidget,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 15,
                          color: _isHovered ? Colors.white.withValues(alpha: 0.8) : Colors.black45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: _isHovered ? Colors.white : const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final dynamic icon;
  final String actionUrl;
  const _SocialIcon({required this.icon, required this.actionUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Uri url = Uri.parse(actionUrl);
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        }
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FaIcon(
          icon as FaIconData?,
          color: const Color(0xFFD4AF37),
          size: 24,
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController? controller;

  const _CustomTextField({required this.label, this.maxLines = 1, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
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
