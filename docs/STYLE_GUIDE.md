# Style Guide

## GDScript Conventions

### Naming
- **Classes**: PascalCase (`PlayerController.gd`)
- **Variables**: snake_case (`move_speed`)
- **Functions**: snake_case (`calculate_damage()`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_HEALTH`)
- **Signals**: past_tense (`health_changed`)

### File Organization
```gdscript
extends Node
class_name ClassName

# Constants
const MAX_VALUE = 100

# Signals
signal example_signal

# Enums
enum State { IDLE, MOVING, ATTACKING }

# Exported variables
@export var speed: float = 100.0

# Private variables
var _internal_state: int = 0

# Public variables
var health: int = 100

# Built-in methods
func _ready():
    pass

func _process(delta):
    pass

# Public methods
func public_method():
    pass

# Private methods
func _private_method():
    pass
```

## Scene Naming

- Player scenes: `player_*.tscn`
- Enemy scenes: `enemy_*.tscn`
- UI scenes: `ui_*.tscn`

## Resource Naming

- Configs: `*_config.tres`
- Data: `*_data.tres`