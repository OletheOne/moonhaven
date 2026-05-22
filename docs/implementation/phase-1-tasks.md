# Phase 1 — Implementation Tasks (Vertical Slice)

**Game:** Welcome to Moonhaven
**Goal:** Player wakes up in their cottage, walks outside, walks to the town center, talks to three NPCs, returns to the farm, tills a tile, plants a seed, waters it, sleeps. The next morning the seed has grown. The game can be saved and reloaded.

**Stack:** Godot 4.3+ (GDScript), Aseprite for any manual art touch-up, Git.

**Agent workflow:** Work tasks sequentially. After each task, run the game, verify acceptance criteria, commit with the task ID in the commit message (e.g. `T-04: implement camera follow`). Do not skip ahead. If you need to clarify a task, stop and ask rather than improvise.

**Naming rule:** The name "Moonhaven" is provisional. It must live in exactly one place — `Constants.GAME_TITLE` in `scripts/autoload/constants.gd` (created in T-01). All UI text that shows the name reads from this constant. Class names, autoload names, file names, and variable names are GENERIC (`GameState`, `SceneManager`, `title_theme.ogg`) — never include "moonhaven" in them.

**Reference:** All design decisions defer to `master-gdd.md`. When in doubt, that doc wins.

---

## Before You Start

1. Install **Godot 4.3+** (Standard, not .NET unless you specifically want C#).
2. Install **Git** and create a local repo for the project (already done if you followed `start-here.md`).
3. Install **Aseprite** (optional but useful for editing AI-generated sprites — not needed yet).
4. Open Cursor (or Claude Code) pointed at the project folder.
5. The master GDD should already be at `docs/design/master-gdd.md`.
6. This file should already be at `docs/implementation/phase-1-tasks.md`.
7. Begin with T-00.

---

## T-00 — Project Skeleton

Create the Godot project with this exact folder structure:

```
project_root/
├── project.godot
├── .gitignore
├── README.md
├── docs/
│   ├── start-here.md              (already placed)
│   ├── design/
│   │   └── master-gdd.md          (already placed)
│   └── implementation/
│       ├── phase-1-tasks.md       (already placed)
│       └── art-pipeline.md        (already placed)
├── scenes/
│   ├── player/
│   ├── npcs/
│   ├── world/
│   ├── ui/
│   └── systems/
├── scripts/
│   ├── player/
│   ├── npcs/
│   ├── world/
│   ├── ui/
│   ├── systems/
│   └── autoload/
├── art/
│   ├── sprites/
│   │   ├── player/
│   │   ├── npcs/
│   │   └── tiles/
│   ├── ui/
│   └── effects/
├── audio/
│   ├── music/
│   └── sfx/
├── data/
│   ├── npcs/
│   ├── dialogue/
│   ├── items/
│   ├── crops/
│   ├── quests/
│   └── clues/
└── ASSETS.md
```

In `project.godot`, set the project display name to "Moonhaven" and the window title to "Moonhaven". Configure 2D pixel rendering (Rendering > 2D > Snap > Snap 2D Transforms to Pixel = true; Textures > Default Texture Filter = Nearest).

**Acceptance:** Godot opens the project without errors. `.gitignore` excludes `.godot/`, `.import/`, `*.tmp`, and OS junk. README has the game title "Moonhaven," a one-paragraph pitch from the GDD, and a "How to Run" section. ASSETS.md is empty with just a header comment explaining its purpose (asset provenance log).

---

## T-01 — Constants & Time Singleton (Autoloads)

Create two autoloads:

**`scripts/autoload/constants.gd`** — global constants:
```gdscript
extends Node

const GAME_TITLE := "Moonhaven"
const TOWN_NAME := "Moonhaven"   # reads same as GAME_TITLE; can diverge later
const VERSION := "0.1.0"

const REAL_SECONDS_PER_GAME_MINUTE := 1.0
const STARTING_HOUR := 6
const STARTING_DAY := 1
const STARTING_SEASON := "Spring"
const STARTING_YEAR := 1
```

Register as autoload named `Constants`.

**`scripts/autoload/time_manager.gd`** — time tracking:

Responsibilities:
- Track current in-game time (hour 0–23, minute 0–59).
- Track current day (1–28), season (Spring/Summer/Autumn/Winter), year.
- Real time → in-game time using `Constants.REAL_SECONDS_PER_GAME_MINUTE`. Game starts at the constants' starting values.
- Emit signals: `minute_passed`, `hour_passed`, `day_started`, `day_ended`, `season_changed`.
- `freeze()` / `unfreeze()` methods for menus and cutscenes.
- `advance_to(hour, minute)` for sleep transitions.

Register as autoload named `TimeManager`.

**Acceptance:** A test scene reads `Constants.GAME_TITLE` and prints "Moonhaven". Time advances smoothly — "Tick" prints every in-game minute, "New day: [N]" when day rolls over. Calling `freeze()` halts ticks.

---

## T-02 — Player Scene (Movement)

Create `scenes/player/player.tscn` with:
- `CharacterBody2D` root
- `Sprite2D` (use a placeholder 16x32 PNG — solid color block is fine for now; mark in ASSETS.md as `[placeholder]`)
- `CollisionShape2D` (10x12 capsule at the feet, not the whole sprite)
- `AnimationPlayer` with `idle_down`, `idle_up`, `idle_left`, `idle_right`, `walk_down`, `walk_up`, `walk_left`, `walk_right` (placeholder: single-frame animations are fine)

`scripts/player/player.gd`:
- 4-directional movement (WASD + arrow keys + left stick).
- Walking speed: 80 px/s. Running speed: 140 px/s (Shift held).
- Faces last-moved direction when idle.
- Plays the correct animation based on movement state and facing.

**Acceptance:** Place player in a blank test scene. Player moves smoothly with WASD/arrows. Running with Shift is faster. Player faces direction last moved. No diagonal speed boost (normalize the input vector).

---

## T-03 — Camera Follow

Add a `Camera2D` to the player scene. Settings:
- `position_smoothing_enabled = true`
- `position_smoothing_speed = 5.0`
- Zoom: 3x (we're working at 16x16 base tile; 3x makes things readable at 1080p)
- Snap to pixel grid (verify project setting from T-00).

**Acceptance:** Camera follows player smoothly. No jitter on pixel boundaries. Zoom feels right at 1080p.

---

## T-04 — Cottage Interior Scene

Create `scenes/world/cottage_interior.tscn`:
- A 12x10 tile room.
- TileMap with 3 layers: floor, walls/decoration, collision.
- Use a placeholder tileset (solid colors per tile type — wood floor brown, wall gray). Mark in ASSETS.md.
- Place: a bed (top-left area), a hearth (right wall), a door (bottom center), a chest (TBD later).
- An "exit zone" Area2D at the door triggers transition to exterior.

**Acceptance:** Player spawns in cottage. Walls collide. Player can walk to the door. Door area is detectable but doesn't transition yet (T-08 handles that).

---

## T-05 — Cottage Exterior Scene

Create `scenes/world/cottage_exterior.tscn`:
- A 30x30 tile area.
- Cottage building (use a 6x5 tile placeholder block).
- A door zone matching the interior exit.
- A small farm plot area (5x5 tiles of "tillable dirt" placeholder).
- A road exiting south toward town.
- Trees and decorative tiles around the edges (placeholders).

**Acceptance:** Player can walk around cottage exterior. Cannot walk through the cottage building. Door zone overlaps the cottage entrance. Farm plot area is visually distinct.

---

## T-06 — Town Center Scene

Create `scenes/world/town_center.tscn`:
- A 40x30 tile area.
- A central fountain (placeholder 3x3 sprite, with a small collision rect).
- Three NPC houses (Thaddeus's Pemberton Hall, Bram's bakery, Marisol's apothecary) — each is a 5x5 placeholder building.
- A road entry on the north side (from cottage direction).
- Decorative tiles, lampposts (placeholders).
- Three NPC spawn markers (Node2D nodes named `thaddeus_spawn`, `bram_spawn`, `marisol_spawn`).

**Acceptance:** Player can walk around town. Buildings collide. NPC spawn markers exist at sensible locations (Thaddeus near Pemberton Hall door, etc.).

---

## T-07 — Scene Transition System

Create `scripts/autoload/scene_manager.gd` autoload.

API:
- `change_scene(scene_path: String, spawn_point: String)` — fades to black, loads new scene, places player at the Node2D named `spawn_point` in the new scene, fades in.
- Transition takes ~0.4s total.
- `TimeManager.freeze()` during transition.

Wire up the cottage interior door → cottage exterior, cottage exterior door → cottage interior, cottage exterior south road → town center north entry, and reverse.

Each destination scene needs spawn markers named to match (e.g. `from_exterior`, `from_interior`, `from_cottage`, `from_town`).

**Acceptance:** Player walks through cottage door → fade → appears outside at the door. South road → fade → town center. All transitions work in both directions. No camera jumps mid-fade.

---

## T-08 — Day/Night Visual Cycle

Create `scenes/systems/world_lighting.tscn`:
- A `CanvasModulate` node child of each world scene (or a global one — your call, but consistent).
- Modulate color changes based on `TimeManager.hour`:
  - 6:00–8:00: warm sunrise (slight orange tint, lightening)
  - 8:00–18:00: full daylight (white, no tint)
  - 18:00–20:00: golden hour → dusk (orange → deep blue)
  - 20:00–6:00: night (deep blue-purple, ~50% brightness)
- Smooth interpolation between phases (lerp over ~30 in-game minutes at boundaries).

**Acceptance:** Spend ~2 minutes of real time in the cottage exterior. Watch the world go from morning through midday to evening to night. Transitions are smooth, not popping. Indoor scenes stay lit (no modulate inside, or much milder).

---

## T-09 — Sleep / End-of-Day

In the cottage interior, the bed gets an interact zone. When the player presses the interact button on it:
- Prompt: "Sleep until morning?" (Yes/No).
- If Yes: fade to black (1s), `TimeManager.advance_to(6, 0)` and increment day, "Day [N]" caption appears for 1.5s, fade in. Player respawns at the bed.
- If it's before 6 PM, the prompt should say "It's too early to sleep" instead and not advance time.

**Acceptance:** Walk to bed after dusk → prompt → sleep → wake at 6 AM next day with the day counter incremented. Walking to bed during the day shows the "too early" message.

---

## T-10 — Save / Load System

Create `scripts/autoload/save_manager.gd`.

Saves to `user://savegame.json`. Save state includes:
- Current scene path
- Player position
- Time state (day, hour, minute, season, year)
- Crop states (T-15 will populate this)
- Inventory contents (T-13)
- Dialogue flags / quest flags (empty dict for now)

API:
- `save_game()` — writes JSON.
- `load_game()` — reads JSON, applies state, transitions to saved scene.
- `has_save() -> bool`
- Auto-save on sleep (end of day).

**Acceptance:** Sleep advances day and saves. Quit and reload — main menu offers Continue, which loads the saved state and places the player back in the cottage at 6 AM.

---

## T-11 — Main Menu

Create `scenes/ui/main_menu.tscn`:
- Title: shows `Constants.GAME_TITLE` rendered in parchment-style placeholder.
- Buttons: New Game, Continue (greyed out if no save), Quit.
- New Game → starts in cottage interior, day 1, 6 AM.
- Continue → calls `SaveManager.load_game()`.

Set the main menu as the project's main scene.

**Acceptance:** Game launches to menu. Title reads "Moonhaven". New Game works. Continue is properly enabled/disabled based on save existence. Quit closes the game cleanly.

---

## T-12 — Dialogue System (Data-Driven)

Create the dialogue engine. This is the biggest task in Phase 1 — take it slow.

Dialogue files live at `data/dialogue/<npc_id>.yaml`. Format:

```yaml
default:
  - text: "Oh, hello there. New face in Moonhaven?"
  - text: "Don't be a stranger."

after_first_meeting:
  - text: "Good to see you again."
  - choices:
      - text: "How are you?"
        response:
          - text: "Oh, you know. Same old."
      - text: "Goodbye."
        response: []
```

Engine responsibilities:
- Load YAML files at startup into a dialogue cache.
- A `DialogueRunner` node that takes (npc_id, conversation_key) and plays through the lines.
- A dialogue box UI scene with portrait slot (placeholder), name, text, and choice list.
- Text appears letter-by-letter (configurable speed, default 40 chars/sec). Pressing interact during reveal completes the line instantly.
- Choices appear after the line ends, navigated with up/down + interact (or click).
- A flag-checking system: `if flag.has_met_thaddeus` style conditions on conversation keys (we'll wire flags via `SaveManager` state).

**Acceptance:** A test NPC can be talked to. Multiple dialogue lines flow correctly. Choices branch into responses. Letter-by-letter reveal works. Pressing interact mid-line completes the line.

---

## T-13 — Inventory System (Minimal)

Create `scripts/autoload/inventory.gd`.

API:
- `add_item(item_id: String, count: int = 1) -> bool`
- `remove_item(item_id: String, count: int = 1) -> bool`
- `has_item(item_id: String, count: int = 1) -> bool`
- `get_count(item_id: String) -> int`

Items defined in `data/items/items.json`:
```json
{
  "hoe": {"name": "Hoe", "type": "tool", "stackable": false},
  "watering_can": {"name": "Watering Can", "type": "tool", "stackable": false},
  "carrot_seed": {"name": "Carrot Seed", "type": "seed", "stackable": true, "max_stack": 99, "grows_into": "carrot", "days_to_grow": 4},
  "carrot": {"name": "Carrot", "type": "crop", "stackable": true, "max_stack": 99, "value": 35}
}
```

Inventory UI: a 12-slot hotbar visible at the bottom of the screen. Number keys 1–9, 0, -, = select slot. Selected tool/item is what the interact button uses.

Starting inventory (new game): hoe, watering can, 10 carrot seeds.

**Acceptance:** Inventory loads from data on new game. Hotbar shows the items. Selecting different slots changes the active item. Item counts decrement when used.

---

## T-14 — NPC Base + Three NPCs

Create `scenes/npcs/npc_base.tscn`:
- `CharacterBody2D` root (no movement code yet — they stand still in Phase 1).
- Sprite, collision, interact area (Area2D in front of them, ~16px reach).
- Script: `npc.gd` takes `npc_id` exported var, loads NPC data from `data/npcs/<npc_id>.json`, registers with the dialogue system.

Create three NPC data files:

`data/npcs/thaddeus.json`:
```json
{
  "id": "thaddeus",
  "display_name": "Thaddeus Pemberton",
  "default_dialogue_key": "default",
  "starting_scene": "town_center",
  "starting_position_marker": "thaddeus_spawn"
}
```
(Same shape for `bram.json` and `marisol.json`.)

Create three dialogue files in `data/dialogue/` with Phase 1 placeholder content. Use the tone reference lines from the GDD §14 as starting points. Each NPC needs:
- `default` (first meeting): introduces themselves, drops a hint at their supernatural nature without confirming it, welcomes the player to Moonhaven.
- `repeat` (subsequent talks): a short, in-character one-liner.

Any in-dialogue references to the town name should pull from `Constants.TOWN_NAME` rather than hard-coding "Moonhaven" (we can do this via string interpolation when loading dialogue, or by writing dialogue files with a `{TOWN}` token that gets replaced at load time).

Instantiate the three NPCs in `town_center.tscn` at their spawn markers.

**Acceptance:** Walking up to an NPC and pressing interact opens dialogue. Each NPC has distinct lines. Re-talking to an NPC the same day shows the `repeat` line.

---

## T-15 — Tilling, Planting, Watering

The farm plot in cottage exterior gets a `FarmTileMap` system.

Each farm tile has a state: `untilled`, `tilled_dry`, `tilled_wet`, `planted_dry`, `planted_wet`, `grown`.

Interactions:
- **Hoe equipped + interact on `untilled`** → becomes `tilled_dry`. Tile visually changes (placeholder: brown patch).
- **Seed equipped + interact on `tilled_dry` or `tilled_wet`** → becomes `planted_dry` (or `planted_wet`). Seed count decrements. Tile shows a small sprout placeholder.
- **Watering can equipped + interact on `tilled_dry` or `planted_dry`** → becomes wet variant. Visually darker.
- **Interact on `grown` tile** → harvest the crop into inventory. Tile becomes `untilled`.

Day rollover logic (signal from `TimeManager.day_started`):
- All `tilled_wet` → `tilled_dry` (water evaporates).
- All `planted_wet` → if days_since_planted ≥ crop's `days_to_grow`, become `grown`. Otherwise become `planted_dry`.
- All `planted_dry` → no growth that day, stays `planted_dry`.

State persists through save/load.

**Acceptance:** Till a tile. Plant a carrot seed. Water it. Sleep. Wake up — tile is dry. Water again, sleep, repeat until day 5. Tile is now `grown`. Interact to harvest. Carrot is in inventory.

---

## T-16 — Interact System Polish

The interact button (E on keyboard, A on gamepad) should context-switch correctly:
- Near an NPC → talk.
- On a farm tile with the right tool → till/water/plant/harvest.
- On the bed → sleep.
- On a door zone → (already handled by area trigger, but interact also works).

Show a small floating prompt above the player when something interactable is in range ("[E] Talk to Thaddeus", "[E] Sleep", "[E] Till").

**Acceptance:** Prompts appear and disappear correctly as the player approaches/leaves interactables. The right action fires for each interactable type.

---

## T-17 — Pause Menu

ESC opens a pause menu overlay. Buttons:
- Resume
- Save Game (manual save, in addition to auto-save on sleep)
- Quit to Main Menu

`TimeManager.freeze()` while paused.

**Acceptance:** ESC pauses the game (time stops, player can't move). Resume unpauses. Save Game writes the save file. Quit returns to main menu cleanly (no orphan nodes).

---

## T-18 — First Audio Pass

Drop in placeholder audio:
- **Music:** one looping town theme in `audio/music/town_theme.ogg`. Plays in town_center scene. Different (quieter) track or silence in the cottage. (For now, generate a 30-second looping cozy acoustic track via AIVA or use a CC0 placeholder. Log it in ASSETS.md.)
- **SFX:**
  - Footstep on grass (looping while walking, varies pitch slightly per step)
  - Door open/close
  - Hoe hit / dirt sound
  - Water pour
  - UI click (menu navigation)
  - Dialogue text "tick" (per character or every N characters)

Create `scripts/autoload/audio_manager.gd` with `play_sfx(name)` and `play_music(track, fade_in_seconds)` methods. All sounds load from `audio/sfx/` and `audio/music/`. File names are generic — `town_theme.ogg`, not `moonhaven_town_theme.ogg`.

**Acceptance:** Music plays in town, footsteps sound while walking, tools make sounds when used, dialogue ticks. Levels are mixed reasonably (music quieter than SFX). Audio settings can be tweaked in a settings file but no UI for it yet (Phase 2 will add a settings menu).

---

## T-19 — Day 1 Scripted Sequence

When the player starts a new game, the first day plays out with light scripting:

1. Player wakes in cottage. Brief inner monologue (use the dialogue system with `narrator` as a special "speaker"): three lines establishing they arrived last night, the locket is on the bedside table, they should explore town.
2. Picking up the locket adds it to a "Key Items" inventory (separate from the regular hotbar — just a list in the pause menu for now).
3. Walking outside and reaching the south road triggers another narrator line: "Moonhaven. Smaller than the map made it look."
4. Talking to all three NPCs sets a flag `met_all_three_npcs`.
5. Sleeping that night with the flag set triggers a single narrator line on wake-up Day 2: "Day two. The locket feels heavier than it should."

This is the bare minimum hook for the story to feel like a story.

Any reference to "Moonhaven" in narrator lines should be loaded from `Constants.TOWN_NAME` via the same token-replacement system as NPC dialogue.

**Acceptance:** A full Day 1 playthrough triggers all five narrative beats in order. Save/load mid-day preserves which beats have fired.

---

## T-20 — Vertical Slice Polish & Bug Pass

No new features. The agent should:
- Play the game from new-game through Day 3.
- Note every bug, jank, and missing feedback moment in `docs/implementation/phase-1-bugs.md`.
- Fix everything in that list.
- Replay until smooth.
- Tag this commit `vertical-slice-v1`.

**Acceptance:** A new player (you, Brandon) can play from launch through Day 3 without confusion or visible bugs. The vibe is recognizably the game in the GDD, even with placeholder art.

---

## Done?

If T-20 passes a real playtest, Phase 1 is complete. Stop. Sit with it for a day or two. Decide whether the *feel* is right before scaling up. If yes, we'll write `phase-2-tasks.md` covering: full town map, all 18 villagers, robust dialogue (heart events), the Mystery Board, and Act 1 main quest. If no, the GDD needs revision before more code is written.

---

## Agent Operating Notes

- **Commit per task.** Format: `T-XX: <verb> <thing>`. One commit per acceptance criterion is even better.
- **Don't generate final art yet.** Placeholders only through Phase 1. We're proving the vibe with mechanics first. Art generation runs as the parallel `art-pipeline.md` track.
- **Log every generated asset in `ASSETS.md`** with tool, model, prompt, license tier, date.
- **If stuck for more than two attempts on the same task, stop and ask.** Don't spiral.
- **Test on the actual target resolution (1920x1080 windowed).** Pixel art looks different at every zoom level — pick one and stick to it.
- **Respect the naming rule.** "Moonhaven" only in `Constants.GAME_TITLE` and `Constants.TOWN_NAME`. Never in class names, file names, or variable names.
