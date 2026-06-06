import 'package:flutter/material.dart';

import 'selected_image.dart';

/// 使用场景分类
enum ScenarioCategory {
  moments,
  xiaohongshu,
  travelVlog,
  foodShop,
  productCompare,
}

extension ScenarioCategoryX on ScenarioCategory {
  String get title => switch (this) {
        ScenarioCategory.moments => '朋友圈素材',
        ScenarioCategory.xiaohongshu => '小红书封面',
        ScenarioCategory.travelVlog => '旅游 Vlog 封面',
        ScenarioCategory.foodShop => '美食店铺分享',
        ScenarioCategory.productCompare => '产品对比图',
      };

  String get subtitle => switch (this) {
        ScenarioCategory.moments => '日常晒图、聚会合影，一键出圈',
        ScenarioCategory.xiaohongshu => '笔记首图、探店封面，竖屏更吸睛',
        ScenarioCategory.travelVlog => '风景合集、旅行记录，氛围感拉满',
        ScenarioCategory.foodShop => '菜品展示、门店打卡，食欲感呈现',
        ScenarioCategory.productCompare => '前后对比、多色展示，卖点更清晰',
      };

  IconData get icon => switch (this) {
        ScenarioCategory.moments => Icons.chat_bubble_outline,
        ScenarioCategory.xiaohongshu => Icons.auto_stories_outlined,
        ScenarioCategory.travelVlog => Icons.flight_takeoff,
        ScenarioCategory.foodShop => Icons.restaurant_outlined,
        ScenarioCategory.productCompare => Icons.compare_outlined,
      };
}

/// 场景下的热门例图模板（内部映射布局参数，用户无需关心样式）
class ScenarioTemplate {
  final String id;
  final ScenarioCategory category;
  final String name;
  final String hint;
  final PuzzleLayoutType layoutType;
  final int spacing;
  final double borderRadius;
  final Color backgroundColor;
  final bool isHot;
  final List<Color> previewColors;
  final IconData previewIcon;

  const ScenarioTemplate({
    required this.id,
    required this.category,
    required this.name,
    required this.hint,
    required this.layoutType,
    this.spacing = 2,
    this.borderRadius = 8,
    this.backgroundColor = Colors.white,
    this.isHot = false,
    required this.previewColors,
    required this.previewIcon,
  });

  String get photoHint =>
      layoutType == PuzzleLayoutType.grid3x3 ? '最多 9 张' : '最多 3 张';
}

/// 场景栏目
class ScenarioSection {
  final ScenarioCategory category;
  final List<ScenarioTemplate> templates;

  const ScenarioSection({
    required this.category,
    required this.templates,
  });

  String get title => category.title;
  String get subtitle => category.subtitle;
  IconData get icon => category.icon;
}

/// 首页场景栏目与热门例图数据
class ScenarioCatalog {
  ScenarioCatalog._();

  static const String appTagline = '选使用场景，不用纠结布局样式';

