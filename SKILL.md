---
name: "windows-desktop-design"
description: "Analyzes Windows desktop application projects and generates DESIGN.md files for AI-powered UI generation. Invoke when working with WPF, WinForms, Electron, UWP, or other Windows desktop frameworks."
---

# Windows Desktop DESIGN.md Generator

## Overview

This skill analyzes Windows desktop application projects to extract design tokens (colors, typography, spacing, components) and generates a comprehensive DESIGN.md file. The generated DESIGN.md enables AI coding agents to produce UI that matches the application's visual style.

## Supported Frameworks

- **WPF** (.NET / .NET Core)
- **WinForms** (.NET Framework / .NET)
- **Electron** (JavaScript/TypeScript)
- **UWP** (Universal Windows Platform)
- **MAUI** (.NET Multi-platform App UI)
- **WinUI 3**
- **Qt** (C++)
- **Tauri** (Rust)
- **Flutter** (Dart - Cross-platform Desktop)
- **Flet** (Python - Flutter-based Desktop)

## Invocation Conditions

Invoke this skill when:
1. User asks to analyze a Windows desktop project for design tokens
2. User wants to generate a DESIGN.md for a desktop application
3. User is working on a desktop app and needs consistent UI generation
4. User wants to document the design system of a desktop application

## Analysis Workflow

### Step 1: Project Exploration

**Identify project type and structure:**
- Scan for `.csproj`, `.sln`, `package.json`, `CMakeLists.txt`, etc.
- Determine the UI framework used
- Identify key directories (Views, Controls, Resources, Assets)

**Example project structures:**
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

### Step 2: Design Token Extraction

#### Color Palette

**WPF:**
- Extract colors from `App.xaml` ResourceDictionary
- Look for `SolidColorBrush` definitions
- Parse hex values from XAML

**WinForms:**
- Extract colors from `Properties/Resources.resx`
- Check control properties in `.Designer.cs` files
- Look for `Color` struct usages

**Electron:**
- Scan CSS files for color variables (`--color-*`)
- Extract from theme files (e.g., `theme.json`)
- Check SCSS/Sass variables

**UWP/WinUI:**
- Extract from `Resources.xaml`
- Look for `ResourceDictionary` entries

**Flutter:**
- Extract from `lib/theme.dart` or `lib/styles.dart`
- Look for `Color` class instantiations and `ColorScheme` definitions
- Parse hex values from `Color(0xFF...)` format
- Check `MaterialApp` theme configurations

**Flet:**
- Extract from Python files using `ft.Color` and `ft.Theme` classes
- Look for color definitions in `main.py` or theme modules
- Parse hex values from `ft.Colors` or custom `ft.Color` instances
- Check `ft.app()` theme configurations

**Key color categories:**
- Primary/Brand colors
- Surface colors (window backgrounds, panels)
- Text colors (foreground)
- Border/Hairline colors
- Semantic colors (success, warning, error)
- Accent colors

#### Typography

**WPF:**
- Extract from `FontFamily`, `FontSize`, `FontWeight` properties
- Look for `Style` definitions targeting `TextBlock`, `Label`, `Button`

**WinForms:**
- Extract from control Font properties in `.Designer.cs`
- Check `Font` class instantiations

**Electron:**
- Extract from CSS font-family, font-size, font-weight
- Parse type scale from theme files

**Flutter:**
- Extract from `TextStyle` and `TextTheme` definitions
- Look for `ThemeData.textTheme` configurations
- Parse `GoogleFonts` or custom font family definitions
- Check `MaterialApp` theme typography settings

**Flet:**
- Extract from `ft.TextTheme` and `ft.TextStyle` configurations
- Look for `ft.TextStyle` instantiations in Python files
- Parse font family and size from `ft.TextStyle` parameters
- Check `ft.app()` theme text configurations

**Key typography tokens:**
- Font families (primary, secondary, monospace)
- Type scale (hero, heading-1-6, body, caption, micro)
- Font weights and line heights

#### Spacing & Layout

**WPF:**
- Extract `Margin`, `Padding`, `Width`, `Height` values
- Look for spacing resources defined in XAML

