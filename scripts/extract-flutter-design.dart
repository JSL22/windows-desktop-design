import 'dart:io';
import 'dart:convert';

class FlutterDesignExtractor {
  Map<String, List<String>> colors = {};
  Map<String, List<String>> typography = {};
  Map<String, List<String>> spacing = {};
  Map<String, List<String>> components = {};

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
      if (!colors[colorValue]!.contains(fileName)) {
        colors[colorValue]!.add(fileName);
      }
    }

    // Extract named color constants
    final namedColorRegex = RegExp(r'static\s+const\s+Color\s+(\w+)\s*=\s*Color\(0x([0-9A-Fa-f]{8})\)');
    final namedMatches = namedColorRegex.allMatches(content);

    for (var match in namedMatches) {
      final name = match.group(1)!;
      final hex = match.group(2)!;
      final colorValue = '#${hex.substring(2)}';
      final key = '$name|$colorValue';
      if (!colors.containsKey(key)) {
        colors[key] = [];
      }
      if (!colors[key]!.contains(fileName)) {
        colors[key]!.add(fileName);
      }
    }

    // Extract Color.fromARGB patterns
    final argbRegex = RegExp(r'Color\.fromARGB\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)');
    final argbMatches = argbRegex.allMatches(content);

    for (var match in argbMatches) {
      final a = int.parse(match.group(1)!);
      final r = int.parse(match.group(2)!);
      final g = int.parse(match.group(3)!);
      final b = int.parse(match.group(4)!);
      final colorValue = '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
      if (!colors.containsKey(colorValue)) {
        colors[colorValue] = [];
      }
      if (!colors[colorValue]!.contains(fileName)) {
        colors[colorValue]!.add(fileName);
      }
    }

    // Extract Color.fromRGBO patterns
    final rgbaRegex = RegExp(r'Color\.fromRGBO\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)');
    final rgbaMatches = rgbaRegex.allMatches(content);

    for (var match in rgbaMatches) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      final colorValue = '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
      if (!colors.containsKey(colorValue)) {
        colors[colorValue] = [];
      }
      if (!colors[colorValue]!.contains(fileName)) {
        colors[colorValue]!.add(fileName);
      }
    }

    // Extract Colors constants
    final colorsRegex = RegExp(r'Colors\.([A-Z][a-zA-Z]+)');
    final colorsMatches = colorsRegex.allMatches(content);

    for (var match in colorsMatches) {
      final colorName = match.group(1)!;
      if (!colors.containsKey(colorName)) {
        colors[colorName] = [];
      }
      if (!colors[colorName]!.contains(fileName)) {
        colors[colorName]!.add(fileName);
      }
    }
  }

  void extractTypographyFromDart(String content, String fileName) {
    // Extract TextStyle definitions
    final textStyleRegex = RegExp(r'TextStyle\([^)]*fontSize:\s*([\d.]+)[^)]*\)');
    final matches = textStyleRegex.allMatches(content);

    for (var match in matches) {
      final fontSize = match.group(1)!;
      if (!typography.containsKey('font-size')) {
        typography['font-size'] = [];
      }
      if (!typography['font-size']!.contains(fontSize)) {
        typography['font-size']!.add(fontSize);
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
      if (!typography['font-family']!.contains(fontFamily)) {
        typography['font-family']!.add(fontFamily);
      }
    }

    // Extract font weights
    final fontWeightRegex = RegExp(r'fontWeight:\s*FontWeight\.([a-zA-Z]+)');
    final weightMatches = fontWeightRegex.allMatches(content);

    for (var match in weightMatches) {
      final fontWeight = match.group(1)!;
      if (!typography.containsKey('font-weight')) {
        typography['font-weight'] = [];
      }
      if (!typography['font-weight']!.contains(fontWeight)) {
        typography['font-weight']!.add(fontWeight);
      }
    }

    // Extract letter spacing
    final letterSpacingRegex = RegExp(r'letterSpacing:\s*([\d.]+)');
    final spacingMatches = letterSpacingRegex.allMatches(content);

    for (var match in spacingMatches) {
      final letterSpacing = match.group(1)!;
      if (!typography.containsKey('letter-spacing')) {
        typography['letter-spacing'] = [];
      }
      if (!typography['letter-spacing']!.contains(letterSpacing)) {
        typography['letter-spacing']!.add(letterSpacing);
      }
    }

    // Extract line height
    final lineHeightRegex = RegExp(r'height:\s*([\d.]+)');
    final heightMatches = lineHeightRegex.allMatches(content);

    for (var match in heightMatches) {
      final lineHeight = match.group(1)!;
      if (!typography.containsKey('line-height')) {
        typography['line-height'] = [];
      }
      if (!typography['line-height']!.contains(lineHeight)) {
        typography['line-height']!.add(lineHeight);
      }
    }

    // Extract TextTheme patterns
    final textThemeRegex = RegExp(r'TextTheme\([^)]*\)');
    final textThemeMatches = textThemeRegex.allMatches(content);

    for (var match in textThemeMatches) {
      final textThemeContent = match.group(0)!;
      // Extract theme properties
      final themeProps = textThemeContent.split(',');
      for (var prop in themeProps) {
        if (prop.contains('displayLarge:') || prop.contains('headline1:')) {
          if (!typography.containsKey('display-large')) {
            typography['display-large'] = [];
          }
          typography['display-large']!.add(fileName);
        }
        if (prop.contains('displayMedium:') || prop.contains('headline2:')) {
          if (!typography.containsKey('display-medium')) {
            typography['display-medium'] = [];
          }
          typography['display-medium']!.add(fileName);
        }
        if (prop.contains('displaySmall:') || prop.contains('headline3:')) {
          if (!typography.containsKey('display-small')) {
            typography['display-small'] = [];
          }
          typography['display-small']!.add(fileName);
        }
        if (prop.contains('headlineMedium:') || prop.contains('headline4:')) {
          if (!typography.containsKey('headline-medium')) {
            typography['headline-medium'] = [];
          }
          typography['headline-medium']!.add(fileName);
        }
        if (prop.contains('headlineSmall:') || prop.contains('headline5:')) {
          if (!typography.containsKey('headline-small')) {
            typography['headline-small'] = [];
          }
          typography['headline-small']!.add(fileName);
        }
        if (prop.contains('titleLarge:') || prop.contains('headline6:')) {
          if (!typography.containsKey('title-large')) {
            typography['title-large'] = [];
          }
          typography['title-large']!.add(fileName);
        }
        if (prop.contains('titleMedium:')) {
          if (!typography.containsKey('title-medium')) {
            typography['title-medium'] = [];
          }
          typography['title-medium']!.add(fileName);
        }
        if (prop.contains('titleSmall:')) {
          if (!typography.containsKey('title-small')) {
            typography['title-small'] = [];
          }
          typography['title-small']!.add(fileName);
        }
        if (prop.contains('bodyLarge:')) {
          if (!typography.containsKey('body-large')) {
            typography['body-large'] = [];
          }
          typography['body-large']!.add(fileName);
        }
        if (prop.contains('bodyMedium:')) {
          if (!typography.containsKey('body-medium')) {
            typography['body-medium'] = [];
          }
          typography['body-medium']!.add(fileName);
        }
        if (prop.contains('bodySmall:')) {
          if (!typography.containsKey('body-small')) {
            typography['body-small'] = [];
          }
          typography['body-small']!.add(fileName);
        }
        if (prop.contains('labelLarge:')) {
          if (!typography.containsKey('label-large')) {
            typography['label-large'] = [];
          }
          typography['label-large']!.add(fileName);
        }
        if (prop.contains('labelMedium:')) {
          if (!typography.containsKey('label-medium')) {
            typography['label-medium'] = [];
          }
          typography['label-medium']!.add(fileName);
        }
        if (prop.contains('labelSmall:')) {
          if (!typography.containsKey('label-small')) {
            typography['label-small'] = [];
          }
          typography['label-small']!.add(fileName);
        }
      }
    }
  }

  void extractSpacingFromDart(String content, String fileName) {
    // Extract EdgeInsets patterns
    final edgeInsetsRegex = RegExp(r'EdgeInsets\.(all|symmetric|only|fromLTRB)\(([^)]+)\)');
    final matches = edgeInsetsRegex.allMatches(content);

    for (var match in matches) {
      final spacingValue = match.group(2)!;
      if (!spacing.containsKey('padding')) {
        spacing['padding'] = [];
      }
      if (!spacing['padding']!.contains(spacingValue)) {
        spacing['padding']!.add(spacingValue);
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
      if (!spacing['spacing']!.contains(size)) {
        spacing['spacing']!.add(size);
      }
    }

    // Extract Gap patterns
    final gapRegex = RegExp(r'Gap\s*\(\s*([\d.]+)\s*\)');
    final gapMatches = gapRegex.allMatches(content);

    for (var match in gapMatches) {
      final gap = match.group(1)!;
      if (!spacing.containsKey('gap')) {
        spacing['gap'] = [];
      }
      if (!spacing['gap']!.contains(gap)) {
        spacing['gap']!.add(gap);
      }
    }

    // Extract margin patterns
    final marginRegex = RegExp(r'margin:\s*EdgeInsets\(([^)]+)\)');
    final marginMatches = marginRegex.allMatches(content);

    for (var match in marginMatches) {
      final marginValue = match.group(1)!;
      if (!spacing.containsKey('margin')) {
        spacing['margin'] = [];
      }
      if (!spacing['margin']!.contains(marginValue)) {
        spacing['margin']!.add(marginValue);
      }
    }

    // Extract spacing constants
    final spacingConstantRegex = RegExp(r'static\s+const\s+double\s+(\w+)\s*=\s*([\d.]+)');
    final spacingConstantMatches = spacingConstantRegex.allMatches(content);

    for (var match in spacingConstantMatches) {
      final name = match.group(1)!;
      final value = match.group(2)!;
      final key = '$name|$value';
      if (!spacing.containsKey(key)) {
        spacing[key] = [];
      }
      if (!spacing[key]!.contains(fileName)) {
        spacing[key]!.add(fileName);
      }
    }
  }

  void extractComponentsFromDart(String content, String fileName) {
    // Extract custom widget classes
    final widgetClassRegex = RegExp(r'class\s+(\w+)\s+extends\s+(?:StatelessWidget|StatefulWidget)');
    final widgetMatches = widgetClassRegex.allMatches(content);

    for (var match in widgetMatches) {
      final widgetName = match.group(1)!;
      if (!components.containsKey(widgetName)) {
        components[widgetName] = [];
      }
      if (!components[widgetName]!.contains(fileName)) {
        components[widgetName]!.add(fileName);
      }
    }

    // Extract ElevatedButton patterns
    final elevatedButtonRegex = RegExp(r'ElevatedButton\([^)]*\)');
    final elevatedButtonMatches = elevatedButtonRegex.allMatches(content);

    for (var match in elevatedButtonMatches) {
      if (!components.containsKey('ElevatedButton')) {
        components['ElevatedButton'] = [];
      }
      if (!components['ElevatedButton']!.contains(fileName)) {
        components['ElevatedButton']!.add(fileName);
      }
    }

    // Extract TextField patterns
    final textFieldRegex = RegExp(r'TextField\([^)]*\)');
    final textFieldMatches = textFieldRegex.allMatches(content);

    for (var match in textFieldMatches) {
      if (!components.containsKey('TextField')) {
        components['TextField'] = [];
      }
      if (!components['TextField']!.contains(fileName)) {
        components['TextField']!.add(fileName);
      }
    }

    // Extract Card patterns
    final cardRegex = RegExp(r'Card\([^)]*\)');
    final cardMatches = cardRegex.allMatches(content);

    for (var match in cardMatches) {
      if (!components.containsKey('Card')) {
        components['Card'] = [];
      }
      if (!components['Card']!.contains(fileName)) {
        components['Card']!.add(fileName);
      }
    }

    // Extract Container patterns
    final containerRegex = RegExp(r'Container\([^)]*\)');
    final containerMatches = containerRegex.allMatches(content);

    for (var match in containerMatches) {
      if (!components.containsKey('Container')) {
        components['Container'] = [];
      }
      if (!components['Container']!.contains(fileName)) {
        components['Container']!.add(fileName);
      }
    }

    // Extract AppBar patterns
    final appBarRegex = RegExp(r'AppBar\([^)]*\)');
    final appBarMatches = appBarRegex.allMatches(content);

    for (var match in appBarMatches) {
      if (!components.containsKey('AppBar')) {
        components['AppBar'] = [];
      }
      if (!components['AppBar']!.contains(fileName)) {
        components['AppBar']!.add(fileName);
      }
    }

    // Extract Drawer patterns
    final drawerRegex = RegExp(r'Drawer\([^)]*\)');
    final drawerMatches = drawerRegex.allMatches(content);

    for (var match in drawerMatches) {
      if (!components.containsKey('Drawer')) {
        components['Drawer'] = [];
      }
      if (!components['Drawer']!.contains(fileName)) {
        components['Drawer']!.add(fileName);
      }
    }

    // Extract BottomNavigationBar patterns
    final bottomNavRegex = RegExp(r'BottomNavigationBar\([^)]*\)');
    final bottomNavMatches = bottomNavRegex.allMatches(content);

    for (var match in bottomNavMatches) {
      if (!components.containsKey('BottomNavigationBar')) {
        components['BottomNavigationBar'] = [];
      }
      if (!components['BottomNavigationBar']!.contains(fileName)) {
        components['BottomNavigationBar']!.add(fileName);
      }
    }

    // Extract TabBar patterns
    final tabBarRegex = RegExp(r'TabBar\([^)]*\)');
    final tabBarMatches = tabBarRegex.allMatches(content);

    for (var match in tabBarMatches) {
      if (!components.containsKey('TabBar')) {
        components['TabBar'] = [];
      }
      if (!components['TabBar']!.contains(fileName)) {
        components['TabBar']!.add(fileName);
      }
    }

    // Extract Dialog patterns
    final dialogRegex = RegExp(r'ShowDialog|AlertDialog\([^)]*\)');
    final dialogMatches = dialogRegex.allMatches(content);

    for (var match in dialogMatches) {
      if (!components.containsKey('Dialog')) {
        components['Dialog'] = [];
      }
      if (!components['Dialog']!.contains(fileName)) {
        components['Dialog']!.add(fileName);
      }
    }

    // Extract ListTile patterns
    final listTileRegex = RegExp(r'ListTile\([^)]*\)');
    final listTileMatches = listTileRegex.allMatches(content);

    for (var match in listTileMatches) {
      if (!components.containsKey('ListTile')) {
        components['ListTile'] = [];
      }
      if (!components['ListTile']!.contains(fileName)) {
        components['ListTile']!.add(fileName);
      }
    }
  }

  void analyzeFlutterProject(String projectPath) {
    print('\n======================================');
    print('Analyzing Flutter Project: $projectPath');
    print('======================================\n');

    final libDir = Directory('$projectPath/lib');

    if (!libDir.existsSync()) {
      print('Error: lib directory not found at $projectPath/lib');
      return;
    }

    try {
      libDir.listSync(recursive: true).forEach((entity) {
        if (entity is File && entity.path.endsWith('.dart')) {
          try {
            final content = entity.readAsStringSync();
            final fileName = entity.path.split(Platform.pathSeparator).last;

            extractColorsFromDart(content, fileName);
            extractTypographyFromDart(content, fileName);
            extractSpacingFromDart(content, fileName);
            extractComponentsFromDart(content, fileName);
          } catch (e) {
            print('Warning: Could not read ${entity.path}: $e');
          }
        }
      });
    } catch (e) {
      print('Error scanning lib directory: $e');
      return;
    }

    print('=== Extracted Flutter Colors ===');
    final sortedColors = colors.keys.toList()..sort();
    for (var key in sortedColors) {
      print('  $key: ${colors[key]}');
    }
    print('\nTotal colors: ${colors.length}');

    print('\n=== Extracted Flutter Typography ===');
    typography.forEach((key, value) {
      print('  $key: ${value.join(", ")}');
    });

    print('\n=== Extracted Flutter Spacing ===');
    spacing.forEach((key, value) {
      if (value.length > 5) {
        print('  $key: ${value.take(5).join(", ")} ... (${value.length} total)');
      } else {
        print('  $key: ${value.join(", ")}');
      }
    });

    print('\n=== Identified Flutter Components ===');
    final sortedComponents = components.keys.toList()..sort();
    for (var key in sortedComponents) {
      print('  $key: ${components[key]}');
    }
    print('\nTotal components: ${components.length}');

    // Generate JSON output
    final result = {
      'colors': colors,
      'typography': typography,
      'spacing': spacing,
      'components': components
    };

    final jsonEncoder = JsonEncoder.withIndent('  ');
    final jsonString = jsonEncoder.convert(result);

    final outputFile = File('$projectPath/design_tokens.json');
    try {
      outputFile.writeAsStringSync(jsonString);
      print('\n✓ Design tokens exported to: ${outputFile.path}');
    } catch (e) {
      print('\n✗ Error writing design tokens file: $e');
    }
  }
}

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart extract-flutter-design.dart <flutter-project-path>');
    print('Example: dart extract-flutter-design.dart C:\\Projects\\MyFlutterApp');
    exit(1);
  }

  final projectPath = args[0];
  final extractor = FlutterDesignExtractor();
  extractor.analyzeFlutterProject(projectPath);
}