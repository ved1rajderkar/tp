# Upgrades Feature

## Overview

Player upgrade system for progression and customization.

## Upgrade Types

### Passive Upgrades
- Stat bonuses
- Permanent effects
- Stackable

### Active Upgrades
- New abilities
- Toggleable effects
- Cooldown-based

### Conditional Upgrades
- Triggered by events
- Combo effects
- Situational bonuses

## Upgrade Rarities

| Rarity | Color | Drop Rate |
|--------|-------|-----------|
| Common | White | 60% |
| Uncommon | Green | 25% |
| Rare | Blue | 10% |
| Epic | Purple | 4% |
| Legendary | Orange | 1% |

## Implementation

### Upgrade Data
```gdscript
class_name UpgradeData
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var rarity: Rarity
@export var effects: Array[UpgradeEffect]
```

### Effect System
- Modifiers for stats
- Triggers for abilities
- Multipliers for damage

## Upgrade Pool

- Pool of available upgrades
- Weighted random selection
- Duplicate protection

## Dependencies

- `scripts/upgrades/upgrade_manager.gd`
- `resources/upgrades/*.tres`