---
name: "windows-desktop-design"
description: "根据用户提供的Windows桌面应用项目源码文件夹路径/软件截图，分析项目的设计令牌（颜色、排版、间距、圆角、阴影、组件），按照Windows桌面设计模板生成便于AI驱动UI生成的、全面的 DESIGN.md 文件。按照分析源码或图片-确认-生成-审计-优化的小型 harness 流程进行。触发条件：分析Windows桌面应用项目的界面样式/ 生成Windows桌面软件的设计令牌。Windows桌面应用项目包括但不限于Flet、Flutter、WPF、WinForms、Electron、UWP或其他Windows桌面框架。"
---

# Windows 桌面 DESIGN.md 生成器

## 背景

Windows 桌面应用项目的设计属性往往散落在源码各处——XAML 资源字典、CSS 变量、Dart 主题类、Python 配置文件，甚至直接硬编码在控件属性中。这种分散导致 AI 编码代理无法准确理解应用的视觉风格，生成的 UI 与原有设计不一致。本 Skill 的核心价值是：**从源码中系统提取设计令牌，生成结构化的 DESIGN.md**，使 AI 编码代理能够生成与应用视觉风格匹配的 UI。

## 边界

**进入条件：** 当前项目为 Windows 桌面应用项目。

**不进入：** 非桌面项目（纯 Web 应用、移动端 App、后端服务、命令行工具）。如果当前项目不是 Windows 桌面应用项目，说明原因，停止使用此 Skill。

**输入类型路由：**

| 用户给的东西  | 该做的          |
| ------- | ------------ |
| 源码文件夹路径 | 进入分析流程       |
| 软件截图    | 基于视觉分析提取令牌   |
| 两者都有    | 源码为主，截图补充验证  |
| 什么都没给   | 反问：需要项目路径或截图 |

## 工作流

1. **接入判断** — 判断是否进入本 Skill + 识别输入类型
2. **项目探索** — 扫描项目结构、识别框架、定位关键文件
3. **令牌提取** — 按六大维度提取设计令牌，内联自检
4. **提取确认（必须停）** — 逐项确认提取结果，等用户答复后再继续
5. **DESIGN.md 生成** — 按模板填充令牌值，生成完整文档
6. **审计与修复** — 验证清单逐项检查，发现问题则最小切片修复
7. **交付确认（必须停）** — 确认交付决策

## 提取方式

从源码中直接提取设计值，无论项目是否已有令牌定义：

- **有令牌文件**（如 `theme.dart`、`colors.css`）：直接读取并映射
- **无令牌文件**（代码中硬编码）：使用提取脚本扫描源码，收集所有硬编码值，归纳为令牌
- **框架默认主题**：补充框架默认主题的令牌值

提取后按 **原始值 → 语义名称 → 组件绑定** 的层次组织，生成 DESIGN.md。

## 支持的框架

- **WPF** (.NET / .NET Core)
- **WinForms** (.NET Framework / .NET)
- **Electron** (JavaScript/TypeScript)
- **UWP** (通用 Windows 平台)
- **MAUI** (.NET 多平台应用 UI)
- **WinUI 3**
- **Qt** (C++)
- **Tauri** (Rust)
- **Flutter** (Dart - 跨平台桌面)
- **Flet** (Python - 基于 Flutter 的桌面)

## 调用条件

在以下情况下调用此技能：

1. 用户要求分析 Windows 桌面项目的设计令牌
2. 用户希望为桌面应用生成 DESIGN.md
3. 用户正在开发桌面应用并需要一致的 UI 生成
4. 用户希望记录桌面应用的设计系统

## 1. 接入判断

根据"边界"章节的输入类型路由，判断是否进入本 Skill，并确定输入类型。

- 如果用户提供了源码路径，确认路径可访问
- 如果用户提供了截图，记录截图数量和内容
- 如果两者都有，以源码为主、截图为辅
- 如果什么都没给，停下来反问用户

## 2. 项目探索

**识别项目类型和结构：**

- 扫描 `.csproj`、`.sln`、`package.json`、`CMakeLists.txt` 等文件
- 确定使用的 UI 框架
- 识别关键目录（Views、Controls、Resources、Assets）

