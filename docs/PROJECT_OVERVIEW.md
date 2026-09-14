# ALI — THE BEGINNING: CHILDHOOD
# Project Overview & Architecture

## Project Identity

**Title:** ALI — THE BEGINNING: CHILDHOOD

**Engine:** Godot 4  
**Platform:** Android (Mobile)  
**Game Type:** 3D Historical Adventure  
**Version:** 0.1.0

## Game Concept

A 3D historical adventure game following the early life of Imam Ali (peace be upon him), beginning with his childhood in Mecca and continuing through the early period of Prophethood.

**Target Campaign Length:** Approximately 6 hours of main and side content

### Core Philosophy

**"THE PLAYER LEARNS WHO ALI IS THROUGH HIS ACTIONS, NOT THROUGH CONSTANT COMBAT."**

The player experiences Ali's character through:
- Exploration of historical locations
- Meaningful conversations
- Helping people in need
- Keeping promises and demonstrating honesty
- Showing justice, courage, mercy, and loyalty
- Social interactions and relationships
- Historical storytelling

## Key Design Principles

### 1. No Combat in Childhood Version
- NO sword combat
- NO modern weapons or firearms
- NO combat system
- NO battlefield combat

### 2. Historical Respect
- Game is historically inspired, not invented
- Different historical traditions are properly marked
- Islamic figures are represented respectfully
- Ali's acceptance of Islam is NOT a player choice

### 3. Mobile-First Performance
- Designed for lower-end Android devices
- Level of detail systems prepared
- Optimized for performance

### 4. Modular Architecture
- Systems are independent and reusable
- Data-driven design separates content from code
- Character models are reusable across multiple NPC roles

## Project Structure

```
Ali--emam/
├── project.godot              # Godot configuration
├── scenes/                    # Game scenes
│   └── main/
│       └── Main.tscn
├── scripts/                   # GDScript source code
│   └── core/
│       ├── Main.gd
│       ├── GameManager.gd
│       └── SceneManager.gd
├── characters/                # Character assets folder
├── environment/               # World environment folder
├── audio/                     # Audio assets folder
├── data/                      # Game data files folder
├── ui/                        # UI assets folder
├── assets/                    # General assets folder
└── docs/                      # Documentation
    └── PROJECT_OVERVIEW.md
```

## Current Phase: Foundation

- ✅ Godot project structure created
- ✅ Main scene initialized
- ✅ Core managers set up
- ✅ Documentation prepared
- ⏳ Ready for next phase

## What Is NOT Implemented

- ❌ Gameplay mechanics
- ❌ NPC systems
- ❌ Combat systems
- ❌ Mission systems
- ❌ Dialogue system
- ❌ Player character controller
- ❌ World environments
- ❌ 3D models or assets
- ❌ Animations
- ❌ Audio systems
- ❌ UI/HUD
- ❌ Save/Load systems
- ❌ Cinematic system

---

**Project Foundation Complete**  
**Do not proceed without approval for next phase**