**WinForms:**
- Extract control positioning and sizing from `.Designer.cs`
- Check `Margin`, `Padding` properties

**Electron:**
- Extract from CSS spacing utilities
- Parse flex/grid layout patterns

**Flutter:**
- Extract from `EdgeInsets` and `SizedBox` usages
- Look for spacing constants defined in `constants.dart` or `spacing.dart`
- Parse `ThemeData` spacing configurations
- Check `Padding`, `Margin`, and `Gap` widget patterns

**Flet:**
- Extract from `ft.padding`, `ft.margin` properties
- Look for spacing constants in Python files
- Parse `ft.Container` and `ft.Column`/`ft.Row` spacing configurations
- Check `ft.app()` theme spacing settings

**Key spacing tokens:**
- Base spacing unit
- Spacing scale (xs, sm, md, lg, xl, etc.)
- Container widths and gutters

#### Components

**WPF:**
- Extract styles from `Style` definitions
- Look for `ControlTemplate` definitions for custom controls

**WinForms:**
- Identify custom controls and their properties
- Extract common control patterns

**Electron:**
- Analyze React/Vue component styles
- Extract component variants

**Flutter:**
- Extract from `ThemeData` and custom widget themes
- Look for `ElevatedButtonTheme`, `InputDecorationTheme`, etc.
- Parse `MaterialApp` theme configurations
- Check custom widget classes extending Flutter widgets

**Flet:**
- Extract from `ft.ElevatedButton`, `ft.TextField`, `ft.Card` configurations
- Look for `ft.Theme` and component-specific theme settings
- Parse Python widget property patterns
- Check `ft.app()` theme component configurations

**Key components to document:**
- Window title bar
- Sidebar navigation
- Toolbars
- Status bar
- Buttons (primary, secondary, ghost)
- Inputs (text, checkbox, radio)
- Cards and panels
- Dialogs and modals
- Menus (main, context)
- Tab controls

#### Windows-Specific Elements

**Window Frame:**
- Title bar height and style
- Window border radius
- Minimize/Maximize/Close button styles
- Window shadow

**Menu System:**
- Main menu bar styles
- Context menu appearance
- Menu item hover states

**System Integration:**
- Taskbar icon styles
- System tray tooltip
- Dialog behavior

**Keyboard Shortcuts:**
- Common accelerator patterns

### Step 3: DESIGN.md Generation

Generate DESIGN.md following the standard format with desktop-specific extensions.

**Standard Sections:**
1. Frontmatter (version, name, description)
2. Colors (YAML token block)
3. Typography (YAML token block)
4. Rounded (YAML token block)
5. Spacing (YAML token block)
6. Components (YAML token block)
7. Overview (detailed description)
8. Colors (detailed breakdown)
9. Typography (detailed breakdown)
10. Layout (spacing, grid, container)
11. Elevation & Depth (shadows)
12. Shapes (border radius)
13. Components (detailed component specs)
14. Do's and Don'ts
15. Responsive Behavior

**Desktop-Specific Sections:**
16. Window System
17. Menu System
18. Keyboard Shortcuts
19. System Integration

## Design Token Extraction Scripts

### PowerShell Script for .NET Projects

```powershell
function Extract-WpfColors {
    param([string]$ProjectPath)
    
    $xamlFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.xaml"
    $colors = @{}
    
    foreach ($file in $xamlFiles) {
        $content = Get-Content $file.FullName -Raw
        $matches = [regex]::Matches($content, 'SolidColorBrush.*?Color="#([^"]+)"')
        
        foreach ($match in $matches) {
            $hex = "#" + $match.Groups[1].Value
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            $colors[$hex] += $file.Name
        }
    }
    
    return $colors
}

function Extract-WinFormsColors {
    param([string]$ProjectPath)
    
    $designerFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.Designer.cs"
    $colors = @{}
    
    foreach ($file in $designerFiles) {
        $content = Get-Content $file.FullName -Raw
        $matches = [regex]::Matches($content, 'Color\.FromArgb\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)')
        
        foreach ($match in $matches) {
            $hex = "#" + [string]::Format("{0:X2}{1:X2}{2:X2}", 
                [int]$match.Groups[2].Value,
                [int]$match.Groups[3].Value,
                [int]$match.Groups[4].Value)
            if (-not $colors.ContainsKey($hex)) {
                $colors[$hex] = @()
            }
            $colors[$hex] += $file.Name
        }
    }
    
    return $colors
}
```

