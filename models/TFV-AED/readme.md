# Lake Erie WQ Model
## 3D Finite Volume Aquatic Ecosystem Model

---
### Overview

The PHERM (Peel-Harvey Estuary Response Model) consists of a 3D hydrodynamic model TUFLOW-FV (BMT WBM, 2013), which is dynamically coupled with the AED2 water quality model to simulate the nutrient cycling and key biogeochemical processes. TUFLOW-FV is a 3D flexible-mesh (finite volume) hydrodynamic model that accounts for variations in water level, horizontal salinity distribution and vertical density stratification in response to tides, inflows and surface thermodynamics. The mesh consists of triangular and quadrilateral elements of different size that are suited to simulating areas of complex estuarine morphometry. To meet accuracy requirements, a fine-grid resolution (mean mesh area ~12000 m2) was used within the lagoons and coarse resolution was implemented towards the ocean boundary (Figure 1). Surface momentum exchange and heat dynamics are solved internally within TUFLOW-FV. In the current application, turbulent mixing of momentum and scalars has been calculated using the Smagorinsky scheme in the horizontal plane and through coupling with the General Ocean Turbulence Model (GOTM) for vertical mixing with option of second-order k-ε turbulence closure. The bottom shear stress was calculated using a roughness-length relationship assuming a rough-turbulent logarithmic velocity profile in the lowest model layer. The roughness length z0 settings were based on the area type (e.g. coast, rivers, and estuary) and the estimated biomass of aquatic vegetation within the estuary.


<img src="https://github.com/AquaticEcoDynamics/Peel_ARC/blob/master/Images/mesh2.png">

**Figure 1. PHERM modelling domain and mesh overview.**


The AED2 water quality modules were configured to simulate the C, N, P, and DO budgets, including resolving the inorganic nutrients and organic matter fractions, and primary production (Table 1; Figure 2). Spatial variation and sediment quality and benthic properties (including biomass of seagrass, macroalgae and bivalves) was also included.
Key modelled chemical and biological processes include:
-	Water column kinetic (time-varying) chemical / biological transformations (e.g., denitrification or algal growth)
-	Water column equilibrium (instantaneous) chemical transformations (e.g., PO4 adsorption)
-	Vertical sedimentation or migration
-	Biogeochemical transformations in the sediment or biological changes in the benthos
-	Fluxes across the air-water interface
-	Fluxes across the sediment-water interface
-	Feedback of chemical or biological attributes to physical properties of water (light extinction, drag, density)

<img src="https://github.com/AquaticEcoDynamics/Peel_ARC/blob/master/Images/AED.png">

**Figure 2. AED water quality model diagram summarising interactions captured with the PHERM.**

### Model Software

Hydrodynamic platform: TUFLOW-FV, http://tuflow.com/FV%20Documentation.aspx 

Water quality model: AED2, http://aed.see.uwa.edu.au/research/models/AED/index.html  

### Input Data

The data necessary to simulate estuarine dynamics comprise boundary conditions at incoming rivers and ocean and meteorological forcing. PHE received runoff from the catchment through multiple gauged rivers and ungauged drains, in which the Murray River contributes about 41% of the total inflows and Serpentine River and Harvey River contribute about 10% and 23%, respectively, of the total inflows. Gauged flow rate data for the Murray River was available from 1970 to the present, while data for the Serpentine River and Harvey River was available from 1982 to the present. These gauged datasets were applied to the hydrodynamic model whenever they are available. For the missing periods in the gauged flows and the ungauged drains, the output from the Streamflow Quality Affecting Rivers and Estuaries (SQUARE) catchment model, operated by the Western Australia Department of Water and Environmental Regulation (Kelsey et al., 2011), was used to estimate flows by carefully comparing the measured and modelled flow data. The open sea boundary forcing was set using the sea level observation data taken in the Fremantle port, located ~50 km to the north of the PHE.

