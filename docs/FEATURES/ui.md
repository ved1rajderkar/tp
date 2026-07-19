# UI Feature

## Overview

User interface system for game menus and HUD.

## UI Components

### HUD
- Health bar
- Ammo counter
- Score display
- Minimap

### Menus
- Main menu
- Pause menu
- Settings menu
- Inventory screen

### Popups
- Dialog boxes
- Tooltips
- Notifications

## UI Framework

### Scene Structure
```
UI Root
├── HUD
│   ├── HealthBar
│   ├── AmmoCounter
│   └── ScoreDisplay
├── Menus
│   ├── MainMenu
│   ├── PauseMenu
│   └── SettingsMenu
└── Popups
    ├── DialogBox
    └── Tooltip
```

### Theme System
- Custom theme resource
- Responsive scaling
- Color schemes

## Input Handling

- UI navigation with keyboard/gamepad
- Mouse/touch support
- Focus management

## Animations

- Menu transitions
- HUD element animations
- Popup effects

## Accessibility

- Colorblind modes
- Text scaling
- Input remapping

## Dependencies

- `scripts/ui/ui_manager.gd`
- `scripts/ui/hud_controller.gd`
- `scenes/ui/*.tscn`