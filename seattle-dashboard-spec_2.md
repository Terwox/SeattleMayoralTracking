# Seattle Mayoral Accountability Dashboard — Spec v2

## Core Narrative: Wilson's Scorecard

The primary dashboard tells ONE story in five beats:

### Beat 1: THE PROMISE
**What she said she'd do**

> "4,000 new emergency housing and shelter units in four years"

- Big number, center stage: **4,000 units by Jan 2030**
- Simple progress bar showing current vs target
- Implicit pace check: 1,000/year to stay on track

---

### Beat 2: THE BASELINE
**What she actually inherited (not what Harrell claimed)**

Two numbers, side by side:

| Harrell Claimed | Verified Actual |
|-----------------|-----------------|
| ~1,991 units | ~1,300 units |

**Why the gap:** Harrell's exit count included units announced but not built, double-counted beds, and projects already underway before his term. Verified count = units actually operational as of Jan 2026.

This is NOT about dunking on Harrell—it's about establishing a clean baseline so Wilson can't inherit fake numbers and claim credit for closing the gap.

**Source:** Cross-referenced HUD HIC data, KCRHA dashboard, Seattle Times reporting.

---

### Beat 3: THE GIMME
**The obvious day-one win sitting right there**

Giant callout box:

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│     250 TINY HOMES LOCKED IN STORAGE                   │
│     Built by volunteers. Ready to deploy. Waiting.      │
│                                                         │
│     Time in storage: 36+ months                         │
│     People these could shelter: ~250-750                │
│                                                         │
│     STATUS: [Locked] / [Unlocked] / [Deployed]          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

This is the "are you serious or not" test. Zero capital cost. Volunteer-built. Bureaucratic unlock only. If Wilson can't move on this in Q1, that tells you everything about whether the 4,000 target is real.

**Tracking:** Binary status tracker + date unlocked (if ever)

---

### Beat 4: THE OUTCOME
**Her own success metric**

Wilson said the measure of success is: *"How many people are sleeping unsheltered on the streets of Seattle in four years"*

So we track that. Simple.

- **Primary metric:** Unsheltered PIT count (biennial, official)
- **Secondary metric:** KCRHA quarterly estimates (more frequent, less rigorous)
- **Visualization:** Time series with vertical lines at mayoral transitions
- **Baseline:** Jan 2024 PIT = 9,810 unsheltered (clarify: King County, not Seattle-only)

This is the ultimate accountability number. Everything else ladders up to this.

---

### Beat 5: THE EFFICIENCY TEST
**Can she do more with less?**

Two metrics:
1. **Cost per shelter bed** (annual operating) — currently $16K-$127K depending on type
2. **Cost per housing unit** (capital) — currently $270K-$500K

**The question:** Can Wilson bend these curves down while INCREASING supply?

This is the "good governance" test. Anyone can spend more money. The efficiency test shows whether she's actually improving the system or just shoveling cash.

**Visualization:** Trend lines by year, broken out by shelter/housing type
**Data note:** Requires manual annual compilation (see methodology)

---

## Stretch Goal vs Politics-as-Usual

Frame the 4,000 target with two paths:

### Path A: Politics as Usual (Achievable)
| Source | Units |
|--------|-------|
| Harrell carryover (verified) | ~1,300 |
| Unlock warehoused tiny homes | 250 |
| Actual new construction needed | 2,450 |
| **Total** | **4,000** |

This path counts inherited work and easy wins. It's what a politician would do. It still requires real effort (2,450 new units is substantial), but it's playing with house money.

### Path B: Stretch Goal (Ambitious)
**Break ground on 4,000 genuinely new units, delivered within term.**

This would mean:
- Not counting Harrell carryover
- Not counting unlocked tiny homes as "new"
- Actually adding 4,000 net-new units to the system

Display both paths. Let the data show which one Wilson is actually pursuing.

---

