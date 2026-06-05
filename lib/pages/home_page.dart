import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/selected_image.dart';
import '../providers/puzzle_provider.dart';
import 'collage_edit_page.dart';
import 'picker_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  static const Color _accent = Color(0xFF7B5CF6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _navIndex == 0 ? _buildHomeBody() : _buildSettingsBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateCollage,
        backgroundColor: _accent,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 64,
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.dashboard_customize_outlined,
              label: '拼贴',
              selected: _navIndex == 0,
              onTap: () => setState(() => _navIndex = 0),
            ),
            const SizedBox(width: 48),
            _NavItem(
              icon: Icons.settings_outlined,
              label: '设置',
              selected: _navIndex == 1,
              onTap: () => setState(() => _navIndex = 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.crop_square,
            title: '网格',
            itemHeight: 100,
            itemBuilder: (index) => _GridTemplateCard(index: index),
          )),
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.sentiment_satisfied_alt_outlined,
            title: '经典',
            itemHeight: 130,
            itemBuilder: (index) => _ClassicTemplateCard(index: index),
          )),
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.camera_alt_outlined,
            title: 'IG 限时动态',
            itemHeight: 160,
            itemBuilder: (index) => _StoryTemplateCard(index: index),
          )),
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.sports_soccer,
            title: '足球杯',
            itemHeight: 130,
            itemBuilder: (index) => _ClassicTemplateCard(index: index + 10),
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Color(0xFFE91E8C), Color(0xFFFF6B35)],
        ).createShader(bounds),
        child: const Text(
          'Collage maker',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required double itemHeight,
    required Widget Function(int index) itemBuilder,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 22, color: const Color(0xFF333333)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _navigateToPicker(PuzzleLayoutType.grid3x3),
                  child: const Text(
                    '查看全部 >',
                    style: TextStyle(
                      fontSize: 13,
                      color: _accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: itemHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 8,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _navigateToPicker(
                  title == 'IG 限时动态'
                      ? PuzzleLayoutType.row3
                      : PuzzleLayoutType.grid3x3,
                ),
                child: itemBuilder(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '设置',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.info_outline, color: _accent),
              title: const Text('关于'),
              subtitle: const Text('拼图相册 v1.0.0'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: _accent),
              title: const Text('使用帮助'),
              subtitle: const Text('点击底部 + 号从相册选图开始拼贴'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreateCollage() async {
    final provider = context.read<PuzzleProvider>();
    provider.setLayoutType(PuzzleLayoutType.grid3x3);
    provider.clearImages();
    await provider.pickImages(maxCount: provider.maxImages);
    if (!mounted) return;
    if (provider.imageCount == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CollageEditPage()),
    );
  }

  void _navigateToPicker(PuzzleLayoutType type) {
    final provider = context.read<PuzzleProvider>();
    provider.setLayoutType(type);
    provider.clearImages();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickerPage()),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF7B5CF6);
    final color = selected ? accent : Colors.grey;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridTemplateCard extends StatelessWidget {
  final int index;

  const _GridTemplateCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final patterns = [
      [1, 1],
      [2, 1],
      [1, 2],
      [2, 2],
      [3, 1],
      [1, 3],
      [3, 3],
      [2, 3],
    ];
    final pattern = patterns[index % patterns.length];

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFE8DEFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: _GridPattern(rows: pattern[0], cols: pattern[1]),
          ),
          if (index % 3 == 0)
            const Positioned(
              top: 6,
              right: 6,
              child: Text('🔥', style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}

class _GridPattern extends StatelessWidget {
  final int rows;
  final int cols;

  const _GridPattern({required this.rows, required this.cols});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (r) {
        return Expanded(
          child: Row(
            children: List.generate(cols, (c) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _ClassicTemplateCard extends StatelessWidget {
  final int index;

  const _ClassicTemplateCard({required this.index});

  static const _gradients = [
    [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
    [Color(0xFFC8E6C9), Color(0xFF81C784)],
    [Color(0xFFFFCCBC), Color(0xFFFF8A65)],
    [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
    [Color(0xFFB3E5FC), Color(0xFF4FC3F7)],
    [Color(0xFFFFF9C4), Color(0xFFFFF176)],
    [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
    [Color(0xFFCFD8DC), Color(0xFF90A4AE)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[index % _gradients.length];

    return Container(
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.photo_library_outlined,
              size: 36,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          if (index % 4 == 0)
            const Positioned(
              top: 6,
              right: 6,
              child: Text('🔥', style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}

class _StoryTemplateCard extends StatelessWidget {
  final int index;

  const _StoryTemplateCard({required this.index});

  static const _colors = [
    Color(0xFFE8F5E9),
    Color(0xFFFCE4EC),
    Color(0xFFE3F2FD),
    Color(0xFFFFF3E0),
    Color(0xFFEDE7F6),
    Color(0xFFE0F7FA),
    Color(0xFFFFF8E1),
    Color(0xFFF3E5F5),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: _colors[index % _colors.length],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_camera_back_outlined, size: 32, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
