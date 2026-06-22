# Publicly Verifiable Data Sources for Seattle/King County Homelessness Metrics

A comprehensive catalog of public, citable data sources exists across multiple agencies that can populate resource/inventory and outcome metrics for a civic data dashboard. The strongest time-series data comes from **HUD federal datasets** (18 years of Housing Inventory Count), **SHA/KCHA Moving to Work reports** (annual voucher utilization), and **KCRHA's relaunched System Performance Dashboard** (outcome metrics from HMIS). Key gaps exist for tiny home village capacity, which lacks a unified public inventory, and real-time shelter availability data.

---

## Resource and inventory metrics with strong public sourcing

### Shelter bed capacity: HUD Housing Inventory Count is the gold standard

The **Housing Inventory Count (HIC)** provides the most complete, longitudinal shelter inventory data for the Seattle/King County CoC (WA-500), with **18 years** of historical data available.

**Primary Source (Time Series):**
- **URL:** https://www.huduser.gov/portal/sites/default/files/xls/2007-2024-HIC-Counts-by-CoC.xlsx
- **Format:** Excel (filter by CoC code "WA-500")
- **Geographic scope:** Seattle/King County CoC
- **Update frequency:** Annual (January count)
- **Years available:** 2007–2024
- **Metrics:** Emergency Shelter beds, Transitional Housing beds, Safe Haven beds, PSH units, Rapid Rehousing capacity—broken down by target population (veterans, families, youth)

**CoC-Specific PDF Reports:**
- **URL pattern:** `https://files.hudexchange.info/reports/published/CoC_HIC_CoC_WA-500_[YEAR].pdf`
- **Access portal:** https://www.hudexchange.info/programs/coc/coc-housing-inventory-count-reports/

**KCRHA 2024 HIC snapshot (from PIT report):** Total system beds were **7,947** as of January 2024. KCRHA-funded breakdown: Emergency Shelter 4,212 beds (68% of system), Transitional Housing 488 beds, Rapid Rehousing 1,621 units, PSH 2,003 units.

**Methodology caveat:** HIC counts beds/units on a single night in January. Includes both HUD-funded and non-HUD funded projects. HUD conducts limited data quality review but does not independently verify all submissions.

---

### Tiny home village capacity: fragmented data across sources

No single consolidated public inventory of tiny home village (THV) capacity exists. Data is scattered across multiple sources with varying recency.

**Seattle HSD (city-funded THVs):**
- **2024 data:** 16 tiny house villages, **636 units capacity**, served 1,142 households
- **Primary operator:** Low Income Housing Institute (LIHI)
- **Source:** Seattle press releases and HSD reports

**Performance metrics (2024):**
- 46% of individuals exiting city-funded tiny house programs transitioned to permanent housing
- Only 4% returned to homelessness within six months
- Source: City of Seattle press releases citing KCRHA data

**KCRHA Five-Year Plan (2023):**
- **URL:** https://kcrha.org/wp-content/uploads/2023/06/FINAL-KCRHA-Five-Year-Plan-6.1.23.pdf
- Tiny homes have **90% utilization** vs 77% system-wide average
- ~50% exit to permanent housing vs 14-19% for congregate shelters

**New capacity (July 2025):** Seattle announced 104 new tiny homes (2 villages) with $5.9M funding.

**Gap for dashboard:** The user's reference to "Wilson's inherited 250" appears to reference older capacity figures—current deployed capacity is higher but requires triangulating city press releases, LIHI annual reports, and KCRHA board documents. No unified, regularly updated public dataset.

---

### Housing voucher allocations: MTW reports provide detailed breakdowns

**Seattle Housing Authority (SHA) – City of Seattle:**

| Data Type | Source | URL | Update Freq |
|-----------|--------|-----|-------------|
| HCV total allocations | MTW Reports | https://www.seattlehousing.org/about-us/reports/moving-to-work-reports | Annual |
| Project-based vouchers | MTW Reports | 4,762 at start of 2024 across 190+ projects | Annual |
| Emergency Housing Vouchers | Program page | **498 EHVs** allocated (ending 2026) | Ad hoc |
| VASH vouchers | HUD awards | ~418 vouchers | Periodic |
| Waitlist size | MTW Plans | ~24,000 HCV waitlist; ~5,500 public housing | Annual |

**Direct links:**
- 2024 MTW Report: https://www.seattlehousing.org/sites/default/files/2025-04/2024_MTW_Report_submitted_03312025_0.pdf
- 2025 MTW Plan: https://www.seattlehousing.org/sites/default/files/2024-10/SHA_2025_MTW_Plan_Submitted_10.17.2024.pdf

