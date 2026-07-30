# =============================================================================
# prep_context.R  (run once; caches curated CSVs read by build_data.R)
#
# Hand-curated, per-cell-sourced context for the 8 chokepoints. Every figure is
# a FACT stated in original wording with an attribution and a resolvable URL
# (the same "facts, not expression" principle used for chokepoint_risks); no
# source's copyrighted table or prose is reproduced.
#
# Editorial rules applied here:
#   * Transit counts are REPRESENTATIVE NORMAL-YEAR figures, never a
#     crisis-depressed snapshot; the basis (what is counted, which year, single
#     strait vs combined straits) is stated so figures are not mis-compared.
#     Crisis magnitudes live in chokepoint_risks, not here.
#   * Where only a secondary aggregator was found and it did not resolve to a
#     named authority, the figure is marked confidence = "Low" so users can
#     filter it out; it is never silently presented as authoritative.
#
# Writes:
#   data-raw/chokepoint_context.csv  (wide, one readable profile row per CP)
#   data-raw/chokepoint_sources.csv  (long, one row per sourced figure)
# =============================================================================

suppressPackageStartupMessages({ library(dplyr); library(tibble) })

# ---- Wide, human-readable per-chokepoint context ---------------------------
chokepoint_context <- tribble(
  ~location, ~daily_transits, ~annual_transits, ~transit_basis, ~share_world_trade, ~primary_cargo, ~dominant_vessels, ~top_users, ~local_economic_note, ~reroute_note,

  "Panama Canal", 36L, NA_integer_,
  "Deep-draft vessels, normal capacity (EIA). ~13,000-14,000/yr in a normal year; fell to 9,944 deep-draft transits in the FY2024 drought.",
  "~2.5-5% of world seaborne trade by volume (UNCTAD/McKinsey; IMF).",
  "Containers, petroleum products & hydrocarbon-gas liquids, dry bulk (grain, coal), vehicles.",
  "Container ships, LPG (VLGC) & LNG carriers, chemical/product tankers, bulk carriers, car carriers.",
  "United States (~66-75% of cargo), China, Japan.",
  "Canal revenue ~US$5.0bn (FY2024); ~4% of Panama GDP and ~20% of central-government income (ACP; AS/COA).",
  "Alternatives: Suez (+~7-10 days) or Cape of Good Hope; US Gulf->China is ~+20 days via the Cape.",

  "Suez Canal", 72L, 26434L,
  "All vessels, 2023 record year (Suez Canal Authority). Traffic roughly halved to 13,213 transits in 2024 during the Red Sea crisis.",
  "~12-15% of world trade and ~30% of global container traffic (UNCTAD).",
  "Containerized manufactures (Asia-Europe), crude & refined products, LNG, dry bulk, vehicles.",
  "Container ships, tankers (~32-37% of transits), dry bulk carriers, LNG and car carriers.",
  "Asia-Europe carriers (Maersk, MSC, CMA CGM); operated by Egypt.",
  "Toll revenue US$10.3bn (2023) fell to ~US$4bn in 2024 (-60%); a top source of Egypt's foreign currency (SCA; Ahram Online).",
  "Alternative: Cape of Good Hope, +~3,000-3,500 nm / +10-14 days, ~+US$1M fuel per voyage.",

  "Strait of Malacca", 258L, 94301L,
  "All vessels, 2024, Malacca and Singapore Straits COMBINED (inforMARE). Not directly comparable to single-strait counts.",
  "~one-quarter of world seaborne trade (widely cited; secondary).",
  "Crude oil & LNG (Gulf->Asia), containers, dry bulk (iron ore, coal, grain).",
  "Container ships (25,127), bulk carriers (19,507), VLCCs (9,724), general cargo, LNG carriers (2024 counts).",
  "China, Japan, South Korea (~80% of transiting crude), Indonesia.",
  "Singapore: world's largest bunkering hub (54.9M t marine fuel, 2024) and container transshipment port (41.1M TEU) (MPA).",
  "Alternatives: Sunda (+1,086 nm / ~2 days) or Lombok (+2,488 nm / ~4 days) Straits (RSIS).",

  "Strait of Hormuz", 96L, NA_integer_,
  "Commercial vessels/day, 2024 (IMF PortWatch AIS); ~21 tankers/day.",
  "~20% of global petroleum liquids, ~25% of seaborne oil, and >20% of LNG trade (EIA; IEA).",
  "Crude oil & condensate, refined products, LNG.",
  "Crude & product tankers (incl. VLCCs), LNG carriers.",
  "Exporters: Saudi Arabia, Iraq, UAE, Iran, Kuwait, Qatar; destinations: China, India, Japan, South Korea (~74%).",
  "Vital to Gulf exporters; Qatar ~93% and UAE ~96% of LNG exports transit the strait (IEA).",
  "Bypass pipelines (Saudi Petroline, UAE ADCOP) offer ~3.5-5 mb/d of spare capacity against ~21 mb/d of flow (IEA).",

  "Strait of Bab el-Mandeb", 66L, NA_integer_,
  "All vessels, 2023 baseline (~459 vessels/week, IMF PortWatch). Weekly transits fell ~48% in 2024 during the Red Sea crisis.",
  "~10-12% of world trade via the Suez corridor; ~30% of global container traffic (UNCTAD).",
  "Containers, crude & products, dry bulk and grain (southern gateway to the Suez Canal).",
  "Container ships, bulk carriers, oil tankers.",
  "Asia-Europe carriers (Maersk, MSC, CMA CGM).",
  "Gateway feeding the Suez Canal; the 2024 crisis cut Suez revenue by ~US$7bn (SCA).",
  "Alternative: Cape of Good Hope (+~4,000 nm / +10-14 days); the SUMED pipeline (~2.5 mb/d) bypasses only Suez-bound Gulf oil.",

  "Turkish Straits", 123L, 45000L,
  "All vessels, 2024 (EIA, 'more than 45,000/yr' through the Bosphorus).",
  "~5% of global maritime trade; the Black Sea region supplies ~30% of world wheat exports (EIA; FAO).",
  "Russian & Caspian crude and products, Black Sea grain, steel.",
  "Oil & product tankers, dry bulk (grain) carriers, general cargo.",
  "Kazakhstan, Russia, Azerbaijan (oil); Ukraine, Russia, Romania (grain).",
  "Only sea outlet for Black Sea states; passage governed by the 1936 Montreux Convention (Turkiye MFA).",
  "No maritime bypass exists - the only sea route between the Black Sea and the world ocean.",

  "Dover Strait", 400L, NA_integer_,
  "Commercial vessels/day (UK Maritime & Coastguard Agency). Commonly cited as the world's busiest shipping lane.",
  "World's busiest shipping lane; the Port of Dover alone handles 33% of UK-EU goods trade (Port of Dover).",
  "Containers, RoRo freight & ferries, North Sea oil & LNG, grain, chemicals.",
  "Cargo ships plus 100+ cross-Channel ferry/RoRo movements per day.",
  "United Kingdom, France, Netherlands, Belgium, Germany.",
  "Gateway to the Rotterdam/Antwerp/Hamburg range; Port of Dover handled 8.9M passengers and 2.2M freight vehicles (2023).",
  "No practical maritime bypass for Channel traffic; the Channel Tunnel carries some freight (2.6M vehicles, 2023).",

  "Strait of Gibraltar", 300L, NA_integer_,
  "All vessels/day (~148 merchant), attributed to the Gibraltar Port Authority via a secondary aggregator - treat as indicative (see confidence).",
  "Sole maritime gateway between the Mediterranean and the Atlantic; adjacent hubs handle ~15M TEU/yr (port authorities).",
  "Container transshipment (Algeciras, Tanger Med), crude & products, dry bulk, ferries.",
  "Container ships, tankers, bulk carriers, ferries.",
  "Spain, Morocco; EU-Asia and EU-Americas carriers.",
  "Serves the whole Mediterranean basin; Algeciras ~104M t and Tanger Med 10.2M TEU (2024).",
  "No maritime bypass - the sole western sea entrance to the Mediterranean."
) |> as.data.frame(stringsAsFactors = FALSE)

