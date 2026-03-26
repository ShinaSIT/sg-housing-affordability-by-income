# Real Income vs Housing Prices in Singapore

**AAI1001 – Data Engineering and Visualization | AY25/26 Tri 2**

## Team Members

- **Shina Shih Xin Rong** (2402781) - Data Engineering Lead
- **Jeanie Cherie Chua Yue-Ning** (2403083) - Visualization Owner
- **Claudia Yue Xin Ying** (2401817) - Critique & Story
- **Nurul Zahirah Binte Muhamadnoh** (2401671) - Slides & Submission
- **Anushka Chourasia** (2503769) - Analysis & Q&A Prep

---

## 📊 Project Overview

### Research Question
**Did real income growth for lower-income households keep pace with housing price growth between 2000 and 2025, and have affordability gaps widened across income groups over time?**

### Key Findings
- **Before 2010**: Real income broadly kept pace with HDB resale prices across all income groups
- **After 2010**: Affordability gap widened progressively, with sharp acceleration post-2020
- **Bottom 20%**: Face the most acute pressure with a 31-point gap (140.5 vs 171.6 index) by 2025

---

## 📁 Project Structure

```
project/
├── presentation.qmd          # Main Quarto Revealjs presentation
├── project-proposal.qmd      # Week 9 proposal (single HTML page)
├── custom.scss               # Custom styling for presentation
├── tidy_data.rds            # Final cleaned dataset (156 rows × 4 cols)
├── data/                    # Raw data files
│   ├── income_by_decile.csv
│   ├── cpi_by_group.xlsx
│   └── hdb_resale.csv
├── images/                  # Visualization assets
│   └── Average-Household-Income-Per-Household-Image.jpg
└── README.md               # This file
```

---

## 🔧 How to Reproduce

### Prerequisites
- R (≥ 4.0.0)
- RStudio with Quarto installed
- Required R packages (see Installation section)

### Installation

```r
# Install required packages
install.packages(c(
  "tidyverse",   # Data manipulation
  "knitr",       # Document generation
  "gt",          # Table formatting
  "scales"       # Scale functions for visualization
))
```

### Rendering the Presentation

1. **Open the project in RStudio**
2. **Open `presentation.qmd`**
3. **Click "Render"** or run:
   ```r
   quarto::quarto_render("presentation.qmd")
   ```
4. **Output**: `presentation.html` (self-contained, embeds all resources)

### Rendering the Proposal

```r
quarto::quarto_render("project-proposal.qmd")
```

---

## 📊 Data Sources

