# PROJECT REQUIREMENTS DOCUMENT (PRD)

Version: 1.0
Status: Living Document
Project Name: radgo

---

# PURPOSE

This document is the single source of truth for the project.

The AI MUST read this file before making ANY code changes.

This document defines:

- What the project is
- What the project is NOT
- Every gameplay system
- Architecture
- Features
- Progress
- Current Tasks
- Future Roadmap
- Technical Rules

Whenever the project changes,
THIS DOCUMENT MUST ALSO CHANGE.

Never allow the PRD to become outdated.

---

# PROJECT SUMMARY

Describe the game in one paragraph.

Example:

A physics-based multiplayer archery game inspired by Ragdoll Archers featuring active ragdoll characters, procedural enemies, upgrade systems, multiple arrow types, wave survival, and high replayability.

---

# CORE GAME LOOP

Player enters match

↓

Move

↓

Aim

↓

Shoot

↓

Kill enemy

↓

Collect rewards

↓

Upgrade

↓

Fight stronger enemies

↓

Repeat

---

# TARGET PLATFORM

- Windows
- Linux
- Web
- Android (Future)

Engine:
Godot 4.x

Language:
GDScript

Rendering:
Forward+

Physics:
Godot Physics

---

# PROJECT GOALS

The project MUST:

✔ feel satisfying

✔ have responsive controls

✔ run at 60 FPS

✔ support controller

✔ support keyboard

✔ support future multiplayer

✔ be expandable

---

# OUT OF SCOPE

The AI MUST NOT build these unless requested.

❌ MMORPG

❌ Open World

❌ Story Campaign

❌ Crafting

❌ Inventory RPG

❌ Hundreds of NPCs

❌ Unrealistic physics

❌ Pay-to-win

---

# GAMEPLAY SYSTEMS

Every gameplay mechanic belongs here.

Each system contains:

Purpose

Current Status

Dependencies

Files

Future improvements

Example:

---

## Movement

Status:
Complete

Purpose:

Move left

Move right

Jump

Air movement

Dependencies:

Player

Physics

Animation

Files:

player_controller.gd

Future:

Wall jump

Dash

Slide

---

## Bow System

Status:
In Progress

Features:

Charge shot

Aim

Fire

Cooldown

Arrow spread

Dependencies:

Arrow Scene

Input

Animation

Files:

bow.gd

arrow.gd

Future:

Crossbow

Magic Bow

Heavy Bow

---

## Enemy AI

Status:
Planned

Features:

Patrol

Aim

Shoot

Avoid cliffs

Jump

Difficulty scaling

---

## Damage System

Status:
Complete

Supports:

Headshot

Body damage

Critical hit

Knockback

Death

Invincibility frames

---

## Upgrade System

Status:
Planned

Health

Stamina

Arrow Damage

Attack Speed

Arrow Count

Jump Height

Movement Speed

Luck

Critical Chance

---

# GAME STATES

Main Menu

Loading

Playing

Paused

Victory

Defeat

Game Over

Upgrade Menu

Settings

---

# PLAYER FEATURES

Health

Stamina

Movement

Jump

Bow

Aim

Animation

Ragdoll

Death

Respawn

Camera

Audio

Particles

Controller Support

Achievements

Statistics

---

# ENEMY FEATURES

Health

AI

Navigation

Bow

Jump

Different Types

Bosses

Elite Enemies

Loot Drops

Scaling Difficulty

---

# ITEM SYSTEM

Apples

Coins

Skulls

Weapons

Power Ups

Temporary Buffs

Permanent Upgrades

---

# UI

Main Menu

HUD

Health Bar

Stamina

Coins

Wave Counter

Damage Numbers

Pause Menu

Settings

Upgrade Screen

Game Over Screen

---

# AUDIO

Music

Ambience

Arrow Shoot

Hit

Death

UI Sounds

Footsteps

Power Ups

---

# SAVE SYSTEM

Unlocked upgrades

Settings

Statistics

Achievements

Best Score

Last Session

---

# SETTINGS

Fullscreen

Windowed

Volume

Sensitivity

Graphics

Keybinds

Controller

Language

Accessibility

---

# PERFORMANCE TARGETS

60 FPS Minimum

Less than 300 Draw Calls

Object Pooling

No Memory Leaks

LOD if needed

Physics Optimized

---

# PROJECT STRUCTURE

res://

Scenes/

Scripts/

Assets/

UI/

Audio/

Materials/

Models/

Animations/

Resources/

Autoload/

Save/

---

# CODING RULES

AI MUST:

Write modular code

Never duplicate logic

Use signals

Use Resources

Use Components

Document complex code

Never hardcode values

Use constants

Keep scripts under 400 lines

---

# FEATURE CHECKLIST

Movement

Jump

Bow

Arrow

Enemy

Health

Damage

Particles

Animation

Audio

UI

Pause

Settings

Save

Upgrades

Achievements

Statistics

Controller

Localization

Optimization

Multiplayer Ready

---

# CURRENT MILESTONE

Example:

Milestone 1

☐ Movement

☐ Camera

☐ Bow

☐ Arrow

☐ Enemy

☐ Health

☐ UI

---

# BACKLOG

Features to build later.

Priority:

High

Medium

Low

Every backlog item should include:

Description

Estimated complexity

Dependencies

---

# BUG TRACKER

Every discovered bug goes here.

Example:

ID:
BUG-012

Description:
Arrow occasionally passes through enemy.

Status:
Open

Priority:
High

Assigned:
AI

---

# CHANGELOG

Every AI session updates this.

Example:

v0.3.2

Added bow charging

Improved ragdoll

Fixed enemy AI

Optimized particles

---

# AI DEVELOPMENT RULES

Before writing code:

Read this PRD.

Update the task list.

Check existing systems.

Avoid duplicate features.

After coding:

Update completed features.

Update changelog.

Update milestone progress.

Add newly discovered bugs.

Never leave the PRD outdated.

---

# DEFINITION OF DONE

A feature is complete only if:

✔ Works

✔ Tested

✔ No console errors

✔ Optimized

✔ Documented

✔ Added to PRD

✔ Added to Changelog

✔ Added to Save System if required

✔ UI updated if required

✔ No placeholder assets

---

END OF DOCUMENT