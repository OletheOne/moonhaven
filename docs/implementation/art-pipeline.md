# Phase 1 — Art & Audio Pipeline (Parallel Track)

**Game:** Welcome to Moonhaven

This document runs **alongside** `phase-1-tasks.md`. While Cursor works through T-00 → T-20 on code, you (Brandon) work through A-00 → A-20 generating real assets. By the time the code lands at T-20, the assets are ready to swap in.

**You drive this track personally.** Image and music generation needs a curator with taste calls — that's you. The agent's role here is limited to:
- Organizing generated files into the right folders
- Updating `ASSETS.md` with provenance
- Naming and slicing sprite sheets
- Importing audio into Godot with the right settings

**Naming rule:** Asset file names are GENERIC. Use `town_theme.ogg`, `player_sheet.png`, `dialogue_box.png` — never include "moonhaven" in any file or folder name. The only place the name "Moonhaven" appears in art is on the title logo itself (A-12), and even that can be rendered on the fly from `Constants.GAME_TITLE` for now to avoid baking the name into a permanent asset.

**Default tool stack:**
- **Pixel art (environments, tiles):** Retro Diffusion (Pro plan)
- **Character sprites + animation:** PixelLab.ai (paid tier)
- **Cleanup / consistency:** Aseprite
- **Music:** AIVA (Pro tier) primary; Suno (Pro) as fallback for specific cozy-folk tracks
- **SFX:** ElevenLabs (Creator tier) primary; Freesound.org CC0 backup
- **Font:** Google Fonts (Open Font License — always commercial-safe)

**Asset specifications (locked):**
- Base tile: **16x16 px**
- Character sprite: **16x32 px** (sheet at 4 directions × 4 frames = 64x128 per character)
- Portrait: **64x64 px** (for dialogue box)
- UI elements: **9-slice friendly**, multiples of 8px
- Music: **OGG Vorbis, looping, ~90s loops**
- SFX: **WAV, 44.1kHz, mono unless stereo is needed**

**Workflow rule:** generate 4–6 variants of every asset. Pick the best. Don't ship the first thing the model gives you. Budget ~30–60 minutes per visual asset including curation and cleanup.

**When to start this track:** wait until at least T-08 is complete on the code side. That way you're seeing the game run with placeholders before committing to a visual style.

---

## A-00 — Palette Lock

**This is the most important task in this document.** Everything else inherits from it.

Generate a 32-color master palette for the entire game. The palette must include:
- 4 grass/foliage greens (light to dark)
- 4 wood browns (light to dark)
- 4 stone grays (light to dark)
- 4 sky/atmosphere blues (dawn, day, dusk, night)
- 4 warm accent colors (lantern orange, fire red, hearth amber, candle yellow)
- 4 cool magical colors (moonsilver teal, ghost pale, vampire crimson, witch purple)
- 2 skin tones (variation)
- 2 neutral UI (parchment cream, ink dark)
- 4 reserved slots for spot uses

**Method:**
1. Open Retro Diffusion or a palette tool like Lospec.
2. Search Lospec for inspiration: filter by mood (cozy, autumnal, twilight). Reference palettes worth studying: "Endesga 32", "Resurrect 64", "Slso8".
3. Generate or hand-pick 32 colors. Aseprite has a built-in palette editor — finalize there.
4. Save as `art/palettes/master.gpl` (Aseprite/GIMP palette format) and `art/palettes/master.png` (visual reference strip).

**Acceptance:** Palette file exists. Visual strip is readable. Every color has a name written next to it in a companion `palette-key.md`.

**Critical rule from here on:** every art asset for the game uses ONLY these colors. No exceptions. This is what gives Stardew its visual coherence and it's what AI-generated art usually lacks. Aseprite has an "Index Mode" that snaps any imported image to your palette — use it.

---

## A-01 — Style Bible

Create `art/style-bible.md`. Document the visual rules every asset must follow:

- The locked palette (reference)
- Outline rule: black or dark-color outlines on characters, no outlines on tiles
- Shading rule: 2–3 tone shading (base + shadow + optional highlight); no anti-aliasing
- Perspective: 3/4 top-down (player sees front-three-quarters of buildings and characters)
- Light direction: top-left consistent
- Animation principle: lots of small idle motions (breathing, blinking, ambient sway)
- Mood: cozy first, spooky-warm second; no horror imagery; no realistic gore

Also paste 6–10 visual reference screenshots from the games listed in GDD §6.3 (Stardew, Eastward, A Short Hike, Night in the Woods, Spiritfarer). Save in `art/references/`.