  static const List<ScenarioSection> sections = [
    ScenarioSection(
      category: ScenarioCategory.moments,
      templates: [
        ScenarioTemplate(
          id: 'moments_weekend_grid',
          category: ScenarioCategory.moments,
          name: '周末九宫格',
          hint: '适合日常多图晒生活',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 4,
          isHot: true,
          previewColors: [Color(0xFFE8DEFF), Color(0xFFD1C4E9)],
          previewIcon: Icons.grid_on,
        ),
        ScenarioTemplate(
          id: 'moments_party_collage',
          category: ScenarioCategory.moments,
          name: '聚会合影拼贴',
          hint: '好友合照快速排版',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 0,
          borderRadius: 0,
          previewColors: [Color(0xFFFFCDD2), Color(0xFFEF9A9A)],
          previewIcon: Icons.groups_outlined,
        ),
        ScenarioTemplate(
          id: 'moments_daily_strip',
          category: ScenarioCategory.moments,
          name: '生活三连拍',
          hint: '少量照片也能有故事感',
          layoutType: PuzzleLayoutType.row3,
          spacing: 2,
          borderRadius: 8,
          previewColors: [Color(0xFFC8E6C9), Color(0xFF81C784)],
          previewIcon: Icons.view_week_outlined,
        ),
        ScenarioTemplate(
          id: 'moments_year_review',
          category: ScenarioCategory.moments,
          name: '年度回顾',
          hint: '年终总结多图合集',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 4,
          borderRadius: 8,
          isHot: true,
          previewColors: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
          previewIcon: Icons.calendar_month_outlined,
        ),
      ],
    ),
    ScenarioSection(
      category: ScenarioCategory.xiaohongshu,
      templates: [
        ScenarioTemplate(
          id: 'xhs_cover_note',
          category: ScenarioCategory.xiaohongshu,
          name: '笔记首图',
          hint: '竖屏笔记封面常用款',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 16,
          backgroundColor: Color(0xFFFCE4EC),
          isHot: true,
          previewColors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
          previewIcon: Icons.menu_book_outlined,
        ),
        ScenarioTemplate(
          id: 'xhs_shop_visit',
          category: ScenarioCategory.xiaohongshu,
          name: '探店封面',
          hint: '门店环境 + 菜品组合',
          layoutType: PuzzleLayoutType.row3,
          spacing: 2,
          borderRadius: 12,
          backgroundColor: Color(0xFFFFF3E0),
          previewColors: [Color(0xFFFFCCBC), Color(0xFFFF8A65)],
          previewIcon: Icons.storefront_outlined,
        ),
        ScenarioTemplate(
          id: 'xhs_outfit',
          category: ScenarioCategory.xiaohongshu,
          name: '穿搭合集',
          hint: 'OOTD 多图排版',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 8,
          previewColors: [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
          previewIcon: Icons.checkroom_outlined,
        ),
        ScenarioTemplate(
          id: 'xhs_goods',
          category: ScenarioCategory.xiaohongshu,
          name: '好物分享',
          hint: '单品展示三连图',
          layoutType: PuzzleLayoutType.row3,
          spacing: 4,
          borderRadius: 8,
          isHot: true,
          previewColors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7)],
          previewIcon: Icons.shopping_bag_outlined,
        ),
      ],
    ),
    ScenarioSection(
      category: ScenarioCategory.travelVlog,
      templates: [
        ScenarioTemplate(
          id: 'travel_landscape_triple',
          category: ScenarioCategory.travelVlog,
          name: '风景三联',
          hint: '横屏封面经典构图',
          layoutType: PuzzleLayoutType.row3,
          spacing: 2,
          borderRadius: 4,
          isHot: true,
          previewColors: [Color(0xFFB2DFDB), Color(0xFF4DB6AC)],
          previewIcon: Icons.landscape_outlined,
        ),
        ScenarioTemplate(
          id: 'travel_nine_grid',
          category: ScenarioCategory.travelVlog,
          name: '旅行九宫格',
          hint: '多目的地一次展示',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 8,
          previewColors: [Color(0xFFBBDEFB), Color(0xFF64B5F6)],
          previewIcon: Icons.map_outlined,
        ),
        ScenarioTemplate(
          id: 'travel_city_walk',
          category: ScenarioCategory.travelVlog,
          name: '城市漫步',
          hint: '街景随拍三连',
          layoutType: PuzzleLayoutType.row3,
          spacing: 0,
          borderRadius: 0,
          previewColors: [Color(0xFFCFD8DC), Color(0xFF90A4AE)],
          previewIcon: Icons.location_city_outlined,
        ),
        ScenarioTemplate(
          id: 'travel_holiday',
          category: ScenarioCategory.travelVlog,
          name: '假日回忆',
          hint: '度假氛围多图合集',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 4,
          borderRadius: 12,
          backgroundColor: Color(0xFFE3F2FD),
          previewColors: [Color(0xFF90CAF9), Color(0xFF42A5F5)],
          previewIcon: Icons.beach_access_outlined,
        ),
      ],
    ),
    ScenarioSection(
      category: ScenarioCategory.foodShop,
      templates: [
        ScenarioTemplate(
          id: 'food_signature_triple',
          category: ScenarioCategory.foodShop,
          name: '招牌三连',
          hint: '主打菜品横向展示',
          layoutType: PuzzleLayoutType.row3,
          spacing: 2,
          borderRadius: 8,
          backgroundColor: Color(0xFFFFF3E0),
          isHot: true,
          previewColors: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
          previewIcon: Icons.ramen_dining_outlined,
        ),
        ScenarioTemplate(
          id: 'food_menu_grid',
          category: ScenarioCategory.foodShop,
          name: '菜单九宫格',
          hint: '多款菜品一次呈现',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 4,
          previewColors: [Color(0xFFFFCCBC), Color(0xFFFF8A65)],
          previewIcon: Icons.restaurant_menu_outlined,
        ),
        ScenarioTemplate(
          id: 'food_checkin',
          category: ScenarioCategory.foodShop,
          name: '探店打卡',
          hint: '环境 + 菜品组合晒单',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 0,
          borderRadius: 8,
          previewColors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
          previewIcon: Icons.photo_camera_outlined,
        ),
        ScenarioTemplate(
          id: 'food_set_meal',
          category: ScenarioCategory.foodShop,
          name: '套餐展示',
          hint: '组合套餐横向排版',
          layoutType: PuzzleLayoutType.row3,
          spacing: 4,
          borderRadius: 12,
          previewColors: [Color(0xFFC5E1A5), Color(0xFF8BC34A)],
          previewIcon: Icons.lunch_dining_outlined,
        ),
      ],
    ),
    ScenarioSection(
      category: ScenarioCategory.productCompare,
      templates: [
        ScenarioTemplate(
          id: 'product_before_after',
          category: ScenarioCategory.productCompare,
          name: '前后对比',
          hint: '效果对比一目了然',
          layoutType: PuzzleLayoutType.row3,
          spacing: 4,
          borderRadius: 4,
          isHot: true,
          previewColors: [Color(0xFFE0E0E0), Color(0xFF9E9E9E)],
          previewIcon: Icons.swap_horiz,
        ),
        ScenarioTemplate(
          id: 'product_color_show',
          category: ScenarioCategory.productCompare,
          name: '多色展示',
          hint: '同款多色并列呈现',
          layoutType: PuzzleLayoutType.row3,
          spacing: 2,
          borderRadius: 8,
          previewColors: [Color(0xFFCE93D8), Color(0xFF7986CB)],
          previewIcon: Icons.palette_outlined,
        ),
        ScenarioTemplate(
          id: 'product_detail_grid',
          category: ScenarioCategory.productCompare,
          name: '细节九宫格',
          hint: '多角度细节展示',
          layoutType: PuzzleLayoutType.grid3x3,
          spacing: 2,
          borderRadius: 0,
          previewColors: [Color(0xFFB0BEC5), Color(0xFF78909C)],
          previewIcon: Icons.zoom_in_outlined,
        ),
        ScenarioTemplate(
          id: 'product_selling_point',
          category: ScenarioCategory.productCompare,
          name: '卖点三联',
          hint: '功能亮点分屏展示',
          layoutType: PuzzleLayoutType.row3,
          spacing: 0,
          borderRadius: 0,
          backgroundColor: Colors.white,
          isHot: true,
          previewColors: [Color(0xFF80DEEA), Color(0xFF26C6DA)],
          previewIcon: Icons.star_outline,
        ),
      ],
    ),
  ];

  static ScenarioSection sectionOf(ScenarioCategory category) {
    return sections.firstWhere((s) => s.category == category);
  }

  static ScenarioTemplate? defaultTemplateOf(ScenarioCategory category) {
    final section = sectionOf(category);
    return section.templates.isEmpty ? null : section.templates.first;
  }
}
