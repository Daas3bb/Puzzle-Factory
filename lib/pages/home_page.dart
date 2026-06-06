import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/scenario_template.dart';
import '../models/selected_image.dart';
import '../providers/puzzle_provider.dart';
import 'collage_edit_page.dart';
import 'picker_page.dart';
import 'scenario_gallery_page.dart';

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
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.dashboard_customize_outlined,
              label: '拼贴',
              selected: _navIndex == 0,
              onTap: () => setState(() => _navIndex = 0),
            ),
            const SizedBox(width: 56),
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
          for (final section in ScenarioCatalog.sections)
            SliverToBoxAdapter(child: _buildScenarioSection(section)),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
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
          const SizedBox(height: 8),
          Text(
            ScenarioCatalog.appTagline,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSection(ScenarioSection section) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(section.icon, size: 20, color: _accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        section.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _openGallery(section),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '查看全部 >',
                      style: TextStyle(
                        fontSize: 13,
                        color: _accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: section.templates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final template = section.templates[index];
                return _ScenarioTemplateCard(
                  template: template,
                  onTap: () => _openTemplate(template),
                );
              },
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
              subtitle: const Text('先选使用场景，再挑选热门例图开始创作'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _openTemplate(ScenarioTemplate template) {
    final provider = context.read<PuzzleProvider>();
    provider.applyScenarioTemplate(template);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickerPage()),
    );
  }

  void _openGallery(ScenarioSection section) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScenarioGalleryPage(section: section),
      ),
    );
  }

  Future<void> _onCreateCollage() async {
    final provider = context.read<PuzzleProvider>();
    provider.clearScenario();
    provider.setLayoutType(PuzzleLayoutType.grid3x3);
    provider.setSpacing(2);
    provider.setBorderRadius(8);
    provider.setBackgroundColor(Colors.white);
    provider.clearImages();
    await provider.pickImages(maxCount: provider.maxImages);
    if (!mounted) return;
    if (provider.imageCount == 0) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CollageEditPage()),
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
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

class _ScenarioTemplateCard extends StatelessWidget {
  final ScenarioTemplate template;
  final VoidCallback onTap;

  const _ScenarioTemplateCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 118,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: template.previewColors,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                template.previewIcon,
                size: 38,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            if (template.isHot)
              const Positioned(
                top: 8,
                right: 8,
                child: Text('🔥', style: TextStyle(fontSize: 14)),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.22),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      template.hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
