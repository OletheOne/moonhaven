# Welcome to Moonhaven — Game Design Document

**Version:** 1.0
**Genre:** Cozy supernatural life-sim with mystery-driven main story
**Inspiration:** Stardew Valley (vibe, systems, art); Night in the Woods, Disco Elysium, Spiritfarer (tone, narrative)
**Engine:** Godot 4 (2D, GDScript primary, C# allowed for heavy systems)
**Platform:** PC (Windows/Mac/Linux) first
**Player perspective:** Top-down, pixel art, ~16x16 base tile

This document is the single source of truth for AI agents implementing the game. Anything not specified here defaults to "match Stardew Valley conventions unless that conflicts with the supernatural/cozy-spooky tone."

---

## 1. Pillars

Every design decision must serve at least one pillar. If a feature serves none, cut it.

1. **Cozy, never grim.** Spooky is welcome. Horror is not. The vampire bartender complains about the wine list, not about blood.
2. **The mystery pulls; the town holds.** The mystery gives forward momentum. The town and its residents are the reason the player stays.
3. **Every system rewards play.** No grinding for grinding's sake. Even idle activities (fishing under a full moon) progress *something* — a relationship, a skill, a clue.
4. **The supernatural choice is meaningful.** Whatever the player picks, it changes how the world responds to them — dialogue, access, abilities, ending flavor.
5. **The endgame is the same world, calmer.** After the mystery resolves, the town remains, festivals continue, new quests appear. The player should *want* to keep living there.

---

## 2. The Mystery (Main Story)

### 2.1 Setup — The Cold Open (Pre-Moonhaven)

The player is a traveler — no fixed home, going town to town doing odd jobs. The game opens on a road at dusk. A storm hits. Player takes shelter in an abandoned coach station and finds:

- A **locket** with a portrait of a young woman, inscription on the back: *"To Wren, who always comes home — E."*
- A **half-burned letter** dated decades ago, referencing "the meeting at Hollow's End" and warning Wren not to return until "the Veil is mended."
- A **map fragment** showing a road that doesn't appear on any modern map, ending at a town called Moonhaven.

The player can pocket the items and move on — but the road on the map seems to appear when they look for it. Following it leads to Moonhaven.

### 2.2 The Mystery's Real Shape

(Spoilers for the agent. The player learns this over ~30 hours.)

Moonhaven exists inside a **Veil** — a magical boundary that hides it from the human world and slows time inside. It was founded ~200 years ago by **Elowen "Wren" Marsh**, a human witch, as a sanctuary for supernatural beings being hunted in the outside world. The Veil is anchored by a ritual that requires a living human heart willingly given — Wren gave hers, transformed into something neither alive nor dead, and became the Veil's keeper.

Decades ago, Wren vanished. The Veil has been weakening ever since. Townsfolk have noticed: the moon looks wrong some nights, time inside the Veil is drifting out of sync, beings are showing up at the border with no memory of how they got there. The Council of Moonhaven (one elder per faction) has been quietly managing the decay, hoping a successor will appear.

**The player is a descendant of Wren's human family** — the only bloodline that can re-anchor the Veil. The locket was Wren's. It found its way to the player because the Veil is reaching for them.

**The central question driving the game:** *What happened to Wren, and what does the player do about the failing Veil?*

The mystery has three layers, each unlocking the next:
- **Layer 1 (Acts 1–2):** Who was Wren? Why does the town react oddly when the player shows the locket?
- **Layer 2 (Acts 2–3):** Where did Wren go? Was she killed, did she leave, did she become something else?
- **Layer 3 (Acts 3–5):** What is the player willing to do about the Veil? (The endgame choice.)

### 2.3 Act Structure

**Act 1 — Arrival (≈3–5 hours):** Player arrives, is given a derelict cottage on the edge of town by the mayor (a ghost named **Thaddeus Pemberton**, who recognizes the locket but plays coy). Tutorial systems unlock: farming, foraging, talking to townsfolk, basic mystery board. The player learns the town is supernatural through small reveals (the baker is a werewolf; the bartender's reflection is missing; a child phases through a wall). The act ends with the **Choice Event** (see §3).

**Act 2 — Belonging (≈8–12 hours):** Player establishes themselves in town. Most side content opens. The mystery progresses through finding Wren's old diary pages scattered across the map (foraging-style). Player builds relationships with the Council.

**Act 3 — Cracks (≈8–12 hours):** The Veil's decay becomes visible — weather glitches, NPCs forgetting things, a "thin place" appears in the forest. Player learns Wren didn't die, she *fragmented* — pieces of her consciousness are scattered across supernatural beings she imprinted on before vanishing.

**Act 4 — Gathering (≈6–8 hours):** Player reassembles Wren's memories by helping each Council member confront something Wren left with them. This doubles as deep character work for each faction elder.

**Act 5 — The Choice (≈2–4 hours):** Player learns the truth: Wren left voluntarily because the burden was destroying her. The Veil can be re-anchored in one of several ways, each tied to the player's supernatural choice (see §3.3). Multiple endings. Game continues in post-credits "Tended Veil" mode regardless.

### 2.4 The Mystery Board (UI System)

A corkboard in the player's cottage that tracks the investigation. Clues are physical items (letters, photos, objects) that the player drags onto the board. Connections between clues unlock new dialogue options elsewhere in the game. This is the player's main tool for tracking the main story and any "investigation" side quests.

Implementation note: the board is data-driven — clues are entries in a clues database, connections are valid pairs defined in data, unlocking a connection fires a flag that NPCs check in their dialogue trees.

---

## 3. The Supernatural Choice

### 3.1 When and How

End of Act 1, the player attends the **Moonbloom Festival**. During the festival, an NPC — **Marisol**, a witch who runs the apothecary — pulls the player aside. She has identified the player as a Marsh descendant. She explains, gently, that the town's borders won't fully accept the player as long as they're "unanchored to the otherworld." She offers a choice.

She does *not* pressure. The player can refuse entirely. Refusal has its own arc.

### 3.2 The Options

Five paths, each with distinct gameplay implications:

| Path | Granted By | Signature Mechanic | Drawback |
|---|---|---|---|
| **Werewolf** | A bite ritual from **Bram**, the baker (transparently consensual; he hates the cliché) | Lunar power cycle: stronger on full moon, weaker on new. Wolf form for fast travel and combat. | Some NPCs less comfortable until trust raised |
| **Vampire** | A blood pact with **Sable**, the bartender | Never tire at night (extended day length after dusk); charm dialogue option | Sunlight reduces stamina; certain herbs harmful |
| **Ghost** | A near-death ritual with **Thaddeus** | Phase through certain walls; commune with other spirits for clues | Cannot use most weapons; harder farming (less corporeal grip) |
| **Witch (full)** | Apprenticeship with **Marisol** | Crafting magic items, brewing potions with major effects, divination mini-game | Slower combat, requires consumables |
| **Human (refuse)** | Refuse the offer | Higher crop yields, NPCs treat as a curiosity, unique dialogue throughout | Locked out of certain supernatural-only areas (until story workarounds in Act 3) |

**Design rule:** every path must reach the ending. The mystery is solvable as any of them. The endings differ thematically, not in "win/lose."

### 3.3 Path-Specific Endings

Each path resonates with a different way of re-anchoring the Veil:

- **Werewolf:** Anchor through *pack* — bind the Veil to the community itself, distributed.
- **Vampire:** Anchor through *time* — pay a slow cost over centuries instead of one heart.
- **Ghost:** Anchor through *memory* — become a co-keeper with Wren's lingering essence.
- **Witch:** Anchor through *ritual* — design a new sustainable spell. Most "puzzle" of the endings.
- **Human:** Anchor through *bloodline* — the rarest ending; reveals the deepest Marsh family lore.

---

## 4. The Town of Moonhaven

### 4.1 Map Overview

The map is bigger than Stardew's Pelican Town but feels similarly intimate — areas are dense, not sprawling.

- **Town Center:** Cobblestone square, fountain, gazebo. Festival site.
- **The Sablewood Inn & Tavern:** Hub for evening activity. Sable's domain.
- **Pemberton Hall (Town Hall):** Thaddeus's residence and the mayor's office.
- **Marisol's Apothecary:** Item shop with magical inventory; also her home upstairs.
- **Hearthfire Bakery:** Bram's. Quest hub for cooking/baking content.
- **The Veiled Library:** Run by **Cassiel**, a fallen angel turned librarian. Lore dispensary.
- **The Player's Cottage:** Starts derelict, upgrades over time.
- **The Farm Plot:** Behind the cottage. Standard farming systems.
- **Whispering Wood:** Forest north of town. Foraging, fishing pond, deeper mystery zones in later acts.
- **The Hollow:** A clearing in the wood where the Moonbloom Festival is held; site of the Choice; final-act story locus.
- **The Border (Veil's Edge):** Player cannot leave Moonhaven in early game. The Veil itself is a visible shimmering boundary at map edges.

### 4.2 Cast (Minimum Viable)

A full Stardew-like cast is ~30 named villagers. For a feasible scope, target **18 named villagers** at launch, expandable. The Council Elders (5) are mandatory. The remaining 13 fill out factions and provide romance/friendship options.

**Council Elders (mandatory, mystery-critical):**
- **Thaddeus Pemberton** — Mayor, ghost, ~250 years old. Warm grandfather energy hiding old grief.
- **Bram Hartwell** — Baker, werewolf, alpha of the local pack. Big, gentle, terrible singer.
- **Sable Vance** — Bartender/innkeeper, vampire. Sardonic, romantic, secretly a poet.
- **Marisol Quinn** — Apothecary, witch. Practical, ethical, the moral compass.
- **Cassiel** — Librarian, fallen angel. Reserved, dryly funny, the only one who's met Wren as an adult.

**Supporting cast — sample (the agent can extend):**
- **Pip** — A child poltergeist who haunts the bakery. Loves pranks.
- **Juno** — Bram's daughter, also werewolf, runs the farm-supply stall. Romance option.
- **Otto** — A grumpy garden-gnome (literally — a stone gnome that animates at night). Comic relief.
- **Linnea** — A selkie who runs the bathhouse. Quiet, deep wells.
- **Ren** — A traveling tinker (NOT supernatural) who passes through monthly. Outsider perspective. Romance option.
- **The Hollow Twins** — Twin ghosts who run the music shop. Always finishing each other's sentences.

### 4.3 Relationships

Friendship hearts system, identical to Stardew in structure (0–10 hearts, gifts, dialogue, cutscenes at 2/4/6/8/10).

Six romance options at launch: **Juno, Sable, Cassiel, Bram, Ren, Linnea.**

Marriage (or supernatural-equivalent commitment ritual) unlocks at 10 hearts and after a relationship-specific quest chain.

---

## 5. Core Systems

### 5.1 Farming
- Crops divided into **mundane** (carrots, tomatoes, etc.) and **moonlit** (only grow under specific moon phases; higher value; some used in mystery quests).
- Greenhouse equivalent: a **moonhouse** that simulates a controlled moon phase.
- Animals: chickens, cows, goats, plus supernatural variants unlocked late-game (a *hearthcat* that warms the home; a *mistgoose* whose feathers craft into Veil-related items).

### 5.2 Mining / Caves
- Replaced with **the Underwood** — root-system caverns beneath the forest.
- Resources: ores (iron, silver, moonstone), gems, plus *spirit residue* (used in magic crafting).
- Mild combat with non-malevolent creatures (root constructs, wisps that pop into harmless light, etc.). Death penalty is mild (lose some items, wake up in cottage). Never grim.

### 5.3 Fishing
- Day fish, night fish, moon-phase-specific fish.
- A few **legendary fish** tied to the mystery (e.g., the *Mooneye Carp* that appears once per in-game year and rumored to grant a memory of the past).

### 5.4 Combat
- Lighter than Stardew. Single weapon slot, dodge, basic combo.
- Each supernatural path adds **one signature ability**: werewolf form, blood drain, phase, spell, herbal bomb.
- Combat is **never required** for the main story past Act 1; alternative resolutions always exist (sneak, talk, puzzle).

### 5.5 Crafting & Cooking
- Standard recipe-discovery systems. Cookbook UI, crafting UI.
- Magical crafting unlocked via Marisol's apprenticeship (any path can do it; witches just do it faster).

### 5.6 Skills
Six skill trees: **Farming, Foraging, Fishing, Mining, Combat, Hearth** (the cozy/relationship skill — improves dialogue options, gift effects, cooking).

Plus a **Path skill** unique to the chosen supernatural type, with its own tree.

### 5.7 The Mystery Board
See §2.4.

### 5.8 Festivals
One per in-game month. Some shared with Stardew templates (a fair, a dance), some unique:
- **Moonbloom Festival** (Spring, Month 1) — choice event.
- **Hollow Lanterns** (Summer) — paper lanterns released over the Hollow; relationship cutscenes happen here.
- **The Long Night** (Autumn) — town stays awake until dawn telling stories around a bonfire. Mini-game: storytelling.
- **The Veiled Market** (Winter) — outside merchants admitted through the Veil for one day; rare items.
- Plus two minor festivals (Tinker's Day, Harvest Hush).

### 5.9 Mini-Games
- **Storytelling** (turn-based picking cards to weave a tale; affects relationships)
- **Divination** (tarot-like card flip with pattern-matching; gives clue hints)
- **Spirit Communing** (rhythm-light minigame, ghost-path bonuses)
- **Brewing** (combine ingredients with timing; potions)
- **Lantern flight** (during Hollow Lanterns festival)

### 5.10 Home & Lair
The cottage upgrades through Stardew-like tiers but also gains **path-specific rooms**: a coffin chamber for vampires, a moonlight pen for werewolves, an ectoplasm parlor for ghosts, a brewing room for witches, a hearth library for humans.

### 5.11 Time & Calendar
- 10-minute = 1 in-game hour, similar to Stardew.
- Day length extends slightly post-dusk to reward evening play (vampire path extends it further).
- Four seasons, 28 days each. Calendar visible in cottage and pause menu.
- **Moon phases** matter mechanically: spawn rates, certain crops, certain dialogue.

---

## 6. Art Direction

### 6.1 Pixel Style
- **Base tile size:** 16x16 px.
- **Character sprites:** 16x32 (head taller than tile, Stardew convention).
- **Color palette:** Warmer and slightly darker than Stardew. Heavy use of:
  - Deep blues and purples for night
  - Warm orange/amber for interior light, lanterns, hearthfire
  - Misty whites and pale greens for the Veil and supernatural effects
  - A signature accent of **moonsilver** (a desaturated cool teal) used for magical UI and important highlights.
- **Lighting:** Day/night light passes with strong contrast at dusk. Lantern light is the signature mood.
- **Animations:** 6–8 frame walk cycles, idle breathing, ambient world animations (flickering candles, drifting mist, rustling leaves, distant fireflies).

### 6.2 UI
- Hand-drawn parchment feel for menus and dialogue boxes.
- Iconography is consistent: a moon icon for time, a small locket icon for mystery progress, faction sigils for each Council elder.
- Mystery board is the visual centerpiece UI element — should look like a real corkboard with twine.

### 6.3 Visual References (for art-generation prompts)
- Stardew Valley (baseline)
- Eastward (richer lighting)
- A Short Hike (cozy palette)
- Night in the Woods (autumnal, slightly off)
- Spiritfarer (warm, mystical)

---

## 7. Audio Direction

### 7.1 Music
- **Instrumentation:** Acoustic guitar, soft piano, gentle strings, flute, hand drums, glass harmonica or music box for magical moments. Add a *singing saw* as the signature "Moonhaven" instrument — uncanny but warm.
- **Themes per area:**
  - **Town theme** — warm acoustic with a slow heartbeat percussion
  - **Whispering Wood** — flute and ambient pads, fireflies of melody
  - **The Underwood** — slow piano, low strings
  - **The Hollow** — choral pad, sparse music box
  - **Cottage** — solo guitar, intimate
  - **Festivals** — fiddle-led, livelier
- **Adaptive layers:** music adds instruments at higher friendship hearts in the area, or as a quest progresses (subtle, not gimmicky).
- **Reference for AI music prompts:** "cozy acoustic folk, gentle, slight melancholy, instrumental, music box accents, soft fingerpicked guitar, like Stardew Valley meets Night in the Woods, no vocals, looping, 90 BPM."

### 7.2 SFX
- Footsteps per surface (wood, stone, grass, water, leaves)
- Tool sounds (hoe, watering can, axe, pickaxe, fishing rod)
- UI clicks: soft wood/paper sounds, not synthetic
- Ambient: distant owl, wind, occasional creak, faint chimes in town
- Path-specific: werewolf transformation cue, vampire charm shimmer, ghost phase whoosh, witch spellcast crackle

### 7.3 Voice
- No full voice acting. Use Animal-Crossing-style **chirps/grunts per character** to suggest voice without committing to VO. Each character has a 2–3 sample chirp set keyed to their personality (Bram's is low and warm; Pip's is high and giggly; Sable's is breathy and slow).

---

## 8. UX & Controls

### 8.1 Controls
- **Keyboard + mouse** and **full controller support** from day one.
- **Single primary action button.** Context-sensitive: talk, harvest, hit, pick up.
- **Tool wheel** on hold (controller) or scroll (keyboard).
- **Map** on `M`, **mystery board** on `J` (journal), **inventory** on `Tab`, **menu** on `Esc`.

### 8.2 Onboarding
- No long tutorial. NPC-driven gentle nudges in Act 1.
- A small **"What now?"** button in the journal that always points to a reasonable next thing — main quest, an unmet villager, or a seasonal opportunity. Players who hate this can disable it.

### 8.3 Accessibility
- Adjustable text size and dialogue speed
- Colorblind-safe palette toggles
- Optional dyslexia-friendly font
- Combat difficulty options (including "no fail")
- Time-pause-on-menu toggle
- Photosensitivity option for transformation effects

---

## 9. Progression & Rewards

### 9.1 What progress feels like, hour by hour
- Hours 0–2: cottage, first crop, first friendship, first clue.
- Hours 2–10: full town introduced, first festival, the Choice, supernatural ability online.
- Hours 10–30: mystery deepens, deeper relationships, home upgrades, skill specializations.
- Hours 30–50: endgame arc, climax, ending.
- Hours 50+: post-game freeform.

### 9.2 Reward types
- **Items** (always specific, never "+1 stat")
- **Recipes & blueprints**
- **Dialogue unlocks** (new NPC conversations, lore drops)
- **Map unlocks** (new areas)
- **Cosmetic** (outfits, cottage décor)
- **Story milestones** (cutscenes, mystery board connections)

### 9.3 Post-game
- Veil is stable; town celebrates with a one-time festival.
- New side quests appear ("Slice of Life" arcs for each villager).
- Seasonal content continues forever.
- **NG+** option: keep relationships and home, replay with a different supernatural path.

---

## 10. Scope & Phasing (Implementation Plan)

The agent should implement in these phases. Each phase ends with a playable build.

### Phase 0 — Project Setup
- Godot 4 project initialized
- Folder structure (`/scenes`, `/scripts`, `/art`, `/audio`, `/data`, `/docs`)
- Git repo, `.gitignore`, README
- Style guide for code

### Phase 1 — Core Loop (the "vertical slice")
- Player controller, basic movement
- One tileset (cottage interior, cottage exterior, town center)
- Three NPCs (Thaddeus, Bram, Marisol) with placeholder dialogue
- Farming on one tile type
- Day/night cycle and time system
- Save/load
- **Goal:** Player can wake up, walk around, talk to three people, plant a crop, sleep.

### Phase 2 — Town & Talking
- Full town map (all locations as walkable shells)
- All 18 villagers placed with schedules
- Dialogue system robust (branching, conditions, flags)
- Friendship hearts system
- Mystery board UI
- Act 1 main quest

### Phase 3 — Systems Breadth
- Foraging, fishing, mining, combat
- Crafting and cooking
- Skill trees
- First two festivals (Moonbloom, Hollow Lanterns)
- The Choice event (Moonbloom climax)
- All five supernatural paths' starting abilities

### Phase 4 — Mystery & Acts 2–3
- Act 2 and Act 3 main quest content
- Mystery board fully populated
- All Council elder heart events
- Additional festivals
- Underwood and Whispering Wood deep zones

### Phase 5 — Endgame
- Acts 4–5
- Path-specific endings
- Post-game state
- NG+

### Phase 6 — Polish
- Audio pass (replace all placeholders with finals)
- Art consistency pass
- Performance optimization
- Accessibility pass

---

## 11. Data-First Architecture (Notes for the Agent)

Wherever possible, content is **data, not code**:

- `data/npcs/*.json` — one file per NPC with name, schedule, gift preferences, heart events.
- `data/dialogue/*.yaml` — branching dialogue trees per NPC and per condition.
- `data/quests/*.yaml` — quest definitions: trigger, steps, rewards, flags set.
- `data/clues/*.yaml` — mystery board entries and valid connections.
- `data/items/*.json` — items, including recipes and crafting outputs.
- `data/crops/*.json` — crop definitions.
- `data/festivals/*.yaml` — festival schedules and scripts.

This means a writer (human or AI) can extend the game by editing data files; only mechanic changes touch GDScript.

The dialogue system must support:
- Conditional branches (`if flag X` / `if hearts ≥ Y` / `if path == werewolf`)
- One-off cutscene triggers
- Inline item-give / flag-set / clue-unlock effects

---

## 12. Naming Rule (Important)

The game name "Moonhaven" is provisional and may be renamed before any public release. To keep the rename trivial:

- The game name lives in exactly ONE constant: `Constants.GAME_TITLE` in `scripts/autoload/constants.gd`.
- All UI that displays the name reads from this constant.
- Class names, file names, variable names, and signal names are GENERIC — `GameState`, not `MoonhavenGameState`.
- Asset file names are generic — `title_theme.ogg`, not `moonhaven_theme.ogg`.
- The town inside the game is also called "Moonhaven" by default but reads from the same constant where possible.

Treat this rule as inviolable. Future renaming should require touching only the constant, the docs, and the title logo art.

---

## 13. What "Done" Looks Like

A first viable release ships with:
- ~40 hours main-story content
- 18 villagers, 6 romance options
- 6 festivals
- All 5 supernatural paths with full endings
- All core systems above

A rough comparison: smaller in scope than Stardew Valley v1.0 but with a stronger main story. Treat that as a feature, not a shortcoming.

---

## 14. Tone Reference Lines

When in doubt about a piece of dialogue or flavor text, match these:

- **Bram (werewolf baker), full moon:** "I'd invite you for a run tonight but I can never remember the route in the morning. The bread, though — the bread I remember."
- **Sable (vampire bartender), on aging:** "Two hundred years and I still can't pronounce 'charcuterie.' Don't tell anyone."
- **Thaddeus (ghost mayor), on Wren:** "She had a way of making a room feel… kept. Like the room had been waiting for her. I haven't felt a room kept in a long time."
- **Pip (poltergeist child), unprompted:** "I put a frog in the flour barrel. Don't tell Bram. ACTUALLY tell Bram, it's funnier if he knows."
- **Marisol (witch), offering the Choice:** "I'm not asking you to decide who you are. I'm asking what shape you want the world to meet you in. You can change it later. Most of us have."

If a generated line wouldn't fit on a postcard next to one of those, rewrite it.

---

*End of design document. Agents should treat this as canonical and request clarification rather than improvising on contradictions.*