### JavaScript Script for Electron Projects

```javascript
const fs = require('fs');
const path = require('path');

function extractColorsFromCSS(cssContent) {
    const colorVars = {};
    const varRegex = /--([a-z0-9-]+)\s*:\s*([^;]+)/gi;
    let match;

    while ((match = varRegex.exec(cssContent)) !== null) {
        colorVars[match[1]] = match[2].trim();
    }

    return colorVars;
}

function analyzeElectronProject(projectPath) {
    const stylesDir = path.join(projectPath, 'src', 'renderer', 'styles');
    const colors = {};

    if (fs.existsSync(stylesDir)) {
        const cssFiles = fs.readdirSync(stylesDir).filter(f => f.endsWith('.css') || f.endsWith('.scss'));

        cssFiles.forEach(file => {
            const content = fs.readFileSync(path.join(stylesDir, file), 'utf8');
            const fileColors = extractColorsFromCSS(content);
            Object.assign(colors, fileColors);
        });
    }

    return colors;
}
```

### Dart Script for Flutter Projects

```dart
import 'dart:io';

class FlutterDesignExtractor {
  Map<String, dynamic> colors = {};
  Map<String, dynamic> typography = {};
  Map<String, dynamic> spacing = {};

  void extractColorsFromDart(String content, String fileName) {
    // Extract Color(0xFF...) patterns
    final colorRegex = RegExp(r'Color\(0x([0-9A-Fa-f]{8})\)');
    final matches = colorRegex.allMatches(content);

    for (var match in matches) {
      final hex = match.group(1)!;
      final colorValue = '#${hex.substring(2)}'; // Remove alpha for now
      if (!colors.containsKey(colorValue)) {
        colors[colorValue] = [];
      }
      if (!colors[colorValue].contains(fileName)) {
        colors[colorValue].add(fileName);
      }
    }

    // Extract named color constants
    final namedColorRegex = RegExp(r'static\s+const\s+Color\s+(\w+)\s*=\s*Color\(0x([0-9A-Fa-f]{8})\)');
    final namedMatches = namedColorRegex.allMatches(content);

    for (var match in namedMatches) {
      final name = match.group(1)!;
      final hex = match.group(2)!;
      final colorValue = '#${hex.substring(2)}';
      colors['$name|$colorValue'] = [fileName];
    }
  }

  void extractTypographyFromDart(String content, String fileName) {
    // Extract TextStyle definitions
    final textStyleRegex = RegExp(r'TextStyle\([^)]*fontSize:\s*([\d.]+)[^)]*');
    final matches = textStyleRegex.allMatches(content);

    for (var match in matches) {
      final fontSize = match.group(1)!;
      if (!typography.containsKey('font-size')) {
        typography['font-size'] = [];
      }
      if (!typography['font-size'].contains(fontSize)) {
        typography['font-size'].add(fontSize);
      }
    }

    // Extract font families
    final fontFamilyRegex = RegExp(r'fontFamily:\s*[\'"]([^\'"]+)[\'"]');
    final fontMatches = fontFamilyRegex.allMatches(content);

    for (var match in fontMatches) {
      final fontFamily = match.group(1)!;
      if (!typography.containsKey('font-family')) {
        typography['font-family'] = [];
      }
      if (!typography['font-family'].contains(fontFamily)) {
        typography['font-family'].add(fontFamily);
      }
    }
  }

  void extractSpacingFromDart(String content, String fileName) {
    // Extract EdgeInsets patterns
    final edgeInsetsRegex = RegExp(r'EdgeInsets\.(all|symmetric|only)\(([^)]+)\)');
    final matches = edgeInsetsRegex.allMatches(content);

    for (var match in matches) {
      final spacing = match.group(2)!;
      if (!spacing.containsKey('padding')) {
        spacing['padding'] = [];
      }
      if (!spacing['padding'].contains(spacing)) {
        spacing['padding'].add(spacing);
      }
    }

    // Extract SizedBox patterns
    final sizedBoxRegex = RegExp(r'SizedBox\((?:width|height):\s*([\d.]+)');
    final sizedBoxMatches = sizedBoxRegex.allMatches(content);

    for (var match in sizedBoxMatches) {
      final size = match.group(1)!;
      if (!spacing.containsKey('spacing')) {
        spacing['spacing'] = [];
      }
      if (!spacing['spacing'].contains(size)) {
        spacing['spacing'].add(size);
      }
    }
  }

  void analyzeFlutterProject(String projectPath) {
    final libDir = Directory('$projectPath/lib');

    if (!libDir.existsSync()) {
      print('lib directory not found');
      return;
    }

    libDir.listSync(recursive: true).forEach((entity) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        final fileName = entity.path.split(Platform.pathSeparator).last;

        extractColorsFromDart(content, fileName);
        extractTypographyFromDart(content, fileName);
        extractSpacingFromDart(content, fileName);
      }
    });

    print('=== Extracted Flutter Colors ===');
    colors.forEach((key, value) {
      print('$key: $value');
    });

    print('\n=== Extracted Flutter Typography ===');
    typography.forEach((key, value) {
      print('$key: $value');
    });

    print('\n=== Extracted Flutter Spacing ===');
    spacing.forEach((key, value) {
      print('$key: $value');
    });
  }
}
```

