import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/scenario_template.dart';
import '../providers/puzzle_provider.dart';
import 'picker_page.dart';

/// 某一场景栏目下的全部热门例图
class ScenarioGalleryPage extends StatelessWidget {
  final ScenarioSection section;

  const ScenarioGalleryPage({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(section.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Text(
              section.subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: section.templates.length,
              itemBuilder: (context, index) {
                final template = section.templates[index];
                return _ScenarioExampleCard(
                  template: template,
                  onTap: () => _openTemplate(context, template),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openTemplate(BuildContext context, ScenarioTemplate template) {
    context.read<PuzzleProvider>().applyScenarioTemplate(template);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickerPage()),
    );
  }
}

class _ScenarioExampleCard extends StatelessWidget {
  final ScenarioTemplate template;
  final VoidCallback onTap;

  const _ScenarioExampleCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: template.previewColors,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                template.previewIcon,
                size: 44,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            if (template.isHot)
              const Positioned(
                top: 8,
                right: 8,
                child: Text('🔥', style: TextStyle(fontSize: 16)),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      template.photoHint,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
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
