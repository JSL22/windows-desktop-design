---
version: alpha
name: {{APP_NAME}}-desktop-design
description: {{APP_DESCRIPTION}}
platform: windows
framework: {{FRAMEWORK}}
---

## Overview

{{APP_NAME}} is a Windows desktop application with {{VISUAL_DESCRIPTION}}. Key visual characteristics include:

- {{KEY_CHARACTERISTIC_1}}
- {{KEY_CHARACTERISTIC_2}}
- {{KEY_CHARACTERISTIC_3}}

## Colors

### Brand & Primary
- **Primary** ({colors.primary}): Main brand color, used for primary CTAs and accents
- **Primary Pressed** ({colors.primary-pressed}): Pressed state
- **Primary Hover** ({colors.primary-hover}): Hover state

### Surface
- **Window Background** ({colors.window-bg}): Main window background
- **Surface** ({colors.surface}): Panel and card backgrounds
- **Surface Dark** ({colors.surface-dark}): Darker surfaces for contrast
- **Surface Elevated** ({colors.surface-elevated}): Raised surfaces
- **Border** ({colors.border}): Divider lines
- **Border Light** ({colors.border-light}): Subtle dividers

### Text
- **Text Primary** ({colors.text-primary}): Main content text
- **Text Secondary** ({colors.text-secondary}): Secondary text
- **Text Tertiary** ({colors.text-tertiary}): Disabled or muted text
- **Text On Dark** ({colors.text-on-dark}): Text on dark backgrounds

### Semantic
- **Success** ({colors.semantic-success}): Success indicators
- **Warning** ({colors.semantic-warning}): Warning indicators
- **Error** ({colors.semantic-error}): Error indicators
- **Info** ({colors.semantic-info}): Information indicators

## Typography

### Font Family
**Primary**: {{FONT_FAMILY}}. Fallbacks: {{FONT_FALLBACKS}}.

### Hierarchy

| Token | Size | Weight | Line Height | Use |
|---|---|---|---|---|
| `{typography.hero}` | 32px | 700 | 1.10 | Hero text |
| `{typography.heading-1}` | 24px | 600 | 1.15 | Section titles |
| `{typography.heading-2}` | 20px | 600 | 1.20 | Sub-section titles |
| `{typography.heading-3}` | 16px | 600 | 1.25 | Card titles |
| `{typography.body}` | 14px | 400 | 1.40 | Primary body text |
| `{typography.body-medium}` | 14px | 500 | 1.40 | Body emphasis |
| `{typography.caption}` | 12px | 400 | 1.30 | Captions and labels |
| `{typography.caption-bold}` | 12px | 600 | 1.30 | Bold captions |
| `{typography.micro}` | 11px | 400 | 1.25 | Micro text |

## Layout

### Spacing System
- **Base unit**: {{BASE_UNIT}}px
- **Tokens**: `{spacing.xs}` through `{spacing.xxl}`

### Container & Grid
- **Window content padding**: {{WINDOW_PADDING}}
- **Panel spacing**: {{PANEL_SPACING}}

## Elevation & Depth

| Level | Treatment | Use |
|---|---|---|
| 0 | No shadow, border only | Flat panels |
| 1 | Subtle shadow | Hover states |
| 2 | Card shadow | Cards, dialogs |
| 3 | Elevated shadow | Modals, popups |
| 4 | Heavy shadow | Tooltips |

## Shapes

### Border Radius

| Token | Value | Use |
|---|---|---|
| `{rounded.sm}` | 4px | Small elements |
| `{rounded.md}` | 6px | Buttons, inputs |
| `{rounded.lg}` | 8px | Cards, panels |
| `{rounded.xl}` | 12px | Dialogs, windows |

## Components

### Window Frame

**Title Bar**
- Height: `{window.title-bar-height}`
- Background: `{colors.surface-dark}`
- Text: `{colors.text-primary}`

### Sidebar

**Sidebar Container**
- Width: {{SIDEBAR_WIDTH}}
- Background: `{colors.surface-dark}`
- Border right: `1px solid {colors.border}`

**Sidebar Item**
- Height: {{SIDEBAR_ITEM_HEIGHT}}
- Hover background: `{colors.surface}`
- Active background: `{colors.primary}`

