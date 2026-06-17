# Windows 桌面应用 DESIGN.md 生成器 Skill

一个用于分析 Windows 桌面应用项目并生成 DESIGN.md 文件的 Skill，支持 AI 驱动的 UI 生成。

## 功能特性

- **多框架支持**: WPF、WinForms、Electron、UWP、WinUI 3、MAUI、Qt、Tauri、Flutter、Flet
- **设计令牌提取**: 颜色、排版、间距、组件
- **桌面端特定分析**: 窗口框架、菜单系统、键盘快捷键、系统集成
- **模板化生成**: 标准化的 DESIGN.md 输出
- **验证清单**: 确保质量和完整性
- **跨平台支持**: Flutter 和 Flet 支持使用现代 UI 框架进行 Windows 桌面开发

## 目录结构

```
windows-desktop-design/
├── SKILL.md                        # Skill 定义和说明
├── README.md                       # 英文说明文档
├── README.zh-CN.md                 # 中文说明文档
├── templates/
│   └── desktop-design-template.md  # DESIGN.md 模板
└── scripts/
    ├── extract-wpf-colors.ps1      # WPF 设计令牌提取脚本
    ├── extract-electron-design.js  # Electron 设计令牌提取脚本
    ├── extract-winforms-design.ps1 # WinForms 设计令牌提取脚本
    ├── extract-flutter-design.dart # Flutter 设计令牌提取脚本
    └── extract-flet-design.py      # Flet 设计令牌提取脚本
```

## 使用方法

1. **调用 Skill**: 在处理 Windows 桌面项目时调用本 Skill
2. **分析项目**: Skill 自动检测框架并提取设计令牌
3. **生成 DESIGN.md**: 基于提取的令牌和桌面端特定模式生成文档
4. **验证**: 使用提供的检查清单确保完整性

## 支持的框架

| 框架 | 提取脚本 | 语言 |
|------|----------|------|
| WPF | `extract-wpf-colors.ps1` | PowerShell |
| WinForms | `extract-winforms-design.ps1` | PowerShell |
| Electron | `extract-electron-design.js` | JavaScript |
| Flutter | `extract-flutter-design.dart` | Dart |
| Flet | `extract-flet-design.py` | Python |
| UWP/WinUI 3 | 手动分析（待开发） | C# |
| MAUI | 手动分析（待开发） | C# |
| Qt | 手动分析（待开发） | C++ |
| Tauri | 手动分析（待开发） | Rust |

## 设计令牌分类

### 颜色
- 品牌/主色调
- 表面色（窗口背景、面板）
- 文字颜色
- 边框/分隔线颜色
- 语义颜色（成功、警告、错误）
- 强调色

### 排版
- 字体家族
- 字号层级（标题、正文、说明文字）
- 字重和行高

### 间距与布局
- 基准间距单位
- 间距刻度
- 容器宽度和内边距

### 组件
- 窗口标题栏
- 侧边栏导航
- 工具栏
- 状态栏
- 按钮、输入框、卡片、对话框
- 菜单（主菜单、上下文菜单）

### 桌面端特定
- 窗口框架样式
- 菜单系统样式
- 键盘快捷键
- 系统托盘/任务栏集成

## 框架特定注意事项

### Flutter 桌面

**窗口管理**:
- Flutter 桌面应用默认使用原生窗口框架
- 可通过 `window_manager` 包自定义标题栏
- 支持窗口调整大小、最小化、最大化

**Material Design 3**:
- Flutter 默认使用 Material Design 3
- 包含全面的主题系统
- 支持明暗模式切换
- 颜色方案从种子颜色自动生成

**平台适配**:
- Flutter 适配 Windows 平台约定
- 使用原生滚动条、对话框和菜单
- 支持 Windows 特定的手势和交互

**关键 Flutter 文件**:
- `lib/theme.dart` - 主主题配置
- `lib/constants/colors.dart` - 颜色定义
- `lib/constants/spacing.dart` - 间距常量
- `lib/constants/typography.dart` - 排版定义

### Flet 桌面

**基于 Flutter**:
- Flet 构建于 Flutter 之上，共享相同的渲染引擎
- 使用 Material Design 3 组件
- 通过 `ft.Theme` 支持自定义主题

