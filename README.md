<div align="center">

# 🕐 claude-usage-hack

### Anchor your Claude Pro/Max usage window to a time *you* choose — not whenever you happened to open the app.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/ThisisOmar-here/claude-usage-hack?style=social)](https://github.com/ThisisOmar-here/claude-usage-hack/stargazers)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Built for Claude](https://img.shields.io/badge/built%20for-Claude%20Pro%2FMax-D97757)](https://claude.ai)
[![Setup time](https://img.shields.io/badge/setup-under%205%20min-blue)](#-quick-start)

</div>

---

## ⚡ The problem

Claude Pro/Max usage runs on a **rolling 5-hour session**. That window starts the moment you send your first message of the day — whatever random time that happens to be.

Open Claude at 11:47 AM because that's when you sat down? Your clock is now anchored to 11:47 AM. There's no setting for "start my session at 9:00 AM sharp." Your best working hours can land in the *middle* of an already half-used window instead of the start of a fresh one.

## 🎯 The hack

Fire a trivial, near-zero-cost message at the exact same time every day. That message becomes your session's start signal. Your 5-hour window now opens on **your** schedule — not Claude's.

## 🆚 Two ways to do it

| | 🖱️ Native (zero code) | 🤖 This repo (external cron) |
|---|---|---|
| Setup | Claude's built-in Scheduled Tasks UI | GitHub Actions + Routines API |
| Precision | Anthropic's own stagger (up to ~10 min) | Exact, to the minute |
| Needs a device on? | No — Anthropic's cloud | No — GitHub's cloud |
| Best for | "good enough" | Precise, automated, version-controlled |

## 🔧 How it works

```
GitHub Actions (cron, UTC)
        │
        │  POST + bearer token, daily at a fixed time
        ▼
Claude Code Routine API trigger  ──►  fires a session  ──►  your 5-hour window starts, on schedule
```

Uses Anthropic's official Routines API trigger — no scraping, no stored passwords, no browser automation.

## 🚀 Quick start

1. **Create the routine** — `claude.ai/code/routines` → New routine → prompt: `say hi` → add an **API trigger** → copy the endpoint URL + bearer token.
2. **Add repo secrets** — Settings → Secrets and variables → Actions:
   - `CLAUDE_ROUTINE_URL`
   - `CLAUDE_ROUTINE_TOKEN`
3. **Set your fire time** — edit the cron line in `.github/workflows/trigger-session.yml` (default `0 6 * * *` = 9:00 AM UTC+3).
4. **Push it:**
   ```bash
   git init && git add . && git commit -m "init"
   git remote add origin <your-repo-url>
   git branch -M main && git push -u origin main
   ```
5. **Done.** GitHub fires your session-start trigger daily, for free, forever.

## 🧪 Local testing

```bash
cp .env.example .env   # fill in the two values from step 1
export $(cat .env | xargs)
./scripts/trigger.sh
```

## 💡 Tips

- 🪙 **Use Haiku** for the routine's model — smallest, cheapest, and the task doesn't need to think, just fire.
- 🧩 **Stack multiple tasks** — this repo's trick is the simplest possible use of Scheduled Tasks/Routines. Add more for daily briefings, inbox triage, weekly reports.
- ☁️ **Fully cloud-based** — laptop closed, phone in your pocket, doesn't matter.

## 🔒 Security

The bearer token lives only in GitHub Secrets — never committed, never logged. Rotate it any time from the routine's settings if it ever leaks.

## 🤝 Contributing

Issues and PRs welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## 📈 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=ThisisOmar-here/claude-usage-hack&type=Date)](https://star-history.com/#ThisisOmar-here/claude-usage-hack&Date)

## 📄 License

MIT — see [LICENSE](LICENSE).
