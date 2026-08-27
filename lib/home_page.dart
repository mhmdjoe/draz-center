import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: _HeroSectionContent()),
              const SliverToBoxAdapter(child: _MovingServicesTicker()),
              
              // Scroll-Revealed Sections
              SliverToBoxAdapter(
                child: _ScrollReveal(
                  child: const _FeaturedServicesSection(),
                ),
              ),
              
              SliverToBoxAdapter(
                child: _ScrollReveal(
                  child: const _TrustStatsSection(),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _ScrollReveal(child: const _AboutSection()),
                    _ScrollReveal(child: const _BookingSection()),
                    const _Footer(),
                  ],
                ),
              ),
            ],
          ),
          
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double offset = 0.0;
              if (_scrollController.hasClients) {
                offset = _scrollController.offset;
              }
              final progress = (offset / 200).clamp(0.0, 1.0);
              return _DynamicHeaderOverlay(progress: progress);
            },
          ),
        ],
      ),
    );
  }
}

/// A highly reliable Scroll Reveal widget that listens to the viewport scroll
class _ScrollReveal extends StatefulWidget {
  final Widget child;
  const _ScrollReveal({required this.child});

  @override
  State<_ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<_ScrollReveal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _scrollPosition = Scrollable.of(context).position;
    _scrollPosition?.addListener(_checkVisibility);
    // Initial check
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _removeListener();
    _controller.dispose();
    super.dispose();
  }

  void _removeListener() {
    _scrollPosition?.removeListener(_checkVisibility);
  }

  void _checkVisibility() {
    if (_isVisible || !mounted) return;

    final RenderObject? object = context.findRenderObject();
    if (object is! RenderBox) return;

    final viewport = RenderAbstractViewport.of(object);
    final double revealedOffset = viewport.getOffsetToReveal(object, 0.0).offset;
    
    if (_scrollPosition == null) return;
    
    final double scrollOffset = _scrollPosition!.pixels;
    final double viewportHeight = _scrollPosition!.viewportDimension;

    // Trigger when the element is about to enter the viewport
    if (scrollOffset + viewportHeight > revealedOffset + 50) {
      setState(() => _isVisible = true);
      _controller.forward();
      _removeListener(); // Stop listening once visible
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: FractionalTranslation(
            translation: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _MovingServicesTicker extends StatefulWidget {
  const _MovingServicesTicker();

  @override
  State<_MovingServicesTicker> createState() => _MovingServicesTickerState();
}

class _MovingServicesTickerState extends State<_MovingServicesTicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 10000);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 120),
      curve: Curves.linear,
    ).then((_) {
      if (mounted) {
        _scrollController.jumpTo(10000);
        _startScrolling();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      'العلاج الطبيعي', 'تأهيل إصابات الملاعب', 'الإبر الصينية', 'الموجات التصادمية',
      'التغذية العلاجية', 'جلسات الاستشفاء', 'الحجامة الطبية', 'الجلسات المنزلية'
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
        border: Border.symmetric(horizontal: BorderSide(color: const Color(0xFFD4AF37).withValues(alpha: 0.2))),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final service = services[index % services.length];
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: Color(0xFFD4AF37), size: 16),
                  const SizedBox(width: 20),
                  Text(
                    service,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2D2D),
                    ),
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

class _FeaturedServicesSection extends StatelessWidget {
  const _FeaturedServicesSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.only(
        top: 120,
        bottom: 0,
        left: isMobile ? 20 : 80,
        right: isMobile ? 20 : 80,
      ),
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          const Text(
            'نهتم بك لتستعيد كمال طاقتك',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'اخترنا لك أفضل الحلول المتكاملة لبداية رحلة تعافيك',
            style: TextStyle(fontSize: 18, color: Colors.black45),
          ),
          const SizedBox(height: 80),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 4,
            mainAxisSpacing: 30,
            crossAxisSpacing: 30,
            childAspectRatio: isMobile ? 1.5 : 0.8,
            children: const [
              _InteractiveServiceCard(
                icon: Icons.sports_gymnastics,
                title: 'تأهيل رياضي',
                description: 'إعادة الرياضيين لأفضل مستوياتهم بعد الإصابات.',
                index: 0,
              ),
              _InteractiveServiceCard(
                icon: Icons.healing,
                title: 'علاج طبيعي',
                description: 'جلسات يدوية مخصصة لاستعادة الحركة بدون ألم.',
                index: 1,
              ),
              _InteractiveServiceCard(
                icon: Icons.flash_on,
                title: 'موجات تصادمية',
                description: 'أحدث التقنيات لعلاج آلام المفاصل والتهاب الأوتار.',
                index: 2,
              ),
              _InteractiveServiceCard(
                icon: Icons.home,
                title: 'جلسات منزلية',
                description: 'نصل إليك بأحدث الأجهزة لنضمن راحتك التامة.',
                index: 3,
              ),
            ],
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/services'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              elevation: 10,
              shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'شاهد جميع خدماتنا',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 15),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
          const SizedBox(height: 80), 
        ],
      ),
    );
  }
}