The model required meteorological inputs, including wind speed, solar radiation, air temperature, cloud cover, and relative humidity, for surface heat and momentum exchange calculations. Various data sources were used to set up meteorological inputs due to the study period spanning a long time back to 1970, when meteorological observations were not routinely available across the modelling domain at hourly frequencies. The first data source is the local Mandurah weather station located beside the natural channel of the estuary. This dataset provides hourly records since 2001. The hourly fields over the period 1981-2000 were obtained from regional climate model simulations for Southwest Australia at a 5 km resolution (Andrys et al., 2015, 2016; Kala et al., 2014). These simulations were carried out using the Weather Research and Forecasting (WRF), one of the most widely used climate models. Andrys et al. (2015) showed that the WRF model was able to adequately simulate the climate of SWA, and these simulations have also been used to assess the impacts of current and future climate on viticulture for SWA (Firth et al., 2017). For the years before 1981 the weather conditions measured at the nearby Halls Head weather station (4.2 km away from the Mandurah station) were used.

The sediment was separated into 24 zones based on their properties (sand/silt composition and N/P contents) based on the survey data presented in (Sed CHapter). Water quality in the inflow waters were set based on the raw or daily infilled data from WIR, or from the catchment model (Hennig et al 2019) where no gauged data was available. 

### Outputs

