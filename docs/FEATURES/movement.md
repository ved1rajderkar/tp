# Movement Feature

## Overview

Player movement system with smooth controls and state management.

## Implementation

### States
- IDLE: Standing still
- MOVING: Active movement
- DASHING: Quick movement burst
- SLOWED: Reduced speed effect

### Parameters
```gdscript
@export var move_speed: float = 200.0
@export var acceleration: float = 1000.0
@export var friction: float = 800.0
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.2
```

### Input Handling
- Uses `Input.get_vector()` for movement direction
- Supports keyboard and gamepad
- Smooth acceleration and deceleration

### Physics
- CharacterBody2D for collision handling
- Separate collision layers for different object types

## Dependencies

- `scripts/player/player_controller.gd`
- `scripts/physics/physics_manager.gd`

## Testing

- Movement responsiveness
- Collision detection accuracy
- Performance under load