### Toolbar

**Toolbar Container**
- Height: {{TOOLBAR_HEIGHT}}
- Background: `{colors.surface}`
- Border bottom: `1px solid {colors.border}`

**Toolbar Button**
- Size: {{TOOLBAR_BUTTON_SIZE}}
- Hover background: `{colors.surface-dark}`
- Icon color: `{colors.text-secondary}`

### Status Bar

**Status Bar Container**
- Height: {{STATUS_BAR_HEIGHT}}
- Background: `{colors.surface}`
- Border top: `1px solid {colors.border}`
- Typography: `{typography.caption}`

### Buttons

**Button Primary**
- Background: `{colors.primary}`
- Text: `{colors.text-on-dark}`
- Padding: `{spacing.sm} {spacing.md}`
- Rounded: `{rounded.md}`

**Button Secondary**
- Background: `{colors.surface}`
- Text: `{colors.text-primary}`
- Border: `1px solid {colors.border}`
- Padding: `{spacing.sm} {spacing.md}`
- Rounded: `{rounded.md}`

**Button Ghost**
- Background: transparent
- Text: `{colors.text-secondary}`
- Padding: `{spacing.xs} {spacing.sm}`

### Inputs

**Text Input**
- Background: `{colors.window-bg}`
- Border: `1px solid {colors.border}`
- Focus border: `1px solid {colors.primary}`
- Padding: `{spacing.sm}`
- Rounded: `{rounded.sm}`

### Cards

**Card Base**
- Background: `{colors.surface}`
- Border: `1px solid {colors.border}`
- Padding: `{spacing.md}`
- Rounded: `{rounded.lg}`

### Dialogs

**Dialog Container**
- Background: `{colors.surface}`
- Border: `1px solid {colors.border}`
- Rounded: `{rounded.xl}`
- Shadow: Level 3

## Window System

### Window Frame
- **Title bar height**: {window.title-bar-height}
- **Title bar background**: {colors.surface-dark}
- **Title bar text**: {colors.text-primary}
- **Window border**: 1px solid {colors.border}
- **Window radius**: {rounded.xl}
- **Window shadow**: {elevation.window}

### Window Controls
- **Minimize button**: {colors.text-secondary} on hover: {colors.text-primary}
- **Maximize button**: {colors.text-secondary} on hover: {colors.text-primary}
- **Close button**: {colors.text-secondary} on hover: {colors.semantic-error}

### Window States
- **Normal**: Standard size
- **Minimized**: Collapsed to taskbar
- **Maximized**: Full screen, title bar visible

## Menu System

### Main Menu Bar
- **Height**: {menus.main-menu.height}
- **Background**: {colors.surface-dark}
- **Text**: {colors.text-primary}
- **Hover**: {colors.surface}

### Context Menu
- **Background**: {colors.surface}
- **Border**: 1px solid {colors.border}
- **Rounded**: {rounded.md}
- **Item height**: {menus.context-menu.item-height}
- **Hover**: {colors.surface-dark}

### Menu Items
- **Normal**: {colors.text-primary}
- **Disabled**: {colors.text-tertiary}
- **Selected**: {colors.primary} text on {colors.surface-dark}

## Keyboard Shortcuts

| Action | Shortcut |
|---|---|
| {{SHORTCUT_1_ACTION}} | {{SHORTCUT_1_KEY}} |
| {{SHORTCUT_2_ACTION}} | {{SHORTCUT_2_KEY}} |
| {{SHORTCUT_3_ACTION}} | {{SHORTCUT_3_KEY}} |

## System Integration

### Taskbar
- **Icon size**: 16x16
- **Icon color**: {colors.text-primary}
- **Tooltip font**: {typography.caption}

### System Tray
- **Icon size**: 16x16
- **Context menu**: Same as application context menu

### Dialog Behavior
- **Modal**: Blocks parent window
- **Modeless**: Allows interaction with parent
- **Message box**: Standard Windows message box style

## Do's and Don'ts

### Do
- {{DO_1}}
- {{DO_2}}
- {{DO_3}}

### Don't
- {{DONT_1}}
- {{DONT_2}}
- {{DONT_3}}

## Known Gaps

- {{KNOWN_GAP_1}}
- {{KNOWN_GAP_2}}