**示例项目结构：**

```
WPF/WinForms:
├── Properties/
├── Resources/
│   ├── Styles.xaml (WPF)
│   ├── Resources.resx
│   └── Settings.settings
├── Views/
├── Controls/
└── MainWindow.xaml (WPF) / Form1.cs (WinForms)

Electron:
├── src/
│   ├── main/
│   ├── renderer/
│   │   ├── components/
│   │   ├── styles/
│   │   └── themes/
│   └── package.json

Flutter:
├── lib/
│   ├── main.dart
│   ├── theme.dart
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── spacing.dart
│   │   └── typography.dart
│   ├── widgets/
│   │   ├── custom_widgets/
│   │   └── components/
│   └── screens/
├── pubspec.yaml
└── windows/

Flet:
├── main.py
├── components/
│   ├── custom_widgets.py
│   └── views.py
├── theme/
│   ├── colors.py
│   ├── typography.py
│   └── spacing.py
├── constants.py
└── requirements.txt
```

## 3. 设计令牌提取

### 一、色彩体系

**WPF:**

- 从 `App.xaml` ResourceDictionary 提取颜色
- 查找 `SolidColorBrush` 定义
- 从 XAML 解析十六进制值

**WinForms:**

- 从 `Properties/Resources.resx` 提取颜色
- 检查 `.Designer.cs` 文件中的控件属性
- 查找 `Color` 结构体用法

**Electron:**

- 扫描 CSS 文件中的颜色变量（`--color-*`）
- 从主题文件（如 `theme.json`）提取
- 检查 SCSS/Sass 变量

**UWP/WinUI:**

- 从 `Resources.xaml` 提取
- 查找 `ResourceDictionary` 条目

**Flutter:**

- 从 `lib/theme.dart` 或 `lib/styles.dart` 提取
- 查找 `Color` 类实例化和 `ColorScheme` 定义
- 从 `Color(0xFF...)` 格式解析十六进制值
- 检查 `MaterialApp` 主题配置

**Flet:**

- 从使用 `ft.Color` 和 `ft.Theme` 类的 Python 文件提取
- 在 `main.py` 或主题模块中查找颜色定义
- 从 `ft.Colors` 或自定义 `ft.Color` 实例解析十六进制值
- 检查 `ft.app()` 主题配置

**分类：**

- 品牌色/主色调
- 表面色（窗口背景、面板）
- 文字颜色（主要、次要、禁用）
- 边框/分割线颜色
- 语义颜色（成功、警告、错误、信息）
- 强调色

### 二、排版体系

**WPF:**

- 从 `FontFamily`、`FontSize`、`FontWeight` 属性提取
- 查找针对 `TextBlock`、`Label`、`Button` 的 `Style` 定义

**WinForms:**

- 从 `.Designer.cs` 中的控件 Font 属性提取
- 检查 `Font` 类实例化

**Electron:**

- 从 CSS font-family、font-size、font-weight 提取
- 从主题文件解析字体层级

**Flutter:**

- 从 `TextStyle` 和 `TextTheme` 定义提取
- 查找 `ThemeData.textTheme` 配置
- 解析 `GoogleFonts` 或自定义字体家族定义
- 检查 `MaterialApp` 主题排版设置

**Flet:**

- 从 `ft.TextTheme` 和 `ft.TextStyle` 配置提取
- 在 Python 文件中查找 `ft.TextStyle` 实例化
- 从 `ft.TextStyle` 参数解析字体家族和大小
- 检查 `ft.app()` 主题文本配置

**分类：**

- 字体家族（主要、次要、等宽）
- 字号层级（标题、正文、说明文字）
- 字重和行高

### 三、空间与尺寸

**WPF:**

- 提取 `Margin`、`Padding`、`Width`、`Height` 值
- 查找 XAML 中定义的间距资源

**WinForms:**

- 从 `.Designer.cs` 提取控件位置和大小
- 检查 `Margin`、`Padding` 属性

**Electron:**

- 从 CSS 间距工具类提取
- 解析 flex/grid 布局模式

**Flutter:**