class _InteractiveServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final int index;

  const _InteractiveServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.index,
  });

  @override
  State<_InteractiveServiceCard> createState() => _InteractiveServiceCardState();
}

class _InteractiveServiceCardState extends State<_InteractiveServiceCard> with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _entryController;
  late Animation<double> _entryAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600 + (widget.index * 150)),
    );
    _entryAnimation = CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack);
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _entryAnimation,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/services'),
          borderRadius: BorderRadius.circular(40),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(35),
            decoration: BoxDecoration(
              color: isHovered ? const Color(0xFFD4AF37) : Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isHovered ? 0.2 : 0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 40,
                    color: isHovered ? Colors.white : const Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isHovered ? Colors.white : const Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: isHovered ? Colors.white.withValues(alpha: 0.9) : Colors.black54,
                    height: 1.6,
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

class _DynamicHeaderOverlay extends StatelessWidget {
  final double progress;
  const _DynamicHeaderOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final currentLogoSize = lerpDouble(isMobile ? 45 : 65, isMobile ? 35 : 50, progress) ?? 40.0;
    final topPadding = lerpDouble(30.0, 10.0, progress) ?? 10.0;
    final horizontalMargin = lerpDouble(40.0, 20.0, progress) ?? 20.0;
    final backgroundColor = Colors.white.withValues(alpha: lerpDouble(0.0, 0.95, progress) ?? 0.0);
    final borderColor = Colors.black.withValues(alpha: lerpDouble(0.0, 0.05, progress) ?? 0.0);

    return Positioned(
      top: topPadding,
      left: horizontalMargin,
      right: horizontalMargin,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: lerpDouble(0, 10, progress) ?? 0,
              sigmaY: lerpDouble(0, 10, progress) ?? 0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 15 : 25,
                vertical: lerpDouble(15.0, 8.0, progress) ?? 8.0,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: borderColor),
                boxShadow: progress > 0.1 ? [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))
                ] : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/'),
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: currentLogoSize,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.medical_services,
                          color: const Color(0xFFD4AF37),
                          size: currentLogoSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    if (!isMobile) ...[
                      _NavButton(
                        title: 'الرئيسية',
                        onTap: () => Navigator.pushNamed(context, '/'),
                        isActive: true,
                      ),
                      _NavButton(
                        title: 'خدماتنا',
                        onTap: () => Navigator.pushNamed(context, '/services'),
                      ),
                      _NavButton(title: 'عن المركز', onTap: () {}),
                    ],
                    _NavButton(
                      title: isMobile ? 'اتصل' : 'تواصل معنا',
                      onTap: () => Navigator.pushNamed(context, '/contact'),
                    ),
                    SizedBox(width: isMobile ? 10 : 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 25, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(isMobile ? 'احجز' : 'احجز الآن', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdvancedFloatingNavBar extends StatelessWidget {
  final bool isContactPage;
  final bool isServicesPage;
  const AdvancedFloatingNavBar({
    super.key, 
    this.isContactPage = false,
    this.isServicesPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/'),
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset('assets/images/logo.png', height: 50),
                  ), 
                  const SizedBox(width: 10),
                  _NavButton(
                    title: 'الرئيسية',
                    onTap: () => Navigator.pushNamed(context, '/'),
                    isActive: !isContactPage && !isServicesPage,
                  ),
                  _NavButton(
                    title: 'خدماتنا',
                    onTap: () => Navigator.pushNamed(context, '/services'),
                    isActive: isServicesPage,
                  ),
                  _NavButton(
                    title: isMobile ? 'اتصل' : 'تواصل معنا',
                    onTap: () => Navigator.pushNamed(context, '/contact'),
                    isActive: isContactPage,
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(isMobile ? 'احجز' : 'احجز الآن'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _NavButton({required this.title, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFFD4AF37) : const Color(0xFF2D2D2D),
            fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _HeroSectionContent extends StatelessWidget {
  const _HeroSectionContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        image: DecorationImage(
          image: const NetworkImage(
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=1470'), // Restored Original High-Impact Gym/Rehab Photo
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withValues(alpha: 0.3),
            BlendMode.lighten,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/logo.png',
              height: isMobile ? 180 : 320,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.medical_services,
                size: isMobile ? 100 : 150,
                color: const Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'استعد عافيتك.. بخطوات مدروسة',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF2D2D2D),
                    fontSize: isMobile ? 40 : 75,
                  ),
            ),
            const SizedBox(height: 25),
            Text(
              'نحن نهتم بأدق تفاصيل تعافيك للعودة لحياتك الطبيعية',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD4AF37),
                    fontSize: isMobile ? 18 : 28,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                elevation: 20,
                shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('ابدأ رحلة التعافي الآن', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustStatsSection extends StatelessWidget {
  const _TrustStatsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: isMobile ? 20 : 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          const Divider(thickness: 1.5, color: Color(0xFFEEEEEE), height: 0),
          const SizedBox(height: 100),
          Wrap(
            spacing: 80,
            runSpacing: 60,
            alignment: WrapAlignment.center,
            children: const [
              _StatItem(value: '4000+', label: 'مريض سعيد'),
              _StatItem(value: '5+', label: 'سنوات خبرة'),
              _StatItem(value: 'طاقم طبي', label: 'متخصص ومعتمد'),
              _StatItem(value: 'تقنيات', label: 'علاجية حديثة'),
            ],
          ),
          const SizedBox(height: 100),
          const Divider(thickness: 1.5, color: Color(0xFFEEEEEE), height: 0),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFFD4AF37))),
          const SizedBox(height: 15),
          Text(label, style: const TextStyle(fontSize: 22, color: Colors.black54, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 120,
        left: isMobile ? 20 : 80,
        right: isMobile ? 20 : 80,
      ),
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          const SizedBox(height: 120),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('لماذا تختارنا؟', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 25),
                    Text('نجمع بين العلم\nوالخبرة والاهتمام', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF2D2D2D), height: 1.2, fontSize: isMobile ? 36 : 50)),
                    const SizedBox(height: 40),
                    const Text(
                      'نحن في مركز دراز نؤمن بأن كل مريض هو حالة فريدة تستحق رعاية مخصصة. فريقنا مكون من استشاريين وأخصائيين ذوي خبرة واسعة في التأهيل الرياضي، علاج آلام العمود الفقري، وإصابات المفاصل. نستخدم أحدث الأجهزة العالمية لضمان أفضل النتائج في أقصر وقت ممكن.',
                      style: TextStyle(fontSize: 18, color: Colors.black54, height: 2.0),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _SocialIcon(icon: FontAwesomeIcons.facebookF),
                        const SizedBox(width: 15),
                        _SocialIcon(icon: FontAwesomeIcons.instagram),
                        const SizedBox(width: 15),
                        _SocialIcon(icon: FontAwesomeIcons.whatsapp),
                      ],
                    ),
                    const SizedBox(height: 40),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                        side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('تعرف على فريقنا', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    if (isMobile) const SizedBox(height: 60),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 100),
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: isMobile ? 350 : 550,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&q=80&w=1480'), fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      right: isMobile ? 10 : -30,
                      child: Container(
                        padding: const EdgeInsets.all(35),
                        decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(25)),
                        child: const Column(children: [Text('10,000+', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)), Text('جلسة علاجية', style: TextStyle(color: Colors.white, fontSize: 16))]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookingSection extends StatelessWidget {
  const _BookingSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF2D2D2D)),
      child: Column(
        children: [
          Text('استعد حياتك بدون ألم', textAlign: TextAlign.center, style: TextStyle(fontSize: isMobile ? 36 : 55, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 25),
          Text('احجز موعدك الآن للحصول على تقييم شامل', textAlign: TextAlign.center, style: TextStyle(fontSize: isMobile ? 18 : 22, color: Colors.white60)),
          const SizedBox(height: 70),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/contact'), 
            icon: const Icon(Icons.calendar_month, size: 32), 
            label: const Text('احجز موعدك الآن'), 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37), 
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30), 
              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            )
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 20 : 80),
      color: Colors.white,
      child: Column(
        children: [
          const Divider(thickness: 1.5, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 80),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo.png', height: 120),
                    const SizedBox(height: 30),
                    const Text(
                      'مركز دراز للعلاج الطبيعي والتأهيل البدني.\nرعايتكم أمانة في أيدينا واستعادة حركتكم هدفنا.',
                      style: TextStyle(color: Colors.black54, height: 1.8, fontSize: 17),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        _SocialIcon(icon: FontAwesomeIcons.facebookF),
                        const SizedBox(width: 15),
                        _SocialIcon(icon: FontAwesomeIcons.instagram),
                        const SizedBox(width: 15),
                        _SocialIcon(icon: FontAwesomeIcons.whatsapp),
                        const SizedBox(width: 15),
                        _SocialIcon(icon: FontAwesomeIcons.youtube),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isMobile) const SizedBox(width: 100),
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('روابط سريعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 30),
                      _FooterLink(text: 'الرئيسية', onTap: () => Navigator.pushNamed(context, '/')),
                      _FooterLink(text: 'خدماتنا', onTap: () => Navigator.pushNamed(context, '/services')),
                      _FooterLink(text: 'تواصل معنا', onTap: () => Navigator.pushNamed(context, '/contact')),
                    ],
                  ),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تواصل معنا', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 30),
                    const _FooterContactItem(icon: Icons.location_on, text: 'القاهرة، التجمع الخامس'),
                    const _FooterContactItem(icon: Icons.phone, text: '01234567890'),
                    const _FooterContactItem(icon: Icons.email, text: 'info@draz.com'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          const Divider(thickness: 1.5, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 40),
          const Text('جميع الحقوق محفوظة © 2026 مركز دراز للعلاج الطبيعي', style: TextStyle(color: Colors.black38, fontSize: 15)),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _FooterLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap,
        child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 17)),
      ),
    );
  }
}

class _FooterContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 20),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.black54, fontSize: 17))),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final dynamic icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.2)),
        ),
        child: FaIcon(
          icon as FaIconData?,
          color: const Color(0xFFD4AF37),
          size: 20,
        ),
      ),
    );
  }
}
