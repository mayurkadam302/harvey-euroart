# harvey-euroart

[Harvey](https://github.com/ethanplusai/harvey) set up as a **lead finder** for EuroArt EA digital locks in the UAE. It never sends email: email is off, the daily send limit is 0, and sending is paused.

## What's here

| File | What it does |
|---|---|
| `harvey.local.yaml` | Targets: construction contractors, fit-out and interior design firms, joinery, door suppliers, hardware stores, locksmiths and architects in Dubai, Abu Dhabi, Sharjah, Ajman and Ras Al Khaimah |
| `osm-uae-trades.patch` | Teaches Harvey's free OpenStreetMap source those trades (out of the box it only knows roofers, plumbers and similar) |
| `run-harvey-leads.ps1` | Downloads Harvey at the tested version, applies the above, installs it and runs discovery |

## Run it (Windows)

1. Install [Git for Windows](https://git-scm.com) and [Python 3.11+](https://python.org) (tick "Add to PATH").
2. Download or clone this repo, open PowerShell in its folder and run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\run-harvey-leads.ps1
   ```

3. The company list is written as a CSV in the `harvey` folder.

## Limits

The free map source has thin UAE coverage, many firms appear without a website. For a fuller list, add a free Serper key (`SERPER_API_KEY` in `harvey\.env`) and run `harvey discover --provider serper`.
