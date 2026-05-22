# Moonhaven — Start Here

This is your jumping-off point. Read this top to bottom once, then keep it open as you work. It will walk you through getting from zero to "agent is writing my game code in Cursor" in about an hour, then explain the rhythm of work after that.

---

## What You're Building

**Welcome to Moonhaven** — a cozy supernatural life-sim with a mystery-driven main story. Think Stardew Valley with werewolves, vampires, ghosts, and witches instead of regular townsfolk, plus a captivating multi-act mystery that pulls the player in from the opening minutes. The player can choose to become one of the supernatural beings themselves, and that choice meaningfully shapes the story.

**You are the orchestrator.** AI agents will write the code, generate the art, and produce the music. You set the direction, make the taste calls, and verify each step before letting the agent continue.

**Engine:** Godot 4.3+
**Primary AI tool:** Cursor (which you have)
**Art/audio track:** runs in parallel once you have the code track moving

---

## The Four Documents

You should have all four of these. Save them all together — they reference each other.

| Document | Purpose |
|---|---|
| **`start-here.md`** | This file. The walkthrough. |
| **`master-gdd.md`** | The canonical game design. What the game is. |
| **`phase-1-tasks.md`** | The code task ledger (T-00 through T-20). What the agent does. |
| **`art-pipeline.md`** | The art and audio task ledger (A-00 through A-20). What you do alongside the agent. |

---

## Tools to Install (One-Time, ~30 minutes)

Skip the art-track tools for now. You won't need them until later.

### Required Right Now:

1. **Godot 4.3+** — Download the Standard version (not .NET) from https://godotengine.org/download
   - Install. Open it once to make sure it runs. Close it.

2. **Git** — Already installed on Mac and most Linux. On Windows, download from https://git-scm.com/download/win
   - Verify: open a terminal and run `git --version`. Should print a version number.

3. **Cursor** — You have it. Make sure it's updated to a recent version.

### Skip For Now (you'll install these when you start the art track, A-00 onward):