The key modes output variables are summarized in Table 1.

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 width="67%"
 style='width:67.54%;border-collapse:collapse;border:none;mso-border-alt:solid windowtext .5pt;
 mso-padding-alt:0cm 5.4pt 0cm 5.4pt;mso-border-insideh:.5pt solid windowtext;
 mso-border-insidev:.5pt solid windowtext'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td width="10%" valign=top style='width:10.42%;border:solid windowtext 1.0pt;
  border-right:none;mso-border-top-alt:solid windowtext .5pt;mso-border-left-alt:
  solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;background:
  black;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:6.0pt;color:white'>Variable<o:p></o:p></span></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border-top:solid windowtext 1.0pt;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:none;
  mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;
  background:black;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:6.0pt;color:white'>Units *<o:p></o:p></span></b></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border-top:solid windowtext 1.0pt;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:none;
  mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;
  background:black;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:6.0pt;color:white'>Common Name<o:p></o:p></span></b></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:solid windowtext 1.0pt;
  border-left:none;mso-border-top-alt:solid windowtext .5pt;mso-border-bottom-alt:
  solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;background:
  black;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><span style='font-size:6.0pt;color:white'>Process Description<i
  style='mso-bidi-font-style:normal'><o:p></o:p></i></span></b></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td width="100%" colspan=4 valign=top style='width:100.0%;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-top-alt:solid windowtext .5pt;mso-border-top-alt:solid windowtext .5pt;
  mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:
  242;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt;
  color:black;mso-color-alt:windowtext'>Physical variables</span><span
  style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>T<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>°C<o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Temperature<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Temperature
  modelled by hydrodynamic model, subject to surface heating and cooling
  processes <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>S</span></i></b><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'><o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>psu</span></span><span style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Salinity<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Salinity
  simulated by TUFLOW-FV, impacting density. Subject to inputs and <span
  class=SpellE>evapo</span>-concentration<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt'>EC<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>uS</span></span><span style='font-size:6.0pt'> <span
  class=GramE>cm<sup>-1</sup></span><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Electrical
  conductivity<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Derived
  from salinity variable<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>I<sub>PAR</sub><o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>mE</span></span><span style='font-size:6.0pt'> m<sup>-2</sup>
  s<sup>-1</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Shortwave
  light intensity<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Incident
  light, I<sub>0</sub>, is attenuated as a function of depth<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>I<sub>UV</sub></span></i></b><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'><o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>mE</span></span><span style='font-size:6.0pt'> m<sup>-2</sup>
  s<sup>-1</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Shortwave
  light intensity<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Incident
  light, I<sub>0</sub>, is attenuated as a function of depth<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt;font-family:Symbol;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-char-type:symbol;mso-symbol-font-family:
  Symbol'><span style='mso-char-type:symbol;mso-symbol-font-family:Symbol'>h</span></span></i><i
  style='mso-bidi-font-style:normal'><sub><span style='font-size:6.0pt'>PAR</span></sub></i><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'><o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>m<sup>-1</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>PAR
  extinction coefficient<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Extinction
  coefficient is computed based on organic matter and suspended solids <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt;font-family:Symbol;mso-ascii-font-family:
  Calibri;mso-ascii-theme-font:minor-latin;mso-hansi-font-family:Calibri;
  mso-hansi-theme-font:minor-latin;mso-char-type:symbol;mso-symbol-font-family:
  Symbol'><span style='mso-char-type:symbol;mso-symbol-font-family:Symbol'>h</span></span></i><i
  style='mso-bidi-font-style:normal'><sub><span style='font-size:6.0pt'>UV</span></sub></i><b
  style='mso-bidi-font-weight:normal'><i style='mso-bidi-font-style:normal'><span
  style='font-size:6.0pt'><o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>m<sup>-1</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>UV
  extinction coefficient<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Extinction
  coefficient is computed based on organic matter and suspended solids <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:9.05pt'>
  <td width="100%" colspan=4 valign=top style='width:100.0%;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:
  242;padding:0cm 5.4pt 0cm 5.4pt;height:9.05pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt;
  color:black;mso-color-alt:windowtext'>Core biogeochemical variables </span><span
  style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DO<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  O<sub>2</sub> m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Dissolved
  oxygen<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Impacted
  by photosynthesis, organic decomposition, nitrification, surface exchange, and
  sediment oxygen demand<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><b
  style='mso-bidi-font-weight:normal'><i style='mso-bidi-font-style:normal'><span
  style='font-size:6.0pt'>RSi</span></i></b></span><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'><o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  Si m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Reactive
  Silica<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Algal
  uptake, sediment flux<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>FRP<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  P m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Filterable
  reactive phosphorus<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Algal
  uptake, organic mineralization, sediment flux<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>PIP<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  P m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Particulate
  inorganic phosphorus<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>Adsoprtion</span></span><span style='font-size:6.0pt'>/desorption
  of/to free FRP<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>NH<sub>4</sub><sup>+</sup><o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Ammonium<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Algal
  uptake, nitrification, organic mineralization, sediment flux<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>NO<sub>3</sub><sup>-</sup><o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Nitrate<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Algal
  uptake, nitrification, denitrification, sediment flux<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:16'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>CPOM<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Coarse
  particulate organic matter <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Enzymatic
  hydrolysis to POM<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:17'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DOC-R<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Refractory
  DOC<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:18'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DON-R<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Refractory
  DON<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:19'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DOP-R<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Refractory
  DOP<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:20'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DOC<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Dissolved
  organic carbon <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Mineralization,
  algal mortality/excretion<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DON<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Dissolved
  organic nitrogen <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=GramE><span
  style='font-size:6.0pt'>Mineralization ,</span></span><span style='font-size:
  6.0pt'> algal mortality/excretion <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:22'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DOP<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  P m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Dissolved
  organic phosphorus <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Mineralization,
  algal mortality/excretion<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>POC<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Particulate
  organic carbon <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Breakdown,
  settling, algal mortality/excretion<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:24'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>PON<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Particulate
  organic nitrogen <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Breakdown,
  settling, algal mortality/excretion <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:25'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>POP<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  P m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Particulate
  organic phosphorus <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Breakdown,
  settling, algal mortality/excretion<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:26'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt'>TP<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  P m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Total
  Phosphorus<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Sum
  of all P state variables<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:27'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt'>TN<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Total
  Nitrogen<sub><o:p></o:p></sub></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><span style='font-size:6.0pt'>Sum of all N state
  variables<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:28'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt'>TKN<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  N m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Total
  <span class=SpellE>Kjedahl</span> Nitrogen<sub><o:p></o:p></sub></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><span style='font-size:6.0pt'>Sum of all N state
  variables<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:29'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><i style='mso-bidi-font-style:
  normal'><span style='font-size:6.0pt'>CDOM<o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>Chromophoric</span></span><span style='font-size:
  6.0pt'> Dissolved Organic Matter<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><span style='font-size:6.0pt'>Related from DOC-R and
  DOC concentrations<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:30'>
  <td width="100%" colspan=4 valign=top style='width:100.0%;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:
  242;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><span style='font-size:6.0pt;color:black;mso-color-alt:
  windowtext'>Plankton groups (optional)</span><span style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:31'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><b style='mso-bidi-font-weight:
  normal'><i style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>BGA<sup><o:p></o:p></sup></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Cyanobacteria
  <o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:32'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>GRN<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Green<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:33'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DIA</span></i></b><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'><o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Diatom<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:34'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>DINO<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Dinoflagellate<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:35'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>Crypt<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span class=SpellE><span
  style='font-size:6.0pt'>Cryptophytes</span></span><span style='font-size:
  6.0pt'><o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:36'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><i style='mso-bidi-font-style:normal'><span
  style='font-size:6.0pt'>TCHLA<b style='mso-bidi-font-weight:normal'><o:p></o:p></b></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Total
  Chlorophyll-a<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:37'>
  <td width="100%" colspan=4 valign=top style='width:100.0%;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:
  242;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt;
  color:black;mso-color-alt:windowtext'>Sediment and related properties</span><span
  style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:38'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>SS<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>g
  SS m<sup>-3</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:39'>
  <td width="10%" valign=top style='width:10.42%;border:none;border-left:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><i style='mso-bidi-font-style:normal'><span
  style='font-size:6.0pt'>Turbidity<o:p></o:p></span></i></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>NTU<o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border:none;border-right:solid windowtext 1.0pt;
  mso-border-right-alt:solid windowtext .5pt;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:40'>
  <td width="100%" colspan=4 valign=top style='width:100.0%;border-top:none;
  border-left:solid windowtext 1.0pt;border-bottom:none;border-right:solid windowtext 1.0pt;
  mso-border-left-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  background:#F2F2F2;mso-background-themecolor:background1;mso-background-themeshade:
  242;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt;
  color:black;mso-color-alt:windowtext'>Benthic variables</span><span
  style='font-size:6.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:41;mso-yfti-lastrow:yes'>
  <td width="10%" valign=top style='width:10.42%;border-top:none;border-left:
  solid windowtext 1.0pt;border-bottom:solid windowtext 1.0pt;border-right:
  none;mso-border-left-alt:solid windowtext .5pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoCommentText><b style='mso-bidi-font-weight:normal'><i
  style='mso-bidi-font-style:normal'><span style='font-size:6.0pt'>MPB<o:p></o:p></span></i></b></p>
  </td>
  <td width="13%" valign=top style='width:13.14%;border:none;border-bottom:
  solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>mmol
  C m<sup>-2</sup><o:p></o:p></span></p>
  </td>
  <td width="34%" valign=top style='width:34.12%;border:none;border-bottom:
  solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Benthic
  algae<o:p></o:p></span></p>
  </td>
  <td width="42%" valign=top style='width:42.32%;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  mso-border-bottom-alt:solid windowtext .5pt;mso-border-right-alt:solid windowtext .5pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='line-height:normal'><span style='font-size:6.0pt'>Benthic
  photosynthesis &amp; respiration.<o:p></o:p></span></p>
  </td>
 </tr>
</table>

**Table 1: Summary of the relevant variables resolved by the proposed GLM – and TUFLOW-FV – AED2 platform. Note some of the variables are optional and to be determined depending on the modules chosen within the AED2 water quality model.**  

### Documents & Links

The <a href="https://www.tuflow.com/Tuflow%20FV.aspx">Tuflow-FV model</a> is produce by BMT. The 2019 version of their software can be optained by containing their <a href="https://www.tuflow.com/Contact.aspx">sales team.</a>

TUFLOW-FV science manual: http://tuflow.com/Download/TUFLOW_FV/Manual/FV_Science_Manual_2013.pdf 
TUFLOW-FV user manual: http://tuflow.com/Download/TUFLOW_FV/Manual/FV%20User%20Manual%202019.01.pdf



AED2 model website: http://aed.see.uwa.edu.au/research/models/AED/index.html 

The AED2 Biogeochemistry model can be obtained from the details below:

-	AED2 1.3.0 (Hipsey et al., 2019a): available at https://zenodo.org/record/2538495#.XJzufy1L1R4 
-	AED2+ 1.3.0 (available on request and required for bivalves, macroalgae and seddiagenesis modules).

