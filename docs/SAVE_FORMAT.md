# Save Format

## File Location

Saves are stored in `saves/` directory.

## File Structure

```json
{
  "version": "1.0",
  "timestamp": "2026-01-01T00:00:00Z",
  "player": {
    "position": {"x": 0, "y": 0},
    "health": 100,
    "level": 1,
    "experience": 0,
    "inventory": [],
    "upgrades": []
  },
  "game_state": {
    "current_level": 1,
    "score": 0,
    "time_played": 0,
    "enemies_defeated": 0
  },
  "settings": {
    "audio_volume": 1.0,
    "sfx_volume": 1.0,
    "fullscreen": false
  }
}
```

## Save Slots

- Slot 1: `saves/save_1.json`
- Slot 2: `saves/save_2.json`
- Slot 3: `saves/save_3.json`
- Auto-save: `saves/auto_save.json`

## Version Migration

When updating save format, increment version number and implement migration logic in `scripts/save/save_manager.gd`.