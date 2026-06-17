# Windows Desktop DESIGN.md Generator Skill

A skill for analyzing Windows desktop application projects and generating DESIGN.md files for AI-powered UI generation.

## Features

- **Multi-framework support**: WPF, WinForms, Electron, UWP, WinUI 3, MAUI, Qt, Tauri, Flutter, Flet
- **Design token extraction**: Colors, typography, spacing, components
- **Desktop-specific analysis**: Window frames, menu systems, keyboard shortcuts, system integration
- **Template-based generation**: Standardized DESIGN.md output
- **Validation checklist**: Ensure quality and completeness
- **Cross-platform support**: Flutter and Flet enable Windows desktop development with modern UI frameworks

## Directory Structure

```
windows-desktop-design/
├── SKILL.md                        # Skill definition and instructions
├── README.md                       # English documentation
├── README.zh-CN.md                 # Chinese documentation
├── templates/
│   └── desktop-design-template.md  # DESIGN.md template
└── scripts/
    ├── extract-wpf-colors.ps1      # WPF design token extraction
    ├── extract-electron-design.js  # Electron design token extraction
    ├── extract-winforms-design.ps1 # WinForms design token extraction
    ├── extract-flutter-design.dart # Flutter design token extraction
    └── extract-flet-design.py      # Flet design token extraction
```

## Usage

1. **Invoke the skill** when working with Windows desktop projects
2. **Analyze the project** - the skill will automatically detect the framework and extract design tokens
3. **Generate DESIGN.md** - based on extracted tokens and desktop-specific patterns
4. **Validate** - use the provided checklist to ensure completeness

## Supported Frameworks

| Framework | Extraction Script | Language |
|-----------|-------------------|----------|
| WPF | `extract-wpf-colors.ps1` | PowerShell |
| WinForms | `extract-winforms-design.ps1` | PowerShell |
| Electron | `extract-electron-design.js` | JavaScript |
| Flutter | `extract-flutter-design.dart` | Dart |
| Flet | `extract-flet-design.py` | Python |
| UWP/WinUI 3 | Manual analysis (future script) | C# |
| MAUI | Manual analysis (future script) | C# |
| Qt | Manual analysis (future script) | C++ |
| Tauri | Manual analysis (future script) | Rust |

## Design Token Categories

### Colors
- Brand/Primary colors
- Surface colors (window backgrounds, panels)
- Text colors
- Border/Hairline colors
- Semantic colors (success, warning, error)
- Accent colors

### Typography
- Font families
- Type scale (hero, headings, body, captions)
- Font weights and line heights

### Spacing & Layout
- Base spacing unit
- Spacing scale
- Container widths and gutters

### Components
- Window title bar
- Sidebar navigation
- Toolbars
- Status bar
- Buttons, inputs, cards, dialogs
- Menus (main, context)

### Desktop-Specific
- Window frame styles
- Menu system styles
- Keyboard shortcuts
- System tray/taskbar integration

## Framework-Specific Considerations

### Flutter Desktop

**Window Management:**
- Flutter desktop apps use native window frames by default
- Can customize window title bar with `window_manager` package
- Supports window resizing, minimization, maximization

**Material Design 3:**
- Flutter uses Material Design 3 by default
- Includes comprehensive theming system
- Supports light/dark mode switching
- Color schemes automatically generated from seed colors

**Platform Adaptation:**
- Flutter adapts UI to Windows platform conventions
- Uses native scrollbars, dialogs, and menus
- Supports Windows-specific gestures and interactions

**Key Flutter Files:**
- `lib/theme.dart` - Main theme configuration
- `lib/constants/colors.dart` - Color definitions
- `lib/constants/spacing.dart` - Spacing constants
- `lib/constants/typography.dart` - Typography definitions

### Flet Desktop

**Flutter-Based:**
- Flet is built on Flutter, sharing the same rendering engine
- Uses Material Design 3 components
- Supports custom theming through `ft.Theme`

**Python Integration:**
- Design tokens defined in Python files
- Uses `ft.Color`, `ft.TextStyle`, `ft.Theme` classes
- Supports dynamic theming at runtime

**Window Configuration:**
- Window properties set in `ft.app()` call
- Supports custom window title and icon
- Can configure window size and position

**Key Flet Files:**
- `main.py` - Main application entry point
- `theme/colors.py` - Color definitions
- `theme/typography.py` - Typography settings
- `theme/spacing.py` - Spacing constants
- `constants.py` - Global constants

## Running Scripts

### WPF Analysis
```powershell
.\scripts\extract-wpf-colors.ps1
Analyze-WpfProject -ProjectPath "C:\Projects\MyWpfApp"
```

### WinForms Analysis
```powershell
.\scripts\extract-winforms-design.ps1
Analyze-WinFormsProject -ProjectPath "C:\Projects\MyWinFormsApp"
```

### Electron Analysis
```powershell
node .\scripts\extract-electron-design.js "C:\Projects\MyElectronApp"
```

### Flutter Analysis
```powershell
dart .\scripts\extract-flutter-design.dart "C:\Projects\MyFlutterApp"
```

**Flutter Project Structure:**
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

**Flutter Design Tokens Extracted:**
- Colors from `Color(0xFF...)`, `Color.fromARGB()`, `Color.fromRGBO()`
- Typography from `TextStyle`, `TextTheme`, `GoogleFonts`
- Spacing from `EdgeInsets`, `SizedBox`, `Gap`
- Components from Flutter widgets and custom classes

### Flet Analysis
```powershell
python .\scripts\extract-flet-design.py "C:\Projects\MyFletApp"
```

**Flet Project Structure:**
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

**Flet Design Tokens Extracted:**
- Colors from `ft.Color()`, `ft.Colors`, `ft.Color.from_rgb()`
- Typography from `ft.TextStyle`, `ft.TextTheme`
- Spacing from `ft.padding`, `ft.margin`, `ft.gap`
- Components from Flet widgets (ElevatedButton, TextField, Card, etc.)

## Output Format

The generated DESIGN.md follows the Google Stitch specification with desktop-specific extensions:

```markdown
---
version: alpha
name: MyApp-desktop-design
description: Windows desktop application with dark theme
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

### Flutter/Flet Frontmatter Example

```markdown
---
version: alpha
name: MyApp-flutter-desktop-design
description: Flutter desktop application with Material Design 3
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

## Validation

After generating DESIGN.md, verify:
- All color tokens have hex values
- Typography tokens include font family, size, weight, line height
- Spacing tokens follow a consistent scale
- Component definitions include all states
- Desktop-specific sections are present
- Markdown formatting is valid

## References

- [Google Stitch DESIGN.md Specification](https://stitch.withgoogle.com/docs/design-md/specification/)
- [Awesome DESIGN.md Collection](https://github.com/VoltAgent/awesome-design-md)
- [WPF Resources Overview](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/fundamentals/resources-overview)
- [Electron Theme Guidelines](https://www.electronjs.org/docs/latest/tutorial/themes)
- [Flutter Desktop Documentation](https://docs.flutter.dev/desktop)
- [Flutter Material Design 3](https://m3.material.io/develop/flutter)
- [Flet Documentation](https://flet.dev/docs/)
- [Flet Theming Guide](https://flet.dev/docs/guides/python/theming/)