**Python 集成**:
- 设计令牌定义在 Python 文件中
- 使用 `ft.Color`、`ft.TextStyle`、`ft.Theme` 类
- 支持运行时动态主题切换

**窗口配置**:
- 窗口属性在 `ft.app()` 调用中设置
- 支持自定义窗口标题和图标
- 可配置窗口大小和位置

**关键 Flet 文件**:
- `main.py` - 主应用入口
- `theme/colors.py` - 颜色定义
- `theme/typography.py` - 排版设置
- `theme/spacing.py` - 间距常量
- `constants.py` - 全局常量

## 运行脚本

### WPF 项目分析
```powershell
.\scripts\extract-wpf-colors.ps1
Analyze-WpfProject -ProjectPath "C:\Projects\MyWpfApp"
```

### WinForms 项目分析
```powershell
.\scripts\extract-winforms-design.ps1
Analyze-WinFormsProject -ProjectPath "C:\Projects\MyWinFormsApp"
```

### Electron 项目分析
```powershell
node .\scripts\extract-electron-design.js "C:\Projects\MyElectronApp"
```

### Flutter 项目分析
```powershell
dart .\scripts\extract-flutter-design.dart "C:\Projects\MyFlutterApp"
```

**Flutter 项目结构**:
```
lib/
├── main.dart
├── theme.dart
├── constants/
│   ├── colors.dart
│   ├── spacing.dart
│   └── typography.dart
├── widgets/
│   ├── custom_widgets/
│   └── components/
└── screens/
```

**Flutter 提取的设计令牌**:
- 颜色：`Color(0xFF...)`、`Color.fromARGB()`、`Color.fromRGBO()`
- 排版：`TextStyle`、`TextTheme`、`GoogleFonts`
- 间距：`EdgeInsets`、`SizedBox`、`Gap`
- 组件：Flutter 组件和自定义类

### Flet 项目分析
```powershell
python .\scripts\extract-flet-design.py "C:\Projects\MyFletApp"
```

**Flet 项目结构**:
```
main.py
components/
├── custom_widgets.py
└── views.py
theme/
├── colors.py
├── typography.py
└── spacing.py
constants.py
requirements.txt
```

**Flet 提取的设计令牌**:
- 颜色：`ft.Color()`、`ft.Colors`、`ft.Color.from_rgb()`
- 排版：`ft.TextStyle`、`ft.TextTheme`
- 间距：`ft.padding`、`ft.margin`、`ft.gap`
- 组件：Flet 组件（ElevatedButton、TextField、Card 等）

## 输出格式

生成的 DESIGN.md 遵循 Google Stitch 规范，并包含桌面端特定扩展：

```markdown
---
version: alpha
name: MyApp-desktop-design
description: Windows 桌面应用，深色主题
platform: windows
framework: wpf
---

## Overview
...

## Colors
...

## Typography
...

## Window System
...

## Menu System
...

## Keyboard Shortcuts
...

## System Integration
...
```

### Flutter/Flet Frontmatter 示例

```markdown
---
version: alpha
name: MyApp-flutter-desktop-design
description: Flutter 桌面应用，使用 Material Design 3
platform: windows
framework: flutter
---

## Overview
...

## Colors
...

## Typography
...

## Components
...

## Window System
...
```

## 验证

生成 DESIGN.md 后，请验证以下内容：
- 所有颜色令牌都有十六进制值
- 排版令牌包含字体家族、大小、字重、行高
- 间距令牌遵循一致的刻度
- 组件定义包含所有状态（默认、悬停、按下、禁用）
- 桌面端特定章节已存在
- Markdown 格式有效

## 参考链接

- [Google Stitch DESIGN.md 规范](https://stitch.withgoogle.com/docs/design-md/specification/)
- [Awesome DESIGN.md 集合](https://github.com/VoltAgent/awesome-design-md)
- [WPF 资源概述](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/fundamentals/resources-overview)
- [Electron 主题指南](https://www.electronjs.org/docs/latest/tutorial/themes)
- [Flutter 桌面文档](https://docs.flutter.dev/desktop)
- [Flutter Material Design 3](https://m3.material.io/develop/flutter)
- [Flet 文档](https://flet.dev/docs/)
- [Flet 主题指南](https://flet.dev/docs/guides/python/theming/)