import re
import os
import json
from pathlib import Path
from typing import Dict, List, Any


class FletDesignExtractor:
    def __init__(self):
        self.colors: Dict[str, List[str]] = {}
        self.typography: Dict[str, List[str]] = {}
        self.spacing: Dict[str, List[str]] = {}
        self.components: Dict[str, List[str]] = {}

    def extract_colors_from_python(self, content: str, file_name: str) -> None:
        """Extract color definitions from Flet Python code."""
        
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

        # Extract ft.Color.from_rgb patterns
        rgb_regex = r'ft\.Color\.from_rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)'
        rgb_matches = re.findall(rgb_regex, content)

        for r, g, b in rgb_matches:
            hex_value = f"#{int(r):02x}{int(g):02x}{int(b):02x}"
            if hex_value not in self.colors:
                self.colors[hex_value] = []
            if file_name not in self.colors[hex_value]:
                self.colors[hex_value].append(file_name)

        # Extract ft.Color.from_rgba patterns
        rgba_regex = r'ft\.Color\.from_rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)'
        rgba_matches = re.findall(rgba_regex, content)

        for r, g, b, a in rgba_matches:
            hex_value = f"#{int(r):02x}{int(g):02x}{int(b):02x}"
            if hex_value not in self.colors:
                self.colors[hex_value] = []
            if file_name not in self.colors[hex_value]:
                self.colors[hex_value].append(file_name)

        # Extract color property assignments
        color_property_regex = r'bgcolor\s*=\s*ft\.Color\(0x([0-9A-Fa-f]{8})\)'
        color_property_matches = re.findall(color_property_regex, content)

        for match in color_property_matches:
            hex_value = f"#{match[2:]}"
            if hex_value not in self.colors:
                self.colors[hex_value] = []
            if file_name not in self.colors[hex_value]:
                self.colors[hex_value].append(file_name)

        # Extract text color property
        text_color_regex = r'color\s*=\s*ft\.Color\(0x([0-9A-Fa-f]{8})\)'
        text_color_matches = re.findall(text_color_regex, content)

        for match in text_color_matches:
            hex_value = f"#{match[2:]}"
            if hex_value not in self.colors:
                self.colors[hex_value] = []
            if file_name not in self.colors[hex_value]:
                self.colors[hex_value].append(file_name)

    def extract_typography_from_python(self, content: str, file_name: str) -> None:
        """Extract typography definitions from Flet Python code."""
        
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

        # Extract font weights
        font_weight_regex = r'weight\s*=\s*ft\.FontWeight\.([A-Z_]+)'
        weight_matches = re.findall(font_weight_regex, content)

        for match in weight_matches:
            if 'font-weight' not in self.typography:
                self.typography['font-weight'] = []
            if match not in self.typography['font-weight']:
                self.typography['font-weight'].append(match)

        # Extract letter spacing
        letter_spacing_regex = r'letter_spacing\s*=\s*([\d.]+)'
        spacing_matches = re.findall(letter_spacing_regex, content)

        for match in spacing_matches:
            if 'letter-spacing' not in self.typography:
                self.typography['letter-spacing'] = []
            if match not in self.typography['letter-spacing']:
                self.typography['letter-spacing'].append(match)

        # Extract text height
        height_regex = r'height\s*=\s*([\d.]+)'
        height_matches = re.findall(height_regex, content)

        for match in height_matches:
            if 'line-height' not in self.typography:
                self.typography['line-height'] = []
            if match not in self.typography['line-height']:
                self.typography['line-height'].append(match)

        # Extract italic style
        italic_regex = r'italic\s*=\s*(True|False)'
        italic_matches = re.findall(italic_regex, content)

        for match in italic_matches:
            if match == 'True':
                if 'font-style' not in self.typography:
                    self.typography['font-style'] = []
                if 'italic' not in self.typography['font-style']:
                    self.typography['font-style'].append('italic')

        # Extract TextTheme patterns
        text_theme_regex = r'ft\.TextTheme\([^)]*\)'
        text_theme_matches = re.findall(text_theme_regex, content)

        for match in text_theme_matches:
            theme_content = match
            # Extract theme properties
            if 'display_large' in theme_content:
                if 'display-large' not in self.typography:
                    self.typography['display-large'] = []
                if file_name not in self.typography['display-large']:
                    self.typography['display-large'].append(file_name)
            if 'display_medium' in theme_content:
                if 'display-medium' not in self.typography:
                    self.typography['display-medium'] = []
                if file_name not in self.typography['display-medium']:
                    self.typography['display-medium'].append(file_name)
            if 'display_small' in theme_content:
                if 'display-small' not in self.typography:
                    self.typography['display-small'] = []
                if file_name not in self.typography['display-small']:
                    self.typography['display-small'].append(file_name)
            if 'headline_medium' in theme_content:
                if 'headline-medium' not in self.typography:
                    self.typography['headline-medium'] = []
                if file_name not in self.typography['headline-medium']:
                    self.typography['headline-medium'].append(file_name)
            if 'headline_small' in theme_content:
                if 'headline-small' not in self.typography:
                    self.typography['headline-small'] = []
                if file_name not in self.typography['headline-small']:
                    self.typography['headline-small'].append(file_name)
            if 'title_large' in theme_content:
                if 'title-large' not in self.typography:
                    self.typography['title-large'] = []
                if file_name not in self.typography['title-large']:
                    self.typography['title-large'].append(file_name)
            if 'title_medium' in theme_content:
                if 'title-medium' not in self.typography:
                    self.typography['title-medium'] = []
                if file_name not in self.typography['title-medium']:
                    self.typography['title-medium'].append(file_name)
            if 'title_small' in theme_content:
                if 'title-small' not in self.typography:
                    self.typography['title-small'] = []
                if file_name not in self.typography['title-small']:
                    self.typography['title-small'].append(file_name)
            if 'body_large' in theme_content:
                if 'body-large' not in self.typography:
                    self.typography['body-large'] = []
                if file_name not in self.typography['body-large']:
                    self.typography['body-large'].append(file_name)
            if 'body_medium' in theme_content:
                if 'body-medium' not in self.typography:
                    self.typography['body-medium'] = []
                if file_name not in self.typography['body-medium']:
                    self.typography['body-medium'].append(file_name)
            if 'body_small' in theme_content:
                if 'body-small' not in self.typography:
                    self.typography['body-small'] = []
                if file_name not in self.typography['body-small']:
                    self.typography['body-small'].append(file_name)
            if 'label_large' in theme_content:
                if 'label-large' not in self.typography:
                    self.typography['label-large'] = []
                if file_name not in self.typography['label-large']:
                    self.typography['label-large'].append(file_name)
            if 'label_medium' in theme_content:
                if 'label-medium' not in self.typography:
                    self.typography['label-medium'] = []
                if file_name not in self.typography['label-medium']:
                    self.typography['label-medium'].append(file_name)
            if 'label_small' in theme_content:
                if 'label-small' not in self.typography:
                    self.typography['label-small'] = []
                if file_name not in self.typography['label-small']:
                    self.typography['label-small'].append(file_name)

    def extract_spacing_from_python(self, content: str, file_name: str) -> None:
        """Extract spacing definitions from Flet Python code."""
        
        # Extract ft.padding patterns
        padding_regex = r'padding\s*=\s*(\d+)'
        matches = re.findall(padding_regex, content)

        for match in matches:
            if 'padding' not in self.spacing:
                self.spacing['padding'] = []
            if match not in self.spacing['padding']:
                self.spacing['padding'].append(match)

        # Extract ft.margin patterns
        margin_regex = r'margin\s*=\s*(\d+)'
        margin_matches = re.findall(margin_regex, content)

        for match in margin_matches:
            if 'margin' not in self.spacing:
                self.spacing['margin'] = []
            if match not in self.spacing['margin']:
                self.spacing['margin'].append(match)

        # Extract ft.padding with ft.padding.all
        padding_all_regex = r'ft\.padding\.all\((\d+)\)'
        padding_all_matches = re.findall(padding_all_regex, content)

        for match in padding_all_matches:
            if 'padding-all' not in self.spacing:
                self.spacing['padding-all'] = []
            if match not in self.spacing['padding-all']:
                self.spacing['padding-all'].append(match)

        # Extract ft.padding with ft.padding.symmetric
        padding_symmetric_regex = r'ft\.padding\.symmetric\(([^)]+)\)'
        padding_symmetric_matches = re.findall(padding_symmetric_regex, content)

        for match in padding_symmetric_matches:
            if 'padding-symmetric' not in self.spacing:
                self.spacing['padding-symmetric'] = []
            if match not in self.spacing['padding-symmetric']:
                self.spacing['padding-symmetric'].append(match)

        # Extract ft.padding with ft.padding.only
        padding_only_regex = r'ft\.padding\.only\(([^)]+)\)'
        padding_only_matches = re.findall(padding_only_regex, content)

        for match in padding_only_matches:
            if 'padding-only' not in self.spacing:
                self.spacing['padding-only'] = []
            if match not in self.spacing['padding-only']:
                self.spacing['padding-only'].append(match)

        # Extract width and height patterns
        width_regex = r'width\s*=\s*(\d+)'
        width_matches = re.findall(width_regex, content)

        for match in width_matches:
            if 'width' not in self.spacing:
                self.spacing['width'] = []
            if match not in self.spacing['width']:
                self.spacing['width'].append(match)

        height_regex = r'height\s*=\s*(\d+)'
        height_matches = re.findall(height_regex, content)

        for match in height_matches:
            if 'height' not in self.spacing:
                self.spacing['height'] = []
            if match not in self.spacing['height']:
                self.spacing['height'].append(match)

        # Extract spacing constants
        spacing_constant_regex = r'(\w+)\s*=\s*(\d+)\s*#.*spacing'
        spacing_constant_matches = re.findall(spacing_constant_regex, content)

        for name, value in spacing_constant_matches:
            key = f'{name}|{value}'
            if key not in self.spacing:
                self.spacing[key] = []
            if file_name not in self.spacing[key]:
                self.spacing[key].append(file_name)

        # Extract gap patterns (for Column and Row)
        gap_regex = r'gap\s*=\s*(\d+)'
        gap_matches = re.findall(gap_regex, content)

        for match in gap_matches:
            if 'gap' not in self.spacing:
                self.spacing['gap'] = []
            if match not in self.spacing['gap']:
                self.spacing['gap'].append(match)

    def extract_components_from_python(self, content: str, file_name: str) -> None:
        """Extract component usage from Flet Python code."""
        
        # Extract common Flet widgets
        widget_patterns = [
            r'ft\.ElevatedButton',
            r'ft\.TextButton',
            r'ft\.OutlinedButton',
            r'ft\.IconButton',
            r'ft\.FloatingActionButton',
            r'ft\.TextField',
            r'ft\.TextFormField',
            r'ft\.Card',
            r'ft\.Container',
            r'ft\.Column',
            r'ft\.Row',
            r'ft\.Stack',
            r'ft\.AppBar',
            r'ft\.Drawer',
            r'ft\.BottomAppBar',
            r'ft\.NavigationRail',
            r'ft\.Tab',
            r'ft\.Tabs',
            r'ft\.DataTable',
            r'ft\.ListView',
            r'ft\.GridView',
            r'ft\.AlertDialog',
            r'ft\.Banner',
            r'ft\.BottomSheet',
            r'ft\.Chip',
            r'ft\.Checkbox',
            r'ft\.Radio',
            r'ft\.Switch',
            r'ft\.Slider',
            r'ft\.ProgressRing',
            r'ft\.ProgressBar',
            r'ft\.Divider',
            r'ft\.VerticalDivider',
            r'ft\.Image',
            r'ft\.Icon',
            r'ft\.Tooltip',
            r'ft\.PopupMenuButton',
            r'ft\.Dropdown',
            r'ft\.DatePicker',
            r'ft\.TimePicker',
            r'ft\.ColorPicker',
            r'ft\.FilePicker',
            r'ft\.SnackBar',
            r'ft\.Dialog',
        ]

        for pattern in widget_patterns:
            widget_name = pattern.replace(r'ft\.', '')
            matches = re.findall(pattern, content)
            if matches:
                if widget_name not in self.components:
                    self.components[widget_name] = []
                if file_name not in self.components[widget_name]:
                    self.components[widget_name].append(file_name)

        # Extract custom component classes
        custom_class_regex = r'class\s+(\w+)\s*\([^)]*\):'
        custom_matches = re.findall(custom_class_regex, content)

        for match in custom_matches:
            # Check if it's a custom component (usually inherits from ft.UserControl or similar)
            if 'UserControl' in content or 'StatefulWidget' in content or 'StatelessWidget' in content:
                if match not in self.components:
                    self.components[match] = []
                if file_name not in self.components[match]:
                    self.components[match].append(file_name)

    def analyze_flet_project(self, project_path: str) -> Dict[str, Any]:
        """Analyze a Flet project and extract design tokens."""
        
        print(f"\n{'='*40}")
        print(f"Analyzing Flet Project: {project_path}")
        print(f"{'='*40}\n")

        project_dir = Path(project_path)

        if not project_dir.exists():
            print(f"Error: Project path not found: {project_path}")
            return {}

        # Find all Python files
        python_files = list(project_dir.rglob("*.py"))

        if not python_files:
            print("Error: No Python files found in the project")
            return {}

        print(f"Found {len(python_files)} Python files to analyze\n")

        for file_path in python_files:
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    file_name = file_path.name

                    self.extract_colors_from_python(content, file_name)
                    self.extract_typography_from_python(content, file_name)
                    self.extract_spacing_from_python(content, file_name)
                    self.extract_components_from_python(content, file_name)
            except Exception as e:
                print(f"Warning: Could not read {file_path}: {e}")

        # Print results
        print("=== Extracted Flet Colors ===")
        sorted_colors = sorted(self.colors.keys())
        for key in sorted_colors:
            print(f"  {key}: {self.colors[key]}")
        print(f"\nTotal colors: {len(self.colors)}")

        print("\n=== Extracted Flet Typography ===")
        for key, value in self.typography.items():
            print(f"  {key}: {value}")

        print("\n=== Extracted Flet Spacing ===")
        for key, value in self.spacing.items():
            if len(value) > 5:
                print(f"  {key}: {value[:5]} ... ({len(value)} total)")
            else:
                print(f"  {key}: {value}")

        print("\n=== Identified Flet Components ===")
        sorted_components = sorted(self.components.keys())
        for key in sorted_components:
            print(f"  {key}: {self.components[key]}")
        print(f"\nTotal components: {len(self.components)}")

        # Generate JSON output
        result = {
            'colors': self.colors,
            'typography': self.typography,
            'spacing': self.spacing,
            'components': self.components
        }

        output_file = project_dir / 'design_tokens.json'
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f"\n✓ Design tokens exported to: {output_file}")
        except Exception as e:
            print(f"\n✗ Error writing design tokens file: {e}")

        return result


def main():
    import sys

    if len(sys.argv) < 2:
        print("Usage: python extract-flet-design.py <flet-project-path>")
        print("Example: python extract-flet-design.py C:\\Projects\\MyFletApp")
        sys.exit(1)

    project_path = sys.argv[1]
    extractor = FletDesignExtractor()
    extractor.analyze_flet_project(project_path)


if __name__ == "__main__":
    main()