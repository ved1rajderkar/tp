# AI Feature

## Overview

Enemy AI system using behavior trees and state machines.

## AI Architecture

### Behavior Tree
- Root node selects behavior
- Conditions check game state
- Actions execute behaviors

### State Machine
- IDLE: Patrol or wait
- CHASE: Pursue target
- ATTACK: Engage in combat
- FLEE: Retreat when low health

## Enemy Types

### Melee Enemy
- Close range combat
- Charge attack
- Flanking behavior

### Ranged Enemy
- Keep distance
- Take cover
- suppressive fire

### Support Enemy
- Buff allies
- Heal nearby enemies
- Debuff player

## Parameters

```gdscript
@export var detection_range: float = 300.0
@export var attack_range: float = 50.0
@export var flee_health_threshold: float = 0.3
@export var path_update_interval: float = 0.5
```

## Navigation

- Uses NavigationServer2D
- Dynamic pathfinding
- Obstacle avoidance

## Dependencies

- `scripts/ai/behavior_tree.gd`
- `scripts/ai/state_machine.gd`
- `scripts/enemy/enemy_controller.gd`