**Acceptance:** Anyone (or any agent) reading this doc + the palette can produce on-style assets. The references folder is populated.

---

## A-02 — Font Selection

Pick two fonts:
- **Display font:** for titles, NPC names, headings. Should feel hand-lettered or storybook. Candidates: "Press Start 2P", "Pixelify Sans", "VT323", "DotGothic16".
- **Body font:** for dialogue and UI text. Must be highly readable at small sizes. Candidates: "m5x7" (free), "Pixelify Sans", "Determination Mono".

Download from Google Fonts or Lospec (both have OFL-licensed pixel fonts). Place in `art/fonts/`. Add a `font-license.md` with the SIL OFL license text.

**Acceptance:** Two fonts in the project, license file alongside, sample rendering screenshot in `art/references/font-samples.png`.

---

## A-03 — Cottage Interior Tileset

Generate the cottage interior tileset. Required tiles:
- Wood floor (3 variants for variety)
- Wood wall (3 variants, with one window variant)
- Wall-floor transition (8 tiles for full corner/edge coverage)
- Door (closed, open frame)
- Bed (covers 2x2 tiles)
- Hearth/fireplace (covers 2x3 tiles, with fire animation — 4 frames)
- Chest (closed, with frame variants)
- Rug (3x2 tiles)
- Window with view (animated curtain optional)
- Small décor: hanging herbs, picture frame, candle (with flame animation — 4 frames)

**Workflow:**
1. In Retro Diffusion, prompt: `top-down pixel art cottage interior tileset, 16x16 tiles, wooden floor and wall tiles, cozy witch's cottage, [palette name] colors, Stardew Valley style, no characters`
2. Generate 6 variants. Pick the closest match.
3. In Aseprite: snap to master palette (Sprite > Color Mode > Indexed, use master palette). Hand-clean inconsistencies.
4. Slice into a proper 16x16 tilesheet. Save as `art/sprites/tiles/cottage_interior.png`.
5. Add hearth fire frames and candle flame frames as separate small sheets.

**Cursor task after generation:** ask the code agent to update `cottage_interior.tscn` to use the new tilesheet, replacing the placeholder colored blocks. The tileset import settings should disable filtering and enable pixel snap.

**Acceptance:** Cottage interior in-game looks recognizably cozy. Hearth fire animates. Candles flicker. Palette is consistent. Compare side-by-side with reference screenshots — does it feel like the same artistic world?

**Log in ASSETS.md:** tool, prompt, date, license tier.

---

## A-04 — Cottage Exterior Tileset