**King County Housing Authority (KCHA) – King County outside Seattle:**

| Data Type | Source | URL | Update Freq |
|-----------|--------|-----|-------------|
| Total households | Key Facts | 25,000+ served nightly | Annual |
| HCV utilization | MTW Reports | **104.5%** of HUD baseline (2021) | Annual |
| Emergency Housing Vouchers | KCRHA FAQ | **762 EHVs** allocated | Ad hoc |
| VASH vouchers | HUD awards | ~493 vouchers | Periodic |
| Public housing units | Financial reports | 2,441 units | Annual |
| Project-based Section 8 | Financial reports | 3,082 operational units | Annual |

**Direct links:**
- 2024 MTW Report: https://www.kcha.org/documents/410.pdf
- Resident Characteristics Data Book 2023: https://www.kcha.org/Portals/0/PDF/Publications/RC%202023%20Databook%20Final.pdf

**Regional EHV total:** King County received **1,314 Emergency Housing Vouchers** (KCHA: 762, SHA: 498, Renton HA: 54). EHV program federally scheduled to end in 2026.

---

### Permanent supportive housing inventory

**HUD HIC (primary time-series source):**
- PSH units tracked in the HIC Excel workbook (2007-2024)
- Filter WA-500 for Seattle/King County CoC
- URL: https://www.huduser.gov/portal/sites/default/files/xls/2007-2024-HIC-Counts-by-CoC.xlsx

**King County Health Through Housing Dashboard:**
- **URL:** https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing/health-through-housing-dashboard
- **Geographic scope:** King County (11 locations)
- **2024 metrics:** 1,281 people served, **95% housing retention rate**
- **Update frequency:** Annual

**KCRHA inventory (2024):** 2,003 KCRHA-funded PSH units out of 8,211 total system (24% of CoC capacity)

---

### Rapid rehousing capacity

**HUD HIC:** Rapid Rehousing slots tracked annually in HIC data (2007-2024)
- **KCRHA-funded (2024):** 1,621 units out of 2,696 total (60% of system)

**KCRHA System Performance Dashboard:**
- **URL:** https://kcrha.org/community-data/system-performance/
- RRH exits to permanent housing rates available
- Note: Utilization rate not available for RRH (no fixed units)

---

### KCRHA contracted bed/unit inventory

**Regional Services Database (live inventory of providers):**
- **URL:** https://airtable.com/appB11Ky0lxjJHsRD/shrlsoQ0f02sTMmCF/tblryLpZfShIjcmxB/viwG6NVUCdcUbB2Q6
- **Info page:** https://kcrha.org/regional-services-database/
- **Update frequency:** Quarterly (providers submit updates)
- **Metrics:** 472 programs, 20 characteristics per program including program type, populations served, amenities

**HMIS Live Inventory (newer):**
- KCRHA launched live inventory tracking in HMIS in 2024
- Providers can mark units as available, in use, or offline
- Goal: Enable real-time shelter referrals
- **Status:** Still being fully implemented through 2025; not yet a public dashboard

**Budget/contract data:**
- **URL:** https://kcrha.org/about/financials/
- **2024 data:** 262 contracts, $218 million administered

---

## Outcome metrics with public sourcing

### KCRHA System Performance Dashboard (primary outcome source)

**URL:** https://kcrha.org/community-data/system-performance/

**Geographic scope:** Seattle/King County CoC (entire King County)

**Update frequency:** Annual trends; dashboard relaunched December 2024

**Data source:** HMIS (85%+ of CoC programs report)

**Metrics available:**

| Metric | Definition | Breakouts Available |
|--------|------------|---------------------|
| **Exits to Permanent Housing** | Total exits to PH ÷ total exits | By intervention type, demographics |
| **Return Rate** | Returns to homelessness within 6 months | By program type |
| **Average Length of Enrollment** | Days in program | By shelter type |
| **Utilization Rate** | Nights occupied ÷ nights available | ES, TH, PSH (not RRH) |
| **Literally Homeless Entries** | % homeless at enrollment | By subpopulation |

**Breakout options:** By intervention type (ES, TH, RRH, PSH), by demographics (race/ethnicity, household type, veteran status, age)

---

### HUD System Performance Measures (federal-level outcome data)