### Python Script for Flet Projects

```python
import re
import os
from pathlib import Path

class FletDesignExtractor:
    def __init__(self):
        self.colors = {}
        self.typography = {}
        self.spacing = {}

    def extract_colors_from_python(self, content, file_name):
        # Extract ft.Color(0xFF...) patterns
        color_regex = r'ft\.Color\(0x([0-9A-Fa-f]{8})\)'
        matches = re.findall(color_regex, content)

        for match in matches:
            hex_value = f"#{match[2:]}"  # Remove alpha for now
            if hex_value not in self.colors:
                self.colors[hex_value] = []
            if file_name not in self.colors[hex_value]:
                self.colors[hex_value].append(file_name)

        # Extract ft.Colors constants
        colors_regex = r'ft\.Colors\.([A-Z_]+)'
        color_matches = re.findall(colors_regex, content)

        for match in color_matches:
            if match not in self.colors:
                self.colors[match] = []
            if file_name not in self.colors[match]:
                self.colors[match].append(file_name)

        # Extract custom color definitions
        custom_color_regex = r'(\w+)\s*=\s*ft\.Color\(0x([0-9A-Fa-f]{8})\)'
        custom_matches = re.findall(custom_color_regex, content)

        for name, hex_value in custom_matches:
            color_key = f"{name}|#{hex_value[2:]}"
            if color_key not in self.colors:
                self.colors[color_key] = []
            if file_name not in self.colors[color_key]:
                self.colors[color_key].append(file_name)

    def extract_typography_from_python(self, content, file_name):
        # Extract ft.TextStyle definitions
        text_style_regex = r'ft\.TextStyle\([^)]*size=(\d+)[^)]*\)'
        matches = re.findall(text_style_regex, content)

        for match in matches:
            if 'font-size' not in self.typography:
                self.typography['font-size'] = []
            if match not in self.typography['font-size']:
                self.typography['font-size'].append(match)

        # Extract font families
        font_family_regex = r'font_family=["\']([^"\']+)["\']'
        font_matches = re.findall(font_family_regex, content)

        for match in font_matches:
            if 'font-family' not in self.typography:
                self.typography['font-family'] = []
            if match not in self.typography['font-family']:
                self.typography['font-family'].append(match)

    def extract_spacing_from_python(self, content, file_name):
        # Extract ft.padding patterns
        padding_regex = r'ft\.padding=(\d+)'
        matches = re.findall(padding_regex, content)

        for match in matches:
            if 'padding' not in self.spacing:
                self.spacing['padding'] = []
            if match not in self.spacing['padding']:
                self.spacing['padding'].append(match)

        # Extract ft.margin patterns
        margin_regex = r'ft\.margin=(\d+)'
        margin_matches = re.findall(margin_regex, content)

        for match in margin_matches:
            if 'margin' not in self.spacing:
                self.spacing['margin'] = []
            if match not in self.spacing['margin']:
                self.spacing['margin'].append(match)

    def analyze_flet_project(self, project_path):
        project_dir = Path(project_path)

        if not project_dir.exists():
            print(f"Project path not found: {project_path}")
            return

        # Find all Python files
        python_files = list(project_dir.rglob("*.py"))

        for file_path in python_files:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    file_name = file_path.name

                    self.extract_colors_from_python(content, file_name)
                    self.extract_typography_from_python(content, file_name)
                    self.extract_spacing_from_python(content, file_name)
            except Exception as e:
                print(f"Error reading {file_path}: {e}")

        print("=== Extracted Flet Colors ===")
        for key, value in sorted(self.colors.items()):
            print(f"{key}: {value}")

        print("\n=== Extracted Flet Typography ===")
        for key, value in self.typography.items():
            print(f"{key}: {value}")

        print("\n=== Extracted Flet Spacing ===")
        for key, value in self.spacing.items():
            print(f"{key}: {value}")
```

