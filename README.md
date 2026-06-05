# 拼图相册（Puzzle Album）

一款基于 Flutter 开发的移动端图片拼图工具，支持从相册选择图片，快速生成九宫格拼图和横向三栏拼图，并导出分享至社交平台。

## 产品定位

面向社交媒体用户（Instagram / 小红书 / TikTok）、日常照片整理用户和内容创作者，降低拼图门槛，3 秒完成拼图，提升社交内容美观度。

## 功能特性

### 已实现（MVP 版本）

| 功能 | 说明 |
|------|------|
| 相册选图 | 支持多选图片（最多 9 张），可拖拽调整顺序 |
| 九宫格拼图 | 3×3 网格布局，支持间距、圆角、背景色调整 |
| 三栏拼图 | 横向三等分布局，适用于对比图和产品展示 |
| 图片导出 | 高清 PNG 导出（3x 像素比），支持保存到本地和系统分享 |
| 模板推荐 | 首页展示热门模板卡片（装饰性展示） |

### 编辑器功能

- **间距控制**：0px / 2px / 4px 三档可选
- **圆角控制**：0 / 8 / 16 三档可选
- **背景色**：6 种预设颜色（白色、黑色、暖橙、浅绿、浅蓝、浅粉）
- **图片排序**：拖拽调整图片显示顺序
- **空位填充**：图片不足时自动显示占位图标

### 后续可扩展方向

- 滤镜系统（黑白 / 暖色 / 胶片）
- 裁剪、旋转、缩放编辑
- JSON 驱动的模板系统
- 自定义模板保存
- AI 自动排版
- 一键生成小红书封面
- 模板商店
- 云同步作品
- 社交分享社区

## 技术架构

### 技术栈

| 模块 | 技术选型 |
|------|----------|
| 框架 | Flutter (Material 3) |
| 状态管理 | Provider |
| 图片选择 | image_picker |
| 图片渲染 | RenderRepaintBoundary + dart:ui |
| 文件存储 | path_provider |
| 图片分享 | share_plus |
| 权限管理 | permission_handler |

### 架构分层

```
UI 层（Pages / Widgets）
        ↓
状态管理层（PuzzleProvider - ChangeNotifier）
        ↓
拼图渲染层（GridView / Row + RepaintBoundary）
        ↓
图片处理层（dart:ui toImage + PNG 编码）
        ↓
本地存储层（path_provider + File）
```

## 项目结构

```
lib/
├── main.dart                      # 应用入口，Provider 注册 + 主题配置
├── models/
│   └── selected_image.dart        # 图片模型 + 布局类型枚举
├── providers/
│   └── puzzle_provider.dart       # 核心状态管理（图片列表、样式参数）
├── pages/
│   ├── home_page.dart             # 首页（Banner + 快捷入口 + 模板推荐）
│   ├── picker_page.dart           # 图片选择页（多选 + 拖拽排序）
│   ├── grid_edit_page.dart        # 3×3 九宫格编辑器
│   ├── row_edit_page.dart         # 横向三栏编辑器
│   └── export_page.dart           # 导出页（预览 + 保存 + 分享）
└── utils/
    └── image_exporter.dart        # 图片捕获与保存工具
```

### 页面导航流程

```
首页 (HomePage)
  ├── 九宫格/三栏 入口
  │     ↓
  ├── 图片选择页 (PickerPage)
  │     ↓
  ├── 编辑页 (GridEditPage / RowEditPage)
  │     ↓
  └── 导出页 (ExportPage)
```

## 环境要求

- Flutter SDK >= 3.12.1
- Dart SDK >= 3.12.1
- Android: minSdkVersion 21+
- iOS: 12.0+

## 快速开始

### 1. 克隆项目

```bash
cd flutter_application_1
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 运行项目

```bash
# 连接 Android 设备或模拟器
flutter run

# 或指定设备
flutter run -d <device_id>
```

### 4. 构建发布版本

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 平台权限配置

### Android

已配置以下权限（`AndroidManifest.xml`）：

- `READ_EXTERNAL_STORAGE` - 读取相册图片
- `WRITE_EXTERNAL_STORAGE` - 保存图片（API <= 32）
- `READ_MEDIA_IMAGES` - 读取图片（API >= 33）
- `CAMERA` - 相机权限

### iOS

已配置以下权限（`Info.plist`）：

- `NSCameraUsageDescription` - 相机使用说明
- `NSPhotoLibraryUsageDescription` - 相册读取说明
- `NSPhotoLibraryAddUsageDescription` - 相册保存说明

## 使用说明

1. 打开应用，在首页选择拼图模式：
   - **Quick Puzzle** → 进入九宫格拼图
   - **Stitch** → 进入横向三栏拼图
   - **3x3 Grid** → 进入九宫格拼图
2. 从相册选择图片（最多 9 张 / 3 张）
3. 可拖拽调整图片顺序，完成后点击「Start Puzzle」
4. 在编辑器中调整间距、圆角、背景色
5. 点击「Export Puzzle」生成高清图片
6. 在导出页可「Save to Album」保存或「Share」分享

## 依赖说明

| 包名 | 版本 | 用途 |
|------|------|------|
| `image_picker` | ^1.1.2 | 从相册多选图片 |
| `provider` | ^6.1.2 | 全局状态管理 |
| `path_provider` | ^2.1.4 | 获取本地文件路径 |
| `permission_handler` | ^11.3.1 | 运行时权限请求 |
| `share_plus` | ^9.0.0 | 系统分享功能 |

## 许可证

本项目仅供学习参考使用。
