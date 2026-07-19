# Architecture

## System Overview

The game follows a modular architecture with clear separation of concerns.

## Core Systems

### Scene Management
- Main scene acts as entry point
- Scene transitions handled by SceneManager

### Player System
- Player controller with state machine
- Modular ability system

### Enemy System
- Enemy spawning and pooling
- AI behavior trees

### Combat System
- Weapon system with projectile handling
- Damage calculation and health management

## Data Flow

```
Input → Player Controller → Game State → Rendering
                  ↓
              Physics
```

## Directory Structure

See root README.md for full directory layout.