**Excel download (time series):**
- **URL:** https://files.hudexchange.info/resources/documents/System-Performance-Measures-Data.xlsx
- **Years available:** FY 2015–2023 (9 years)
- **Filter by:** CoC code "WA-500"

**Interactive Tableau visualization:**
- **URL:** https://public.tableau.com/app/profile/system.performance.measures.hud.public.data
- Allows CoC-level filtering and cross-CoC comparisons

**SPM metrics:**

| Measure | Description |
|---------|-------------|
| **Measure 1** | Length of time homeless (average/median days in ES, SH, TH) |
| **Measure 2** | Returns to homelessness (within 6mo, 1yr, 2yr) |
| **Measure 3** | Total homeless count (PIT + annual) |
| **Measure 4** | Employment and income growth (entry vs exit) |
| **Measure 5** | First-time homeless entries |
| **Measure 7** | Successful exits to permanent housing by project type |

**Methodology caveat:** Based on HMIS data per HUD programming specifications. CoCs may update prior year submissions, so data can change retroactively. Business logic differs slightly from KCRHA's local reporting.

---

### Veterans-specific outcomes

**King County Veterans Program Data:**
- **VSHSL Annual Report 2024:** https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/veterans-seniors-human-services-levy/annual-report
- **Key 2024 metric:** 830 veterans on Veteran by Name List (end of 2024)
- **Historical archive:** https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/veterans-seniors-human-services-levy/dashboard/archive (2019-2023)

---

### Health Through Housing outcomes

**Dashboard:** https://kingcounty.gov/en/dept/dchs/human-social-services/community-funded-initiatives/health-through-housing/health-through-housing-dashboard

**2024 outcomes:**
- **1,281 people served**
- **95% housing retention rate**
- ER visit reduction data available

---

## Summary of data sources by priority

### High-value sources for dashboard (strongest time-series, public, citable)

| Data Category | Primary Source | URL | Years | Update |
|--------------|----------------|-----|-------|--------|
| Shelter/housing bed inventory | HUD HIC by CoC | huduser.gov/.../2007-2024-HIC-Counts-by-CoC.xlsx | 2007-2024 | Annual |
| System performance outcomes | HUD SPM Data | files.hudexchange.info/.../System-Performance-Measures-Data.xlsx | 2015-2023 | Annual |
| SHA voucher data | MTW Reports | seattlehousing.org/about-us/reports/moving-to-work-reports | 1999-2024 | Annual |
| KCHA voucher data | MTW Reports | kcha.org/about/news/mtw | Annual | Annual |
| KCRHA outcomes | System Performance Dashboard | kcrha.org/community-data/system-performance/ | FY trends | Annual |
| PSH outcomes | Health Through Housing Dashboard | kingcounty.gov HTH dashboard | 2022-2024 | Annual |
| Veterans data | VSHSL Dashboard | kingcounty.gov VSHSL | 2019-2024 | Annual |

### Data gaps requiring workarounds

1. **Tiny home village capacity:** No unified public inventory. Must triangulate city press releases, LIHI reports, and KCRHA board documents. Consider FOIA request to Seattle HSD for contracted THV inventory.

2. **Real-time shelter availability:** KCRHA's HMIS live inventory launched 2024 but not yet public-facing. Current dashboard shows annual trends only.

3. **Rapid rehousing detailed capacity:** HUD HIC provides totals; program-level detail requires KCRHA board documents or FOIA.

4. **Monthly/quarterly updates:** Most public sources update annually. For more frequent data, monitor KCRHA board meeting packets (https://kcrha.org/about/boards-committees/) which contain quarterly updates.

---

## Methodology caveats across all sources

**HMIS coverage:** ~85% of CoC programs report to HMIS. Some providers (especially DV) use separate tracking, creating slight undercounting in HMIS-derived metrics.

**Point-in-time limitations:** PIT and HIC are single-night snapshots in January. WA Dept of Commerce estimates ~54,000 people experience homelessness annually in King County—3x the PIT count.

**Data system overhaul:** KCRHA spent 2023-2024 overhauling data systems. Dashboards were offline October 2023–December 2024. Historical comparability may have breaks.

**Geographic boundaries:** SHA covers Seattle city limits only. KCHA covers King County excluding Seattle and Renton. KCRHA covers entire CoC. HUD data is at CoC level (WA-500).

**MTW flexibility:** Both SHA and KCHA are Moving to Work agencies with HUD-prescribed reporting, but local policy variations may affect year-over-year comparability.

**Federal data lag:** HUD datasets typically have 6-12 month lag from collection to publication.