- 从 `EdgeInsets` 和 `SizedBox` 用法提取
- 查找 `constants.dart` 或 `spacing.dart` 中定义的间距常量
- 解析 `ThemeData` 间距配置
- 检查 `Padding`、`Margin` 和 `Gap` 组件模式

**Flet:**

- 从 `ft.padding`、`ft.margin` 属性提取
- 在 Python 文件中查找间距常量
- 解析 `ft.Container` 和 `ft.Column`/`ft.Row` 间距配置
- 检查 `ft.app()` 主题间距设置

**分类：**

- 基础间距单位（通常基于 4px 或 8px 的倍数）
- 间距刻度（xs、sm、md、lg、xl）
- 容器宽度和内边距

### 四、圆角与边框

**WPF:**

- 从 `BorderBrush`、`BorderThickness`、`CornerRadius` 属性提取
- 查找 Style 中定义的边框和圆角样式

**WinForms:**

- 从控件属性中提取 BorderStyle、FlatStyle
- 检查 `.Designer.cs` 中的相关属性

**Electron:**

- 从 CSS border-radius、border-width、border-style 提取
- 查找 CSS 变量定义

**Flutter:**

- 从 `BorderRadius`、容器装饰（Decoration）提取
- 查找主题中的 `ShapeDecoration` 或 `RoundedRectangleBorder`
- 检查 `MaterialApp` 主题圆角配置

**Flet:**

- 从 `ft.Container` 的 `border_radius` 属性提取
- 查找 `ft.Border` 相关配置
- 检查主题中的圆角设置

**分类：**

- 圆角半径（sm、md、lg、full）
- 边框宽度（thin、medium、thick）
- 边框样式（solid、dashed）

### 五、阴影与景深

**WPF:**

- 从 `DropShadowEffect`、`Effect` 属性提取
- 查找 XAML 中定义的阴影资源

**WinForms:**

- 从控件的 FlatStyle 和相关属性提取
- 检查第三方控件库的阴影设置

**Electron:**

- 从 CSS box-shadow 提取
- 解析 `0px 4px 12px rgba(0,0,0,0.1)` 格式

**Flutter:**

- 从 `BoxShadow`、高度（elevation）提取
- 查找 `Material` 组件的 elevation 属性
- 检查主题中的阴影配置

**Flet:**

- 从 `ft.Container` 的阴影属性提取
- 查找 `ft.BoxShadow` 相关配置
- 检查主题中的海拔设置

**分类：**

- 投影参数（X/Y 偏移、模糊、扩散、颜色）
- 海拔层级（Elevation level）
- 内阴影（如有）

### 六、Windows 特定元素

**窗口框架:**

- 标题栏高度和样式
- 窗口边框圆角
- 最小化/最大化/关闭按钮样式
- 窗口阴影

**菜单系统:**

- 主菜单栏样式
- 上下文菜单外观
- 菜单项悬停状态

**系统集成:**

- 任务栏图标样式
- 系统托盘提示
- 对话框行为

**键盘快捷键:**

- 常见快捷键模式

**提取完成后，对照验证清单内联自检，按结论修复后再进入步骤 4。**

## 4. 提取确认（必须停）

提取完成并自检通过后，**必须停下来让用户确认**，不要静默继续。

**禁止静默替用户选择。** 可以推荐（"我推荐 X，因为 …"），但不能说"已经替你定了 X，如果不对告诉我"。

**必须独立确认的项：**

| # | 决策项       | 说明                     |
| - | --------- | ---------------------- |
| 1 | 框架识别是否正确  | 确认检测到的 UI 框架           |
| 2 | 提取的令牌是否完整 | 确认六大维度覆盖情况             |
| 3 | 令牌组织方式    | 原始值 / 语义名称 / 组件绑定，确认层次 |
| 4 | 输出语言      | 中文 / 英文 / 跟随源码         |

每项独立确认，不要打包成"全部 OK 吗？"。全部收齐答复后才能进入步骤 5。

## 5. DESIGN.md 生成

按照标准格式生成 DESIGN.md，包含桌面特定扩展。使用 `templates/desktop-design-template.md` 作为模板，将提取的令牌值填充到对应占位符。

**标准章节:**

