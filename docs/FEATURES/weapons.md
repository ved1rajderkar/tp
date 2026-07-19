# Weapons Feature

## Overview

Weapon system with multiple weapon types and customization.

## Weapon Categories

### Primary Weapons
- Pistols
- Rifles
- Shotguns

### Secondary Weapons
- SMGs
- Sniper Rifles
- Special Weapons

### Melee Weapons
- Swords
- Axes
- Unarmed

## Weapon Properties

```gdscript
class_name WeaponData
extends Resource

@export var name: String
@export var damage: float
@export var fire_rate: float
@export var range: float
@export var ammo_capacity: int
@export var reload_time: float
@export var spread: float
@export var projectile_scene: PackedScene
```

## Weapon Behaviors

### Hitscan
- Instant detection
- No travel time
- Accuracy affected by spread

### Projectile
- Travel time
- Affected by gravity
- Can pierce targets

### Burst
- Multiple shots per trigger
- Increased spread per shot
- Higher DPS potential

## Weapon Progression

- Unlock through gameplay
- Upgrade with materials
- Custom attachments

## Dependencies

- `scripts/weapons/weapon_base.gd`
- `scripts/weapons/weapon_manager.gd`
- `resources/weapons/*.tres`