## Example Output

### DESIGN.md Frontmatter

```markdown
---
version: alpha
name: MyApp-desktop-design
description: Windows desktop application with dark theme, modern flat design. Features include sidebar navigation, toolbar with icons, and status bar at bottom.
platform: windows
framework: wpf
---
```

### Desktop-Specific Components

```markdown
window:
  title-bar-height: 32px
  title-bar-background: "#2d2d2d"
  title-bar-text: "#ffffff"
  border-radius: 8px
  shadow: "rgba(0,0,0,0.3) 0px 10px 40px"

menus:
  main-menu:
    background: "#2d2d2d"
    text: "#ffffff"
    hover: "#3a3a3a"
    height: 28px
  context-menu:
    background: "#ffffff"
    text: "#1a1a1a"
    hover: "#f0f0f0"
    border: "1px solid #e5e5e5"
    rounded: 4px

shortcuts:
  new: "Ctrl+N"
  open: "Ctrl+O"
  save: "Ctrl+S"
  save-as: "Ctrl+Shift+S"
  exit: "Ctrl+Q"
```

## Validation Checklist

After generating DESIGN.md, verify:
- [ ] All color tokens have hex values
- [ ] Typography tokens include font family, size, weight, line height
- [ ] Spacing tokens follow a consistent scale
- [ ] Component definitions include all states (default, hover, pressed, disabled)
- [ ] Desktop-specific sections (window, menus, shortcuts) are present
- [ ] Markdown formatting is valid
- [ ] All tokens referenced in the text are defined in YAML blocks

## Usage Example

**User Request:**
"Generate a DESIGN.md for my WPF project at C:\Projects\MyApp"

**Skill Execution:**
1. Scan project structure and identify WPF framework
2. Extract colors from XAML ResourceDictionary files
3. Extract typography from Style definitions
4. Extract component styles from custom controls
5. Generate comprehensive DESIGN.md with desktop-specific sections
6. Provide validation summary

## Best Practices

1. **Be thorough:** Extract all visible design tokens, not just obvious ones
2. **Use semantic names:** Name tokens by their purpose (e.g., `surface-dark`, `text-primary`)
3. **Document states:** Include hover, pressed, focused, and disabled states for interactive components
4. **Follow conventions:** Use naming consistent with the Awesome DESIGN.md collection
5. **Validate:** Run `npx @google/design.md lint DESIGN.md` if available

## References

- [Google Stitch DESIGN.md Specification](https://stitch.withgoogle.com/docs/design-md/specification/)
- [Awesome DESIGN.md Collection](https://github.com/VoltAgent/awesome-design-md)
- [WPF ResourceDictionary Documentation](https://learn.microsoft.com/en-us/dotnet/desktop/wpf/fundamentals/resources-overview)
- [Electron Theme Guidelines](https://www.electronjs.org/docs/latest/tutorial/themes)