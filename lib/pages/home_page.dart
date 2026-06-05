import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/selected_image.dart';
import '../providers/puzzle_provider.dart';
import 'picker_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBanner(context),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 20),
              _buildToolButtons(context),
              const SizedBox(height: 24),
              _buildHotTemplates(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Banner ----
  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2D5F3E),
            Color(0xFF4A8C5C),
            Color(0xFF7BC47F),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            left: 20,
            top: 30,
            child: Icon(Icons.card_giftcard, size: 60, color: Colors.redAccent.withOpacity(0.8)),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Icon(Icons.star, size: 50, color: Colors.yellowAccent.withOpacity(0.8)),
          ),
          Positioned(
            left: 80,
            bottom: 30,
            child: Icon(Icons.park, size: 50, color: Colors.green.shade200.withOpacity(0.8)),
          ),
          // Title
          Center(
            child: Text(
              'Puzzle Album',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'serif',
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(2, 2), blurRadius: 4),
                ],
              ),
            ),
          ),
          // Menu button
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
          // Folder button
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.folder, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Quick Actions (two large cards) ----
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickCard(
              context,
              title: 'Quick Puzzle',
              subtitle: 'Fast collage',
              colors: [const Color(0xFFFFCDD2), const Color(0xFFEF9A9A)],
              icon: Icons.grid_view_rounded,
              onTap: () => _navigateToPicker(context, PuzzleLayoutType.grid3x3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickCard(
              context,
              title: 'Image Edit',
              subtitle: 'Photo tools',
              colors: [const Color(0xFFD1C4E9), const Color(0xFFB39DDB)],
              icon: Icons.image_outlined,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Color> colors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Icon(icon, size: 80, color: Colors.white.withOpacity(0.4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---- Tool Buttons (circular icons) ----
  Widget _buildToolButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToolButton(
            label: 'Free Puzzle',
            color: const Color(0xFF66BB6A),
            icon: Icons.layers_rounded,
            onTap: () {},
          ),
          _buildToolButton(
            label: 'Stitch',
            color: const Color(0xFF42A5F5),
            icon: Icons.view_stream_rounded,
            onTap: () => _navigateToPicker(context, PuzzleLayoutType.row3),
          ),
          _buildToolButton(
            label: '3x3 Grid',
            color: const Color(0xFFAED581),
            icon: Icons.grid_on_rounded,
            onTap: () => _navigateToPicker(context, PuzzleLayoutType.grid3x3),
          ),
          _buildToolButton(
            label: 'Grid',
            color: const Color(0xFFCE93D8),
            icon: Icons.diamond_outlined,
            onTap: () {},
          ),
          _buildToolButton(
            label: 'Video',
            color: const Color(0xFF81C784),
            icon: Icons.play_circle_outline_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  // ---- Hot Templates ----
  Widget _buildHotTemplates(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hot Templates',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _templateCards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _TemplateCard(template: _templateCards[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPicker(BuildContext context, PuzzleLayoutType type) {
    final provider = context.read<PuzzleProvider>();
    provider.setLayoutType(type);
    provider.clearImages();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickerPage()),
    );
  }

  // ---- Template data ----
  static final List<_TemplateData> _templateCards = [
    _TemplateData(
      title: 'Coffee Vibes',
      ratio: '4:5',
      colors: [const Color(0xFFD7CCC8), const Color(0xFFA1887F)],
      icon: Icons.coffee,
    ),
    _TemplateData(
      title: 'Fresh Bloom',
      ratio: '4:5',
      colors: [const Color(0xFFC8E6C9), const Color(0xFF81C784)],
      icon: Icons.local_florist,
    ),
    _TemplateData(
      title: 'Picnic Day',
      ratio: '1:1',
      colors: [const Color(0xFFFFF9C4), const Color(0xFFFFF176)],
      icon: Icons.wb_sunny,
    ),
    _TemplateData(
      title: 'Sunset Mood',
      ratio: '9:16',
      colors: [const Color(0xFFFFCCBC), const Color(0xFFFF8A65)],
      icon: Icons.waves,
    ),
    _TemplateData(
      title: 'Minimal Clean',
      ratio: '4:5',
      colors: [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)],
      icon: Icons.crop_square,
    ),
  ];
}

class _TemplateData {
  final String title;
  final String ratio;
  final List<Color> colors;
  final IconData icon;

  _TemplateData({
    required this.title,
    required this.ratio,
    required this.colors,
    required this.icon,
  });
}

class _TemplateCard extends StatelessWidget {
  final _TemplateData template;

  const _TemplateCard({required this.template});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: template.colors,
        ),
      ),
      child: Stack(
        children: [
          // Hot badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.diamond,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          // Center icon
          Center(
            child: Icon(
              template.icon,
              size: 50,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          // Bottom info
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        template.ratio,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
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