### 1. Average Monthly Household Employment Income by Decile
- **Source**: Department of Statistics Singapore (SingStat)
- **URL**: [SingStat Table Builder](https://tablebuilder.singstat.gov.sg/table/CT/17880)
- **Period**: 2000–2025
- **Format**: Excel (.xlsx)
- **Usage**: Nominal income across 10 deciles → aggregated into 3 groups

### 2. CPI by Household Income Group
- **Source**: Department of Statistics Singapore (SingStat)
- **URL**: [SingStat CPI Highlights](https://www.singstat.gov.sg/whats-new/latest-news/cpi-highlights/)
- **Period**: 2000–2025 (2024 base year)
- **Format**: Excel (.xlsx)
- **Groups**: Lowest 20%, Middle 60%, Highest 20%
- **Usage**: Group-specific price deflator for real income calculation

### 3. HDB Resale Flat Prices
- **Source**: Housing & Development Board / data.gov.sg
- **URL**: [data.gov.sg HDB Resale](https://data.gov.sg/collections/189/view)
- **Period**: 2000–2025
- **Format**: CSV (transaction-level records)
- **Usage**: Annual median resale price → housing cost index

---

## 🔄 Data Engineering Pipeline

### Stage 1: Ingest
- Load 3 raw sources using `read_excel()` and `read_csv()`
- Result: 3 raw data frames

### Stage 2: Clean & Aggregate
- Aggregate 10 income deciles into 3 meaningful groups:
  - **Bottom 20%**: Deciles 1–2
  - **Middle 60%**: Deciles 3–8
  - **Top 20%**: Deciles 9–10
- Use `case_when()` for grouping logic

### Stage 3: Deflate (Convert to Real Income)
- Formula: **Real Income = Nominal Income ÷ (CPI / 100)**
- Apply group-specific CPI deflation
- Result: Real income in 2024 SGD

### Stage 4: Index to Common Base Year
- Formula: **Index = (Value ÷ Value₂₀₁₀) × 100**
- Rebase both real income and HDB resale price to 2010 = 100
- Ensures honest visual comparison on single y-axis

### Stage 5: Join & Export
- Combine income index + HDB index using `bind_rows()`
- Export as `tidy_data.rds`
- **Final dimensions**: 156 rows × 4 columns

### Tidy Dataset Structure

| Column          | Type      | Description                                    |
|----------------|-----------|------------------------------------------------|
| `Year`         | Integer   | Time dimension (2000–2025)                     |
| `Income_Group` | Factor    | Bottom 20%, Middle 60%, Top 20%                |
| `Measure_Type` | Factor    | Real Income or HDB Resale Price                |
| `Index_Value`  | Numeric   | Indexed value (2010 = 100)                     |

---

## 📈 Key Improvements Over Original Visualization

| Original Problem | Our Solution |
|-----------------|--------------|
| **Dual y-axis distortion** – falsely suggests correlation | **Common indexed scale** (2010 = 100) – single y-axis |
| **Ten overlapping lines** – visual congestion | **Three aggregated groups** – Bottom/Middle/Top |
| **Nominal income** – overstates real gains | **Group-specific CPI deflation** |
| **No housing metric** – general PPI used | **HDB resale price overlay** |
| **Dense legend** – high cognitive load | **Shaded affordability gap ribbon** |
| **No affordability metric** – must estimate gaps | **Direct endpoint labels** (2025 values) |
| **No economic context** | **GFC & COVID-19 annotations** |

---

## 📊 Analysis Methods

### 1. Index-Based Comparison (Main Visualization)
- Common base year (2010 = 100) enables honest visual comparison
- Shaded ribbon shows affordability gap directly
- Event annotations (GFC, COVID-19) provide economic context

### 2. Affordability Gap Over Time
- Gap = HDB Resale Price Index − Real Income Index
- Separate lines for each income group
- Shows gap acceleration post-2020

### 3. Compound Annual Growth Rate (CAGR) Analysis
- Formula: **CAGR = [(End Value / Start Value)^(1/n) − 1] × 100**
- Three periods analyzed:
  - 2000–2010
  - 2010–2020
  - 2020–2025
- Quantifies divergence between income and housing prices

---

## 🎯 Key Insights

### Before 2010
- Real income broadly kept pace with HDB prices
- GFC (2008–09) temporarily compressed the gap as housing dipped
- Affordability gap was negative (income ahead)

### 2010 Onward
- Resale prices diverge upward from income across all groups
- Gap widens progressively
- Acceleration after 2020: pent-up demand + construction delays + low interest rates

### By 2025
- **Bottom 20%**: Income index 140.5 vs HDB 171.6 → Gap = **+31.1 points** (most policy-relevant)
- **Middle 60%**: Income index 141.8 vs HDB 171.6 → Gap = **+29.8 points**
- **Top 20%**: Income index 113.8 vs HDB 171.6 → Gap = **+57.8 points** (CPI deflation artifact)

**Note**: Top 20% gap appears largest due to higher CPI basket (more services, discretionary spending), but they still have highest absolute income and strongest financial buffers.

---

## ⚠️ Limitations

### Data Scope
- **Median annual resale price** – no flat type or location variation
- **Employment income only** – excludes transfers, CPF top-ups
- **CPI deflation** – does not account for mortgage rates or debt servicing costs
- **Index rebasing** – obscures absolute level differences

### Methodological
- Annual data – no monthly or quarterly granularity
- No adjustment for household size changes over time
- No consideration of government housing grants (CPF Housing Grant, AHCG)

---

## 🔮 Possible Extensions

### Geographic Dimension
- Break down by town-level HDB prices
- Compare mature vs non-mature estates

### Flat Type Analysis
- Separate analysis for 3-room, 4-room, 5-room flats
- Price-to-income ratios by flat type

### Policy Impact
- Incorporate government grants and subsidies
- Add mortgage servicing ratios
- Include CPF contribution impact

### Temporal Refinement
- Quarterly or monthly data for recent years
- Rolling window analysis for smoothed trends

---

## 📝 File Descriptions

### Core Files

**`presentation.qmd`**
- Main Quarto Revealjs presentation (HTML format)
- 6 major sections covering original viz, critique, data sources, engineering, improved viz, analysis
- Speaker notes for each slide
- Self-contained output with embedded resources

**`project-proposal.qmd`**
- Week 9 proposal submitted as single Quarto HTML page
- Documents original visualization, critiques, proposed improvements, data sources, workflow

**`custom.scss`**
- Custom SCSS styling for Revealjs presentation
- Defines fonts, colors, headings, table styles
- Optimized for performance and readability

**`tidy_data.rds`**
- Final cleaned and indexed dataset
- R data format for efficient loading
- 156 rows × 4 columns (Year, Income_Group, Measure_Type, Index_Value)

---

## 🎬 Presentation Guidelines

### Duration
- **Maximum**: 15 minutes
- **Recommended**: 12–14 minutes to allow buffer

### Speaker Distribution
- All 5 team members must speak
- Distribution is flexible but should be balanced

### Technical Requirements
- MP4 format with smooth AV synchronization
- Clear audio for all speakers
- Smooth transitions between speakers

### Content Coverage (Required)
1. Original Data Visualization
2. Critiques and Proposed Improvements
3. Data Selection and Sources
4. Data Engineering Workflow (raw → tidy)
5. Improved Visualization (with improvements)
6. Insights and Analysis
7. Conclusion

---

## 🤝 Team Contributions

| Member | Role | Key Responsibilities |
|--------|------|---------------------|
| **Shina** | Data Engineering Lead | Finalize R pipeline, ensure reproducibility, present data engineering workflow |
| **Jeanie** | Visualization Owner | Build and refine final ggplot2 visualization, present improved visualization + insights slides |
| **Claudia** | Critique & Story | Write and present critique of original viz (weaknesses → improvement mapping), present Original Viz + Critiques slides |
| **Nurul Zahirah** | Slides & Submission | Build Quarto RevealJS deck, coordinate ZIP package, handle LMS submission, present Data Sources + Conclusion |
| **Anushka** | Analysis & Q&A Prep | Write optional data analysis section (e.g., affordability gap commentary), coordinate peer Q&A responses during Week 13 |

---

## 📚 References

### Data Sources
1. Department of Statistics Singapore. (2025). *Average Monthly Household Employment Income by Decile*. Retrieved from https://tablebuilder.singstat.gov.sg/table/CT/17880

2. Department of Statistics Singapore. (2025). *Consumer Price Index by Household Income Group*. Retrieved from https://www.singstat.gov.sg/whats-new/latest-news/cpi-highlights/

3. Housing & Development Board / data.gov.sg. (2025). *HDB Resale Flat Prices*. Retrieved from https://data.gov.sg/collections/189/view

### Original Visualization
Stacked Homes. (2020). *Has Our Household Income Really Overtaken Growth In Property Prices?* Retrieved from https://stackedhomes.com/has-our-household-income-really-overtaken-growth-in-property-prices/#sh.zta0kv

---

## 📧 Contact

For questions about this project, please contact any team member through the course LMS forum.

**Course**: AAI1001 – Data Engineering and Visualization  
**Academic Year**: 2025/26 Trimester 2  
**Submission**: Week 13 (Final)

---

## 📄 License

This project is submitted as part of AAI1001 coursework. All data sources are publicly available from Singapore government agencies. Original visualization critiqued under fair use for educational purposes.

---

**Last Updated**: March 2026
