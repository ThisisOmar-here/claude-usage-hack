<div align="center">

# 🕐 claude-usage-hack

### Start your Claude Pro/Max 5-hour usage window at a time *you* pick — not whenever you happened to open the app.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/ThisisOmar-here/claude-usage-hack?style=social)](https://github.com/ThisisOmar-here/claude-usage-hack/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Setup time](https://img.shields.io/badge/setup-under%205%20min-blue)](#-hack-1--the-scheduled-task-no-code)

</div>

---

## ⚡ The problem

Claude Pro/Max usage runs on a **rolling 5-hour session**. The clock starts the moment you send your first message — whatever random time that happens to be.

Sit down at 11:47 AM? Your window is now anchored to 11:47 AM, and it expires at 4:47 PM. There is no setting for *"start my session at 9:00 AM sharp."* So your best working hours often land in the middle of a half-burned window instead of at the start of a fresh one.

## 🎯 The idea behind both hacks

**Send one trivial message at the same time every day.** That message starts the session, so the 5-hour window opens on your schedule. The message costs almost nothing — `say hi` is enough. Everything below is just two different ways to make that message send itself.

| | 🖱️ **Hack 1 — Scheduled Task** | 🤖 **Hack 2 — GitHub Actions** |
|---|---|---|
| Setup | Claude's built-in UI, no code | This repo, ~5 min |
| Precision | Anthropic staggers runs by up to ~10 min | Exact, to the minute |
| Needs your laptop on? | No (Anthropic's cloud) | No (GitHub's cloud) |
| Version controlled? | No | Yes |
| Best for | Most people | People who want the window to open *exactly* on time |

Hack 1 is the one to start with. Do Hack 2 only if the ~10 minute stagger actually bothers you.

---

## 🖱️ Hack 1 — the Scheduled Task (no code)

Claude can schedule *itself*. You are just telling it to say hi to you every morning.

<img width="896" height="702" alt="image" src="https://github.com/user-attachments/assets/bc8e00a1-4075-4bff-ac34-8cc3c73b880c" />


1. Open **[claude.ai/code/routines](https://claude.ai/code/routines)** (in the Claude Code app this is `/schedule`).
2. **New routine.**
3. Prompt: `say hi`
4. Model: **Haiku** — cheapest, and the task doesn't need to think, just fire.
5. Trigger: **Schedule** → daily → the time you want your window to open (e.g. 9:00 AM your timezone).
6. Save.

Done. Tomorrow at 9:00 AM, Claude sends itself a message, your session starts, and you get a full fresh 5-hour window from the moment you actually sit down.

> **The one catch:** Anthropic staggers scheduled runs to spread load, so your 9:00 AM routine may actually fire anywhere up to ~10 minutes later. If that's fine, you're finished — you don't need this repo. If you want the window to open at 9:00:00, use Hack 2.

---

## 🤖 Hack 2 — GitHub Actions (exact timing)

Same trick, but the clock lives on GitHub instead of inside Claude. GitHub's cron fires an **API trigger** on your routine at the exact minute you set.

```
GitHub Actions cron (UTC)
        │
        │  POST + bearer token, daily at a fixed time
        ▼
Claude Routine API trigger  ──►  fires a session  ──►  your 5-hour window opens, on schedule
```

Uses Anthropic's official Routines API trigger — no scraping, no stored password, no browser automation.

### Setup

**1. Make the routine.** Same as Hack 1 steps 1–4, but for the trigger pick **API trigger** instead of Schedule. Copy the two values it gives you: the **endpoint URL** and the **bearer token**.

**2. Fork or clone this repo**, then add both values as repo secrets — *Settings → Secrets and variables → Actions → New repository secret*:

| Secret name | Value |
|---|---|
| `CLAUDE_ROUTINE_URL` | the endpoint URL |
| `CLAUDE_ROUTINE_TOKEN` | the bearer token |

**3. Set your time.** Edit the `cron:` line in [`.github/workflows/trigger-session.yml`](.github/workflows/trigger-session.yml). **GitHub cron is always UTC**, so subtract your UTC offset:

| You want | Your timezone | Cron line |
|---|---|---|
| 9:00 AM | UTC+3 (Amman, Riyadh) | `0 6 * * *` |
| 9:00 AM | UTC+1 (Berlin, Lagos) | `0 8 * * *` |
| 9:00 AM | UTC+0 (London, winter) | `0 9 * * *` |
| 9:00 AM | UTC−5 (New York, winter) | `0 14 * * *` |
| 9:00 AM | UTC−8 (LA, winter) | `0 17 * * *` |

Format is `minute hour * * *`. Countries with daylight saving shift by an hour twice a year — UTC does not, so you'll want to nudge the cron line when the clocks change.

**4. Push.**

```bash
git add . && git commit -m "set my session time"
git push
```

**5. Test it now** instead of waiting until tomorrow: *Actions* tab → *Trigger Claude Session Anchor* → **Run workflow**. A green check means it fired; the run should appear on your routines page.

> ⚠️ GitHub disables scheduled workflows in repos with **no activity for 60 days**. If the trigger goes quiet, push any commit to wake it back up.

### Testing from your own machine

```bash
cp .env.example .env    # paste in the URL and token
./scripts/trigger.sh    # reads .env automatically
```

---

## 🧯 Troubleshooting

| Symptom | Likely cause |
|---|---|
| Workflow is green but no session started | Wrong routine URL, or the routine itself is paused |
| `401` / `403` in the run log | Token is wrong or was rotated — update the `CLAUDE_ROUTINE_TOKEN` secret |
| Nothing runs at all | Scheduled workflows only run on the **default branch**, and only in a repo with recent activity |
| Fires ~10 min late | That's Hack 1's stagger — you're on the Scheduled Task, not the API trigger |
| Fires an hour off | Daylight saving — GitHub cron is UTC and doesn't shift |

## 💡 Tips

- 🪙 **Always use Haiku** for the anchor routine. It's the cheapest model and the message doesn't need thinking.
- 🧩 **Stack more routines.** "Say hi at 9" is the simplest possible Scheduled Task. The same mechanism runs daily briefings, inbox triage, or weekly reports.
- ☁️ **Both hacks run in the cloud.** Laptop closed, phone in your pocket — doesn't matter.
- 🔒 **Keep the token in GitHub Secrets**, never in a commit. Rotate it from the routine's settings if it ever leaks.

## 📂 What's in here

```
.github/workflows/trigger-session.yml   the daily cron + the POST
scripts/trigger.sh                      same POST, run by hand for testing
.env.example                            template for your local secrets
```

Three files. That's the whole thing.

## 🤝 Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📈 Star history

[![Star History Chart](https://api.star-history.com/svg?repos=ThisisOmar-here/claude-usage-hack&type=Date)](https://star-history.com/#ThisisOmar-here/claude-usage-hack&Date)

## 📄 License

MIT — see [LICENSE](LICENSE).