## UI Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│  WILSON'S HOMELESSNESS SCORECARD                                │
│  Tracking the 4,000-unit promise with verified public data      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  THE PROMISE                                                    │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ 4,000 UNITS BY JAN 2030                                 │   │
│  │ [██████░░░░░░░░░░░░░░░░░░░░░░░░] 1,300 / 4,000          │   │
│  │ Pace needed: 1,000/yr | Current pace: TBD               │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  THE BASELINE                          THE GIMME                │
│  ┌──────────────────────────┐  ┌──────────────────────────┐    │
│  │ Harrell claimed: 1,991   │  │ 250 TINY HOMES LOCKED    │    │
│  │ Verified actual: 1,300   │  │ Status: ⚠️ WAITING       │    │
│  │ Gap: 691 phantom units   │  │ Months in storage: 36+   │    │
│  └──────────────────────────┘  └──────────────────────────┘    │
│                                                                 │
│  THE OUTCOME                           EFFICIENCY TEST          │
│  ┌──────────────────────────┐  ┌──────────────────────────┐    │
│  │ UNSHELTERED COUNT        │  │ COST TRENDS              │    │
│  │ [time series]            │  │ $47K/bed | $312K/unit    │    │
│  │ Baseline: 9,810          │  │ [trend arrows]           │    │
│  └──────────────────────────┘  └──────────────────────────┘    │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│  [Context & Deep Dive →]                                        │
└─────────────────────────────────────────────────────────────────┘
```

---

## Secondary Dashboard: Context & Deep Dive

This is the "everything else" bucket—important data that doesn't fit the core scorecard but matters for the full picture.

### What lives here:

1. **Public Safety Crossover**
   - Homeless-involved violent crime
   - Encampment-related 911 calls
   - *Why here:* Different policy domain, not her housing promise

2. **Overdose Deaths**
   - Monthly homeless overdose fatalities
   - Drug type breakdown
   - *Why here:* Mortality outcome that matters, but not directly tied to housing promise

3. **System Resources (HUD HIC)**
   - Emergency shelter capacity
   - Transitional housing
   - Rapid re-housing
   - Permanent supportive housing
   - *Why here:* Reference data, not accountability data

4. **Detailed Spending Breakdown**
   - KCRHA budget by category
   - City vs County allocation
   - *Why here:* Wonk fodder, useful for journalists

5. **Voucher Utilization**
   - SHA/KCHA voucher usage rates
   - HUD Moving to Work data
   - *Why here:* Important but not her direct lever

6. **Tiny Home Village Performance**
   - Exit to permanent housing rate (46%)
   - Return to homelessness rate (4%)
   - Units operational over time
   - *Why here:* Supports the "gimme" argument with outcome data

7. **Health Through Housing**
   - Units acquired, people served, retention
   - *Why here:* County program, parallel track

### Context Dashboard Layout

Simpler—just a scrollable page of cards with expandable details. No narrative arc needed. This is reference material for people who want to go deeper.

---

## Data Sources (unchanged from v1)

See spec v1 for full source documentation. Key additions for v2:

### Baseline Verification
- HUD HIC 2024 for WA-500 CoC
- KCRHA Households Served Dashboard
- Seattle Times "Project Homeless" coverage
- Cross-reference method: If a unit appears in HIC AND has operational date before Jan 2026, it counts toward baseline.

### Tiny Home Status Tracking
- LIHI annual reports
- Seattle Times coverage (esp. Dec 2024 article on warehoused units)
- City press releases (for deployment announcements)
- Manual monitoring required

---

## Success Criteria (revised)

The scorecard succeeds if:

1. **Wilson's team can't bullshit.** The baseline is established. The count methodology is transparent. Phantom units get called out.

2. **The tiny homes become a symbol.** If they get unlocked, she gets credit. If they don't, it's a visible failure.

3. **Progress is pace-checkable.** At any point, you can see: "She needs X units by Y date to stay on track."

4. **Efficiency trends are visible.** If costs are rising while supply stagnates, that's obvious. If she's doing more with less, that's also obvious.

5. **The outcome metric is her own words.** She can't move the goalposts because we're using her stated success criterion.

---

## Implementation Notes

- **v2 is a restructure, not a rebuild.** Same data, different story.
- **Primary dashboard should fit on one screen** (maybe light scroll on mobile)
- **Context dashboard can be longer**—it's for people who want depth
- **Update frequency:** Primary metrics quarterly; context metrics as available
- **Keep the "DATA GAPS" section** from v1—transparency about what we can't track

---

## File Structure (revised)

```
seattle-mayor-dashboard/
├── app.R
├── R/
│   ├── scorecard.R          # Primary 5-beat dashboard
│   ├── context.R            # Secondary deep-dive dashboard  
│   ├── data_load.R
│   └── charts.R
├── data/
│   ├── promise_progress.csv  # Unit counts toward 4K
│   ├── baseline.csv          # Harrell vs verified comparison
│   ├── tiny_homes_status.csv # Gimme tracking
│   ├── pit_counts.csv        # Outcome metric
│   ├── cost_efficiency.csv   # Efficiency test
│   └── context/              # All secondary data
│       ├── overdose_deaths.csv
│       ├── spending.csv
│       ├── hud_hic.csv
│       └── ...
├── docs/
│   ├── methodology.md
│   └── sources.md
└── ...
```

---

## Changelog from v1

- Restructured around 5-beat narrative (Promise → Baseline → Gimme → Outcome → Efficiency)
- Added "Politics as Usual" vs "Stretch Goal" framing
- Demoted crime, overdose, spending breakdown, vouchers to Context dashboard
- Elevated tiny homes to primary "Gimme" beat
- Simplified primary UI to single-screen scorecard
- Added baseline verification methodology
- Revised success criteria around anti-bullshit goals