# ---- Long, one row per sourced figure (full provenance) --------------------
# confidence: "High" = named authority / official statistics; "Medium" =
# reputable reporting or AIS-derived (e.g. IMF PortWatch via trade press);
# "Low"  = secondary aggregator not resolving to a named authority.
chokepoint_sources <- tribble(
  ~location, ~variable, ~value, ~unit, ~year, ~basis, ~source, ~source_url, ~confidence,

  # ---- Panama Canal ----
  "Panama Canal", "annual_transits", "9944 (FY2024 drought); ~13,000-14,000 normal", "ships/yr", "2024", "Deep-draft transits; FY Oct-Sep", "Panama Canal Authority (ACP)", "https://pancanal.com/en/presents-financial-results-for-fy24-with-a-focus-on-sustainability-and-the-future/", "High",
  "Panama Canal", "daily_transits", "36 normal; ~24 during 2023-24 drought", "ships/day", "2023", "Deep-draft vessels", "U.S. EIA", "https://www.eia.gov/todayinenergy/detail.php?id=60842", "High",
  "Panama Canal", "share_world_trade", "~2.5-5", "% of world seaborne trade (volume)", "2024", "By volume", "UNCTAD / McKinsey", "https://www.mckinsey.com/industries/logistics/our-insights/how-could-panama-canal-restrictions-affect-supply-chains", "Medium",
  "Panama Canal", "toll_revenue", "5.0", "US$ bn", "2024", "FY2024 total revenue (ACP)", "Panama Canal Authority (ACP)", "https://pancanal.com/en/presents-financial-results-for-fy24-with-a-focus-on-sustainability-and-the-future/", "High",
  "Panama Canal", "gdp_dependence", "~4 (direct); ~20 of govt income", "% of Panama GDP", "2024", "Direct canal contribution", "AS/COA", "https://www.as-coa.org/articles/25-years-transfer-panama-canal", "Medium",
  "Panama Canal", "top_users", "United States ~66-75% of cargo; then China, Japan", "share of cargo", "2024", "By origin/destination port", "CSIS", "https://www.csis.org/analysis/key-decision-point-coming-panama-canal", "Medium",

  # ---- Suez Canal ----
  "Suez Canal", "annual_transits", "26434 (2023 record); 13213 (2024)", "ships/yr", "2023", "All vessels", "Suez Canal Authority (via Statista)", "https://www.statista.com/statistics/1252568/number-of-transits-in-the-suez-cana-annually/", "High",
  "Suez Canal", "annual_net_tonnage", "1568 (2023); 524.5 (2024)", "million net tons", "2023", "SCA net tonnage", "Suez Canal Authority (via Ahram Online)", "https://english.ahram.org.eg/News/537603.aspx", "High",
  "Suez Canal", "share_world_trade", "~12-15", "% of world trade", "2023", "UNCTAD estimate", "UNCTAD", "https://unctad.org/news/red-sea-crisis-and-implications-trade-facilitation-africa", "High",
  "Suez Canal", "container_share", "~30", "% of global container traffic", "2023", "UNCTAD estimate", "UNCTAD", "https://unctad.org/news/red-sea-crisis-and-implications-trade-facilitation-africa", "High",
  "Suez Canal", "toll_revenue", "10.3 (2023); ~4 (2024, -60%)", "US$ bn", "2023", "SCA toll revenue", "Suez Canal Authority (via AGBI)", "https://www.agbi.com/logistics/2024/12/suez-canal-revenue-drops-7bn-amid-red-sea-instability/", "High",
  "Suez Canal", "reroute_cost", "+3,000-3,500 nm / +10-14 days; ~+US$1M fuel/voyage", "Cape of Good Hope", "2024", "Asia-N.Europe", "Supply Chain Dive", "https://www.supplychaindive.com/news/suez-cape-good-hope-ever-given-evergreen-blocked-stuck/597402/", "Medium",

  # ---- Strait of Malacca ----
  "Strait of Malacca", "annual_transits", "94301 (2024 record)", "ships/yr", "2024", "Malacca + Singapore Straits COMBINED", "inforMARE", "https://www.informare.it/news/gennews/2025/20250028-Stretti-Malacca-Singapore-transiti-Y-2024uk.asp", "Medium",
  "Strait of Malacca", "vessel_mix", "Container 25,127; bulk 19,507; VLCC 9,724; general cargo 8,056; LNG 5,003", "ships (2024)", "2024", "Major categories only; do not sum to total", "inforMARE", "https://www.informare.it/news/gennews/2025/20250028-Stretti-Malacca-Singapore-transiti-Y-2024uk.asp", "Medium",
  "Strait of Malacca", "oil_transit", "23.2", "million b/d", "2025", "World's largest oil chokepoint (H1 2025)", "U.S. EIA World Oil Transit Chokepoints", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints", "High",
  "Strait of Malacca", "share_world_trade", "~24", "% of world seaborne trade (volume)", "2024", "Widely cited 'about one-quarter'", "Seatrade / industry (secondary)", "https://sgmarineagency.com/blog/worlds-key-maritime-straits-chokepoints/", "Low",
  "Strait of Malacca", "singapore_hub", "54.9M t bunkers; 41.1M TEU transshipment (2024 records)", "port throughput", "2024", "MPA Singapore official", "Maritime and Port Authority of Singapore (MPA)", "https://www.mpa.gov.sg/media-centre/details/strong-growth-momentum-for-maritime-singapore", "High",
  "Strait of Malacca", "reroute_cost", "Sunda +1,086 nm/~43h; Lombok +2,488 nm/~98h", "vs Malacca", "2014", "At 25.5 kn", "RSIS Commentary CO12024", "https://www.rsis.edu.sg/wp-content/uploads/2014/07/CO12024.pdf", "Medium",

  # ---- Strait of Hormuz ----
  "Strait of Hormuz", "oil_transit", "20.9", "million b/d", "2025", "H1 2025", "U.S. EIA World Oil Transit Chokepoints", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints/", "High",
  "Strait of Hormuz", "oil_share", "~20 of global consumption; ~25 of seaborne oil", "%", "2025", "EIA / IEA", "IEA, Strait of Hormuz", "https://www.iea.org/about/oil-security-and-emergency-response/strait-of-hormuz", "High",
  "Strait of Hormuz", "lng_share", ">20", "% of global LNG trade", "2024", "11.4 Bcf/d", "U.S. EIA", "https://www.eia.gov/todayinenergy/detail.php?id=65584", "High",
  "Strait of Hormuz", "daily_transits", "~96 commercial vessels/day; ~21 tankers/day", "ships/day", "2024", "AIS-derived", "IMF PortWatch", "https://portwatch.imf.org/pages/data-and-methodology", "Medium",
  "Strait of Hormuz", "exporter_shares", "Saudi 37.2, Iraq 22.8, UAE 12.9, Iran 10.6, Kuwait 10.1", "% of crude via strait", "2024", "By exporter", "Visual Capitalist (EIA/Vortexa data)", "https://www.visualcapitalist.com/charted-oil-trade-through-the-strait-of-hormuz-by-country/", "Medium",
  "Strait of Hormuz", "bypass_capacity", "~3.5-5", "million b/d spare (Petroline, ADCOP)", "2025", "vs ~21 mb/d flow", "IEA, Strait of Hormuz", "https://www.iea.org/about/oil-security-and-emergency-response/strait-of-hormuz", "High",
  "Strait of Hormuz", "destination_share", "~89 of crude to Asia; China/India/Japan/S.Korea ~74", "%", "2025", "H1 2025", "U.S. EIA", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints/", "High",

  # ---- Strait of Bab el-Mandeb ----
  "Strait of Bab el-Mandeb", "weekly_transits", "459 (2023 baseline); 252 (2024, -48%)", "vessels/week", "2023", "AIS-derived", "IMF PortWatch (via Lloyd's List)", "https://www.lloydslistintelligence.com/resources/blog/bab-el-mandeb-transits-continue-to-decline-but-slight-uptick-for-suez-canal", "Medium",
  "Strait of Bab el-Mandeb", "oil_transit", "4.2 (H1 2025); 9.3 peak (2023)", "million b/d", "2025", "H1 2025", "U.S. EIA World Oil Transit Chokepoints", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints", "High",
  "Strait of Bab el-Mandeb", "share_world_trade", "~10-12 of world trade; ~30 of container traffic", "%", "2023", "Suez corridor", "UNCTAD", "https://unctad.org/publication/navigating-troubled-waters-impact-global-trade-disruption-shipping-routes-red-sea-black", "High",
  "Strait of Bab el-Mandeb", "crisis_impact", "Suez container tonnage -82%; Cape of Good Hope tonnage +60-89%", "2024 crisis", "2024", "Dec 2023 -> Feb 2024", "UNCTAD", "https://unctad.org/publication/navigating-troubled-waters-impact-global-trade-disruption-shipping-routes-red-sea-black", "High",
  "Strait of Bab el-Mandeb", "freight_rate", "+256", "% Shanghai-Europe", "2024", "Dec 2023 - late Jan 2024", "UNCTAD", "https://unctad.org/publication/navigating-troubled-waters-impact-global-trade-disruption-shipping-routes-red-sea-black", "High",
  "Strait of Bab el-Mandeb", "sumed_bypass", "2.5", "million b/d (SUMED pipeline)", "2024", "Suez-bound Gulf oil only", "U.S. EIA", "https://www.eia.gov/todayinenergy/detail.php?id=41073", "High",

  # ---- Turkish Straits ----
  "Turkish Straits", "annual_transits", ">45,000", "ships/yr", "2024", "All vessels, Bosphorus", "U.S. EIA World Oil Transit Chokepoints", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints", "High",
  "Turkish Straits", "oil_transit", "3.7 (straits); 3.3 (Bosphorus)", "million b/d", "2025", "H1 2025", "U.S. EIA World Oil Transit Chokepoints", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints", "High",
  "Turkish Straits", "share_world_trade", "~5", "% of global maritime trade", "2025", "H1 2025", "U.S. EIA", "https://www.eia.gov/international/content/analysis/special_topics/World_Oil_Transit_Chokepoints", "Medium",
  "Turkish Straits", "grain_share", "~30 wheat; ~75 sunflower oil (region)", "% of world exports", "2021", "Black Sea region (Russia + Ukraine)", "FAO / UN", "https://openknowledge.fao.org/server/api/core/bitstreams/6c9395e2-a199-4df5-a2f2-620e960512e0/content", "High",
  "Turkish Straits", "grain_initiative", "32.7", "million tonnes to 45 countries", "2023", "Jul 2022 - Jul 2023", "UNCTAD", "https://unctad.org/global-crisis/black-sea-initiative", "High",
  "Turkish Straits", "governance", "Montreux Convention (1936) - Turkiye regulates passage", "treaty", "1936", "Peacetime freedom of commercial passage", "Republic of Turkiye MFA", "https://www.mfa.gov.tr/implementation-of-the-montreux-convention.en.mfa", "High",

  # ---- Dover Strait ----
  "Dover Strait", "daily_transits", ">400 commercial/day; 500-600 all ships", "ships/day", "2024", "MCA; Guinness (1999)", "UK Maritime & Coastguard Agency (CNIS)", "https://www.gov.uk/government/publications/dover-strait-crossings-channel-navigation-information-service/dover-strait-crossings-channel-navigation-information-service-cnis", "High",
  "Dover Strait", "trade_value", "144 (Port of Dover) = 33% of UK-EU goods trade", "GBP bn", "2023", "Port of Dover throughput", "Port of Dover", "https://www.portofdover.com/news/port-of-dover-unveils-buoyant-results/", "High",
  "Dover Strait", "ferry_volumes", "8.9M passengers; 2.2M freight vehicles; 1.6M tourist vehicles", "per year", "2023", "Port of Dover official", "Port of Dover", "https://www.portofdover.com/news/port-of-dover-unveils-buoyant-results/", "High",
  "Dover Strait", "traffic_scheme", "IMO Traffic Separation Scheme (1967); 24h CNIS (UK+France)", "governance", "1967", "34 km at narrowest", "UK MCA (CNIS)", "https://www.gov.uk/government/publications/dover-strait-crossings-channel-navigation-information-service/dover-strait-crossings-channel-navigation-information-service-cnis", "High",

  # ---- Strait of Gibraltar ----
  "Strait of Gibraltar", "daily_transits", "~300 all vessels/day (~148 merchant)", "ships/day", "2024", "Attributed to Gibraltar Port Authority via aggregator", "ballastmarkets (secondary)", "https://content.ballastmarkets.com/chokepoints/strait-of-gibraltar/", "Low",
  "Strait of Gibraltar", "tanger_med_teu", "10.24", "million TEU", "2024", "+18.8% vs 2023; official", "Tanger Med Port Authority", "https://www.tangermedport.com/en/tanger-med-passes-the-10-million-container-mark/", "High",
  "Strait of Gibraltar", "algeciras_tonnage", "~104M t; 4.73M TEU", "port throughput", "2023", "Official (APBA)", "Autoridad Portuaria Bahia de Algeciras", "https://www.apba.es/noticias/traficos-2023-el-presidente-del-puerto-reclama-la-eliminacion-de-trabas-que-impiden-el-desarrollo-y-dificultan-su-competitividad", "High",
  "Strait of Gibraltar", "role", "Sole maritime gateway between the Mediterranean and the Atlantic (13 km at narrowest)", "geography", "2024", "No maritime bypass", "IMF PortWatch (context)", "https://portwatch.imf.org/pages/data-and-methodology", "High"
) |> as.data.frame(stringsAsFactors = FALSE)

stopifnot(all(chokepoint_sources$confidence %in% c("High", "Medium", "Low")),
          all(grepl("^https?://", chokepoint_sources$source_url)),
          all(chokepoint_sources$location %in% chokepoint_context$location))

readr::write_csv(chokepoint_context, "data-raw/chokepoint_context.csv")
readr::write_csv(chokepoint_sources, "data-raw/chokepoint_sources.csv")
cat("Wrote data-raw/chokepoint_context.csv (", nrow(chokepoint_context), " rows )\n")
cat("Wrote data-raw/chokepoint_sources.csv (", nrow(chokepoint_sources), " rows )\n")
