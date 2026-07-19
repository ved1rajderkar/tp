# Combat Feature

## Overview

Combat system handling weapons, projectiles, and damage.

## Components

### Weapon System
- Multiple weapon types
- Ammo management
- Fire rate control

### Projectile System
- Pooled projectiles
- Different projectile behaviors
- Collision handling

### Damage System
- Health management
- Damage calculation
- Status effects

## Weapon Types

### Hitscan
- Instant hit detection
- Line of sight required

### Projectile
- Travel time
- Arc trajectory possible
- Can be blocked

### Area of Effect
- Damage radius
- Friendly fire option

## Implementation Details

### Damage Formula
```
final_damage = base_damage * multiplier * (1 - defense)
```

### Critical Hits
- Base crit chance: 5%
- Crit multiplier: 2x
- Modifiable by upgrades

## Dependencies

- `scripts/combat/damage_calculator.gd`
- `scripts/weapons/weapon_manager.gd`
- `scripts/projectiles/projectile_pool.gd`