- Aseprite ($20, but you don't need it for ~2 weeks)
- Retro Diffusion paid plan
- PixelLab.ai paid plan
- AIVA Pro
- ElevenLabs Creator
- Freesound.org account (free, but not needed yet)

The whole art stack is Phase 1 mid-to-late. Don't pay for any of it until you have placeholder mechanics working.

---

## Step-by-Step From Zero

### Step 1: Create the Project Folder

Pick a place on your drive. Open a terminal there. Run:

```bash
mkdir moonhaven
cd moonhaven
git init
```

That's your project root. Everything lives inside `moonhaven/`.

### Step 2: Place the Documents

Inside the `moonhaven` folder, create this structure manually (or let the agent do it in T-00 — your call; doing it now is easier):

```
moonhaven/
└── docs/
    ├── start-here.md       ← this file
    ├── design/
    │   └── master-gdd.md
    └── implementation/
        ├── phase-1-tasks.md
        └── art-pipeline.md
```

Drop each document in its location.

### Step 3: Open the Project in Cursor

Launch Cursor. Choose "Open Folder." Point it at the `moonhaven/` folder.

Cursor will scan the folder and have your four documents available as context.

### Step 4: The First Agent Prompt

Open Cursor's chat (or composer/agent mode if you prefer — agent mode is recommended for this kind of multi-step task). Paste this exactly:

> Read `docs/design/master-gdd.md` and `docs/implementation/phase-1-tasks.md` in full. Confirm you understand the project, then execute T-00 only. Stop after T-00's acceptance criteria are met so I can verify in Godot. When you finish, commit with the message `T-00: project skeleton`. Do not start T-01 — wait for my confirmation.

Hit send.

The agent will read the docs, then create the folder structure, the `project.godot` file, the `.gitignore`, the README, and the empty `ASSETS.md`. It should not write any game code yet — T-00 is pure scaffolding.

### Step 5: Verify T-00

Once the agent says it's done:

1. Open Godot.
2. Click "Import" and point it at your `moonhaven/project.godot` file.
3. The project should open without errors. You'll see an empty scene tree, but the folder structure from T-00 should be visible in the file system panel (left side).
4. Check that your folder structure matches the spec in T-00.
5. Open the README in the project root. It should have a title, pitch, and "How to Run" section.

If anything is missing or wrong: tell the agent specifically what's missing and ask for a fix. Then re-verify.

If everything looks good: proceed to Step 6.

### Step 6: Continue Through Phase 1

For each remaining task (T-01, T-02, ... T-20), send the agent a prompt like:

> Execute T-01 only. Stop after acceptance criteria are met. Commit as `T-01: time singleton`.

Then verify by running the game (F5 in Godot) and checking the acceptance criteria for that task.

Some tasks will need you to look at things in-game. Some are pure plumbing where you just need to make sure the project still runs and nothing's broken.

**Hard rule:** verify before moving on. The agent will be tempted to chain tasks. You will be tempted to let it. Don't. Catching a wrong turn at T-04 is a 5-minute fix; catching it at T-15 is a 3-hour mess.

---

## The Rhythm of Work

Once you're past T-00, this is what a session looks like:

1. **Open Cursor.** Pull up the chat. Look at where you left off in the task ledger.
2. **Prompt the agent:** "Execute T-XX only. Stop and commit when acceptance criteria are met."
3. **Wait.** Most tasks take the agent 5–20 minutes. Don't watch the entire thing. Check email, get coffee.
4. **Verify.** Open Godot, run the game (F5), confirm the acceptance criteria. Read the diff if you want.
5. **Either:**
   - **It worked:** prompt the next task. Or, if you're tired, stop here. Git is your save point.
   - **It didn't work:** tell the agent specifically what's wrong. "When I press E on the bed, nothing happens, but the prompt appears." Let it fix.
6. **Commit if the agent forgot.** `git commit -am "T-XX: <thing>"`.

That's the loop. Repeat 21 times. You're at the vertical slice.

---

## When to Start the Art Track

Don't start the art-pipeline tasks (A-00 onward) until you've completed at least **T-08** (day/night cycle visible in-game). That gets you to a point where you can see the game running with placeholders and decide whether the *feel* is right.

Once you start, the art track runs in parallel: you work on art tasks between Cursor sessions, or while Cursor is grinding on a longer code task.

The first art task — **A-00, Palette Lock** — is the single most important art decision in the whole project. Do not skip it. Do not rush it. Everything downstream inherits from it.

---

## Rules to Keep the "Moonhaven" Rename Cheap

You and I agreed to use "Moonhaven" as the working name even though it might need to change later. To make that rename a 30-minute job and not a nightmare:

- **In code:** the name lives in *one* place — `scripts/autoload/constants.gd` with `const GAME_TITLE = "Moonhaven"`. Everything that displays the name reads from `Constants.GAME_TITLE`. Tell the agent this rule explicitly if it forgets.
- **Class names and variables stay generic.** `GameState`, not `MoonhavenGameState`. `SceneManager`, not `MoonhavenSceneManager`. This is good practice anyway.
- **Asset file names are generic.** `title_theme.ogg`, not `moonhaven_theme.ogg`.
- **Hold off on the title logo art** (A-12) until you're sure of the name. Use the title in your display font as a placeholder.
- **Don't make any public commitments to the name.** No domain registration, no social media, no Steam page, no posting screenshots online with the name visible. As long as it's all in your local repo, the rename is free.

If you follow those rules, renaming later is: find/replace in the docs, one line in `constants.gd`, regenerate the logo art. ~30 minutes.

---

## What to Do When You Get Stuck

**The agent is making the wrong decisions.** Re-read the relevant section of the GDD. The agent may be missing context. Quote the relevant passage to the agent: "Per master-gdd.md §5.4, combat is never required for the main story past Act 1. Revise."

**The agent is spiraling on a bug.** If it's tried 2+ times to fix the same issue without success, stop the agent. Read the error yourself. If you can't fix it, ask Claude (me) directly — paste the error and the relevant code. Don't let an agent burn 30 minutes flailing.

**You don't know what "good" looks like.** Refer back to GDD §13 (tone reference) and the visual references in A-01. When in doubt, the GDD wins.

**You lost momentum.** Open Godot, run the game, walk around in what you've built so far. Reconnect with the project. Then do one small task. Don't try to do four tasks to "catch up."

**You want to change the design.** Update the GDD first. Then implement. Don't have the agent build something the GDD says doesn't exist; you'll forget what's authoritative.

---

## What's Next After Phase 1

Once T-20 is complete and you have a vertical slice that feels right, you write `phase-2-tasks.md` covering:

- The remaining 15 villagers
- Full town map expansion
- Robust dialogue with heart events
- The Mystery Board UI fully wired up
- Act 1 main quest end-to-end
- Two more festivals

I'll help you write that ledger when you get there. Don't worry about it now.

---

## Your Immediate Next Steps (In Order)

1. [ ] Install Godot 4.3+
2. [ ] Verify Git is installed
3. [ ] Make a `moonhaven/` folder
4. [ ] `git init` inside it
5. [ ] Drop the four documents in the `docs/` structure shown above
6. [ ] Open the folder in Cursor
7. [ ] Send the first agent prompt (Step 4 above)
8. [ ] Verify T-00 in Godot
9. [ ] Send the T-01 prompt
10. [ ] Repeat through T-20

That's it. The game gets built one task at a time. You're the conductor; the agents are the orchestra; the documents are the score.

Go.