1. Frontmatter（版本、名称、描述）
2. Colors（颜色令牌 YAML 块）
3. Typography（排版令牌 YAML 块）
4. Spacing（空间令牌 YAML 块）
5. Border & Corner（圆角边框令牌 YAML 块）
6. Shadow & Elevation（阴影景深令牌 YAML 块）
7. Components（组件令牌 YAML 块）
8. Overview（详细描述）
9. Colors（详细分类）
10. Typography（详细分类）
11. Spacing（详细分类）
12. Border & Corner（详细分类）
13. Shadow & Elevation（详细分类）
14. Components（详细组件规格）
15. Do's and Don'ts
16. Responsive Behavior

**桌面特定章节:**
17\. Window System（窗口系统）
18\. Menu System（菜单系统）
19\. Keyboard Shortcuts（键盘快捷键）
20\. System Integration（系统集成）

## 6. 审计与修复

生成 DESIGN.md 后，按验证清单逐项检查：

- 发现问题 → 最小切片修复（只改有问题的部分，不重写整篇）
- 修复后重新验证受影响项
- 修复完成后再汇报"做完了 + 自检结论 + 改了什么"

**禁止：** 只反馈问题但不修复就直接汇报；为修一处而重写整篇。

## 7. 交付确认（必须停）

审计修复完成后，**必须停下来让用户确认交付决策**，不要静默导出。

确认选项：

- 通过，交付 DESIGN.md
- 还有局部修复，我会列出具体修哪里
- 先停一停，我要再看看

收到用户确认后才算完成。

## 默认策略

- **输出语言：** 跟随源码语言（用户指定则用指定语言）
- **令牌组织：** 原始值 → 语义名称 → 组件绑定
- **模板：** 使用 `templates/desktop-design-template.md`
- **提取范围：** 六大维度全覆盖
- **命名约定：** 按用途命名令牌（如 `surface-dark`、`text-primary`），而非按值命名
- **组件状态：** 包含默认、悬停、按下、禁用四种状态

## 验证清单

生成 DESIGN.md 后，请验证：

- [ ] 所有颜色令牌都有十六进制值
- [ ] 排版令牌包含字体家族、大小、字重、行高
- [ ] 空间令牌遵循一致的间距刻度
- [ ] 圆角边框令牌有明确的半径和宽度值
- [ ] 阴影景深令牌有完整的投影参数
- [ ] 组件令牌正确引用语义令牌（无硬编码值）
- [ ] 组件定义包含所有状态（默认、悬停、按下、禁用）
- [ ] 桌面特定章节（窗口、菜单、快捷键）已存在
- [ ] Markdown 格式有效

## 使用示例

**用户请求:**
"为我在 C:\Projects\MyApp 的 WPF 项目生成 DESIGN.md"

**技能执行:**

1. 扫描项目结构并识别 WPF 框架
2. 从 XAML ResourceDictionary 和控件属性中提取六大维度令牌
3. 按原始值 → 语义名称 → 组件绑定的层次组织令牌
4. 内联自检，确认提取完整性
5. 停下来让用户确认框架识别、令牌完整性、组织方式、输出语言
6. 使用模板填充生成包含桌面特定章节的综合 DESIGN.md
7. 按验证清单审计，修复问题
8. 停下来让用户确认交付

## 最佳实践

1. **全面提取:** 提取所有可见的设计令牌，不只是明显的那些
2. **语义命名:** 按用途命名令牌（如 `surface-dark`、`text-primary`），而非按颜色值命名
3. **避免硬编码:** 组件令牌应引用语义令牌，而非直接使用原始值
4. **文档化状态:** 包含交互组件的悬停、按下、聚焦和禁用状态
5. **遵循约定:** 使用与 Awesome DESIGN.md 集合一致的命名
6. **验证:** 如果可用，运行 `npx @google/design.md lint DESIGN.md`

## 参考链接

- [Google Stitch DESIGN.md 规范](https://stitch.withgoogle.com/docs/design-md/specification/)
- [Awesome DESIGN.md 集合](https://github.com/VoltAgent/awesome-design-md)
- [WPF ResourceDictionary 文档](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/fundamentals/resources-overview)
- [Electron 主题指南](https://www.electronjs.org/docs/latest/tutorial/themes)