Required tiles:
- Grass (4 variants — plain, with flowers, with mushrooms, with stones)
- Dirt path (with edge tiles for full transition to grass)
- Cottage building exterior (modular — wall, roof, chimney, door, windows; should tile so larger or smaller cottages can be built from the same parts)
- Farm plot tiles — all six states from T-15: `untilled`, `tilled_dry`, `tilled_wet`, `planted_dry`, `planted_wet`, `grown` (the `grown` tile should look like a small carrot; we'll add other crops later)
- Tree (multiple sizes: small sapling, medium, large; each with subtle sway animation 2-3 frames)
- Fence (corner and edge pieces)
- Stone (small pile, large boulder)
- Foliage (bushes, flowers — variants in palette colors)

**Workflow:** same as A-03. Tilesheet at `art/sprites/tiles/cottage_exterior.png`.

**Acceptance:** Cottage exterior in-game has visible grass variety, the building reads as a cottage, the farm plot has clear visual feedback for each state. Trees and foliage have ambient motion.

---

## A-05 — Town Center Tileset

Required tiles:
- Cobblestone (3 variants, with edge tiles)
- Lamppost (with glowing light animation — 2 frames, ON only at night)
- Fountain (3x3 tiles, water animation — 4 frames)
- Three building exteriors, each visually distinct:
  - **Pemberton Hall** (Thaddeus) — taller, slightly Victorian, gray-blue with a ghostly mist around the base
  - **Hearthfire Bakery** (Bram) — warm orange tones, smoke from chimney (animated), bread sign hanging
  - **Apothecary** (Marisol) — green-purple, herbs hanging in windows, mortar-and-pestle sign
- Town fence/border decoration
- Gazebo for festivals (placeholder for now — small 3x3 structure)

**Workflow:** same as A-03, but generate each building separately for higher quality. Combine into one sheet.

**Acceptance:** Town reads as three distinct buildings around a fountain. Lampposts work day/night. Fountain water animates. Smoke from bakery animates.

---

## A-06 — Player Sprite + Animations

Use **PixelLab.ai** for this one — it's purpose-built for character sprite animation and saves enormous time vs. hand-animating.

Specs:
- 16x32 px per frame
- 4 directions (down, up, left, right)
- 4 animations: idle, walk, till (one-shot), water (one-shot)
- 4 frames per animation per direction
- Total sheet: 16 frames × 16 wide × 32 tall = 256x128 px

**Workflow:**
1. PixelLab: describe character — "traveler, hooded cloak, leather satchel, plain face, gentle expression, neutral gender, [palette colors]". Generate base.
2. Use PixelLab's animation feature to produce walk cycles for each direction.
3. Generate tool-use animations separately (till motion, water pour).
4. Export individual frames. Bring into Aseprite. Snap to master palette. Touch up inconsistencies.
5. Save as `art/sprites/player/player_sheet.png` with companion `player_sheet.json` describing frame coordinates.

**Cursor task:** update player AnimationPlayer to use the real sheet. Slice frames correctly.

**Acceptance:** Walk cycle reads smoothly. Idle has a subtle breathing motion. Till and water animations sell the action. Character feels cohesive across all directions.

---

## A-07 — Thaddeus (Ghost Mayor)

Two assets needed: world sprite (16x32, same spec as player) and portrait (64x64, for dialogue).

Character notes for prompts:
- Ghost — translucent appearance, slight glow
- Older man, ~60s appearance (frozen at death age)
- Victorian-era waistcoat, pocket watch chain, neatly trimmed mustache
- Warm grandfather energy hiding old grief
- Color: pale blue-white with warm undertones

**Workflow for sprite:** PixelLab with the description above. Idle only (he doesn't walk in Phase 1 — wave/sway animation is enough).

**Workflow for portrait:** Retro Diffusion or PixelLab portrait mode. Prompt: "pixel art portrait, 64x64, ghost gentleman, Victorian, warm sad eyes, pale blue translucent, [palette colors], soft shading, 3/4 view." Generate 6, pick the best, Aseprite cleanup. Portrait should have 2 expressions for Phase 1 (neutral, smiling).

**Acceptance:** Sprite is recognizably Thaddeus and matches the GDD's description. Portrait shows in dialogue box and reads as the same character. Translucency conveyed.

---

## A-08 — Bram (Werewolf Baker)

Same spec as A-07. Character notes:
- Werewolf — in human form for Phase 1
- Large, broad-shouldered, mid-40s
- Floury apron, flannel shirt sleeves rolled up
- Big gentle face, kind eyes, slightly mussed hair
- Warm browns and oranges in clothing

Two portrait expressions: friendly, laughing.

**Acceptance:** Reads as a baker who could also be a wolf. Warm color palette. Matches GDD tone.

---

## A-09 — Marisol (Witch Apothecary)

Same spec as A-07. Character notes:
- Witch — human-passing, no overt magical markers
- Mid-30s, practical brown braid, herb-stained apron over plain dress
- Carries a small leather notebook
- Cool greens and earthy tones
- Steady, observant expression

Two portrait expressions: thoughtful, warm.

**Acceptance:** Reads as a practical herbalist. Matches GDD tone — she's the moral compass, so don't make her look mischievous.

---

## A-10 — Dialogue Box & Portrait Frame

Hand-design in Aseprite (or generate then heavily clean up — UI is where AI gen tends to fail).

Components:
- Dialogue box: 9-slice frame, ~640x144 px, parchment color with hand-drawn border in ink-dark
- Portrait frame: 80x80 px inset on the left of the dialogue box (holds 64x64 portrait with 8px border)
- Name plate: small banner above the portrait
- Choice list: each choice in its own small parchment strip, ~400x32 px, highlight on hover/select
- Continue indicator: small animated triangle (4 frames) in the bottom-right

Save individual elements at `art/ui/dialogue/`.

**Cursor task:** update the dialogue UI scene from T-12 to use the real UI assets.

**Acceptance:** Dialogue box looks hand-made, not generic-AI. Portrait sits nicely. Choices are visually distinct from narration. The continue indicator animates.

---

## A-11 — Hotbar, Inventory, & HUD

Components:
- Hotbar slot: 40x40 px, 9-slice frame, parchment with subtle wood grain
- Selected slot highlight: glow or thicker border
- Inventory backpack icon (opens full inventory in Phase 2)
- Time/day indicator: small clock face + day text, top-right of screen, ~140x60 px
- Health/stamina (Phase 2, skip for now)
- Interact prompt: floating speech-bubble-ish container with key icon + verb text

**Acceptance:** HUD elements are unobtrusive but readable at 1080p. Time indicator updates with `TimeManager`. Hotbar selection feedback is immediate.

---

## A-12 — Menu Screens

- **Title screen:** game logo + buttons styled as parchment strips, background art of the cottage at dusk with lit windows.
- **Pause menu:** semi-transparent overlay, smaller version of the parchment-strip buttons.

**Critical:** Hold off on rendering the game name as permanent baked-into-pixel-art logo art until you're sure of the final name. For now, use the title rendered live in the display font (A-02) over a decorative background. This means the title screen background art (the cottage at dusk) is permanent, but the title text itself is rendered dynamically from `Constants.GAME_TITLE`. If/when the name is finalized, you can generate the permanent baked logo art then.

**Acceptance:** Title screen reads "this is the cozy supernatural mystery game I wanted to play." Pause menu is functional and on-style. Title text reads from the constant, not hard-coded.

---

## A-13 — Item Icons

Phase 1 items: hoe, watering can, carrot seed, carrot, locket (the key item from T-19).

Each: 32x32 px on transparent background. Match world sprite style but slightly more iconic/readable.

The **locket** is plot-critical — give it special attention. It should feel like an heirloom. Multiple iterations are warranted.

**Acceptance:** Item icons read clearly in the hotbar at small size. Locket feels significant.

---

## A-14 — Title Music

**Tool:** AIVA primary. Suno Pro fallback if AIVA's cozy-folk capability disappoints.

Prompt (AIVA, "From a Style" mode, custom style):
- Style: Cinematic / Folk / Cozy
- Mood: Mysterious, warm, hopeful with a touch of melancholy
- Instrumentation: solo acoustic guitar fingerpicked, light music box accent, distant strings entering at 0:30, soft singing saw at 0:45
- Tempo: 75 BPM
- Length: 90 seconds, designed to loop

Generate 10 variants. Listen to all. Pick top 2. Refine if needed. Export the chosen one as OGG Vorbis (or WAV → convert in Audacity), normalized to -14 LUFS.

Save as `audio/music/title_theme.ogg`. Log in ASSETS.md (tool, prompt, plan tier, date).

**Acceptance:** Track loops cleanly (test the loop point in Audacity — no audible seam). It sets the tone for the whole game. Test it: play the title screen for 3 minutes — does the music wear out? If yes, re-iterate.

---

## A-15 — Town Theme

Same workflow. Different feel:
- Warm acoustic guitar lead, slightly livelier than title
- Light percussion (hand drum, soft heartbeat at ~80 BPM)
- Light flute embellishment in the second half of the loop
- Faint distant bell every 32 bars (the town has church bells in lore)
- 120 second loop

Save as `audio/music/town_theme.ogg`.

**Acceptance:** Stays pleasant on a 30-minute loop. Doesn't compete with dialogue (no busy melodies in the foreground). Feels like the town in the GDD.

---

## A-16 — Cottage Ambience

Quieter than the town theme — solo guitar, very sparse, lots of room. Could even be 60% silence with occasional musical phrases. Optional: layer in fireplace crackle as part of the ambience.

Save as `audio/music/cottage_theme.ogg`.

**Acceptance:** Player can stay in the cottage for 10 minutes without feeling pressured by music. Conveys "home."

---

## A-17 — SFX Pack

Use ElevenLabs Sound Effects. Each prompt produces 3 variants — pick best.

| File | Prompt | Length |
|---|---|---|
| `footstep_grass_01-04.wav` | "Single footstep on soft grass, pixel game style, gentle" | ~0.3s each, 4 variants for variety |
| `footstep_wood_01-04.wav` | "Single footstep on wooden floor, cozy interior" | ~0.3s each, 4 variants |
| `door_open.wav` | "Old wooden door opening, soft creak, no slam" | ~1s |
| `door_close.wav` | "Wooden door closing softly" | ~0.5s |
| `hoe_dirt.wav` | "Hoe striking soft earth, dull thud, light dirt rustle" | ~0.5s |
| `water_pour.wav` | "Water pouring from a small can onto soil" | ~1s |
| `ui_click.wav` | "Soft wooden click, menu confirmation, cozy" | ~0.15s |
| `ui_hover.wav` | "Very soft paper rustle for menu hover" | ~0.1s |
| `dialogue_tick.wav` | "Tiny soft tick like a typewriter key, low volume" | ~0.05s |
| `day_transition.wav` | "Soft chime, music box note, day ending" | ~2s |
| `harvest.wav` | "Light plant pluck with soft pop, satisfying" | ~0.3s |
| `interact_chime.wav` | "Very brief warm chime, indicates interaction possible" | ~0.2s |

Normalize all to -18 LUFS in Audacity. Save in `audio/sfx/`.

**Acceptance:** Test each SFX in-game in context. Volumes are balanced. Nothing is jarring.

---

## A-18 — Character Chirps (Animal Crossing Style)

For each NPC and the player, generate a short 0.3s "voice chirp" set. ElevenLabs SFX can produce these, or use jsfxr/Chiptone for retro feel.

Each character needs 3 chirps with slight pitch variation. They play once per dialogue line opening (not per character — too noisy).

- **Player:** soft neutral chirp
- **Thaddeus:** low, slow, breathy chirp (he's a ghost)
- **Bram:** low warm chirp (big guy)
- **Marisol:** medium clear chirp (steady)
- **Narrator:** no chirp (silent)

Save as `audio/sfx/voices/<character>_01-03.wav`.

**Acceptance:** Each NPC sounds distinct when their dialogue starts. Volume is low enough not to be annoying.

---

## A-19 — Integration & Consistency Pass

By now you should have everything. Now you swap it all into the game.

Ask the code agent (Cursor) to do this in one focused session:
> Read `art-pipeline.md`. Replace every placeholder asset listed there with the corresponding final asset from `art/` and `audio/`. Update import settings: textures use Nearest filtering and pixel snap; audio is OGG with appropriate compression. After integration, run the game and verify all assets load correctly. Report any missing assets back to me before claiming done.

Then YOU play through Day 1 to 3 with full assets in place. Take screenshots. Compare to your visual references from A-01.

Look for:
- Palette inconsistencies (something used a color outside the master palette)
- Resolution mismatches (an asset is at the wrong scale)
- Audio mixing problems (one SFX way too loud)
- Style drift (one NPC looks like it's from a different game)

Make a `polish-list.md` of every issue found.

**Acceptance:** The game looks and sounds like the GDD describes. Not perfect — that's Phase 6. But cohesive and recognizable.

---

## A-20 — Polish Pass

Work through `polish-list.md`. Fix each item. Re-generate any asset that's pulling down the average quality. Re-mix audio if levels are off.

Tag the result as `vertical-slice-polished`.

**Acceptance:** A friend you show this to says "oh, this looks like a real game." That's the bar.

---

## Operating Notes for the Art Track

- **Curation is the work.** Generating is fast; choosing well is slow. Budget more time for picking than for prompting.
- **Aseprite is not optional.** AI-generated pixel art is consistently *almost* right. The last 15% of cleanup happens in Aseprite. Plan for it.
- **One style bible to rule them all.** When in doubt, re-read A-01 and check against the references. Every time you start a new asset, look at the bible first.
- **Generate in batches by category.** Do all the tilesets in one session, all the portraits in another. Style consistency suffers when you context-switch.
- **Document everything in ASSETS.md.** Tool, plan tier, date, prompt, license. If you ever decide to go commercial later, this paper trail is the difference between a 1-day Steam submission and a 3-month legal headache.
- **Suno vs AIVA decision tree:** Try AIVA first for any track. If after 10 generations nothing has the feel you want, switch to Suno Pro. Suno has more vibe but less control; AIVA has more control but can feel sterile. Cozy folk is usually Suno's win; ambient/sparse is AIVA's win.
- **Save raw outputs.** Don't just keep the final pick. Keep the runner-ups in `art/_archive/` and `audio/_archive/`. You might want them later, or in a different context.
- **If a task is dragging past 2 hours of curation, ship the 80% version and move on.** You can revisit in Phase 6. Perfectionism in Phase 1 is how projects die.

---

## What This Track Does NOT Cover

Saved for later phases:
- The 15 additional NPCs (Phase 2)
- The Whispering Wood and Underwood tilesets (Phase 2/3)
- Festival assets (Phase 3)
- Supernatural transformation effects (Phase 3)
- Combat VFX (Phase 3)
- Cutscene assets (Phase 4)
- Ending sequence art (Phase 5)

Phase 1's art job is to make the vertical slice feel like the game. Not to make the whole game's art.
