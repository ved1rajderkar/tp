# Balancing

## Player Stats

| Stat | Base Value | Max Value | Per Level |
|------|------------|-----------|-----------|
| Health | 100 | 500 | +20 |
| Move Speed | 200 | 400 | +10 |
| Attack Damage | 10 | 100 | +5 |
| Attack Speed | 1.0 | 2.0 | +0.1 |

## Weapon Stats

### Pistol
- Damage: 10
- Fire Rate: 1.0/s
- Range: 500
- Ammo: ∞

### Shotgun
- Damage: 5 x 8 pellets
- Fire Rate: 0.5/s
- Range: 300
- Ammo: 24

### Rifle
- Damage: 15
- Fire Rate: 3.0/s
- Range: 800
- Ammo: 120

## Enemy Stats

### Basic Enemy
- Health: 30
- Speed: 100
- Damage: 10
- Score: 100

### Fast Enemy
- Health: 20
- Speed: 200
- Damage: 5
- Score: 150

### Tank Enemy
- Health: 100
- Speed: 60
- Damage: 25
- Score: 300

## Formulas

### Damage Calculation
```
final_damage = base_damage * (1 + damage_bonus) * (1 - damage_reduction)
```

### Experience Required
```
xp_required = base_xp * (level ^ scaling_factor)
```