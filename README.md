# Market entry 

This repository presents different scripts for static market entry analysis. It is applied to the care homes sector in the UK. The dataset for the analysis consists of a register of care homes in the [Care Quality Commission](http://www.cqc.org.uk) . This dataset includes care homes registries from 2010 to February 2016. 

Besides the data, the repository also includes various files that show the creation of both the dependent and independent variables used in the model as well as the files used for the econometric analysis

  - `active.xlsx`: Data with th register of care homes.
  - `entries_2016_08.R`: script for the calculation of entry rates.

Entries are the dependent variable of the model. They are calculated according to the typical formula on the literature where entry rates are expressed as the number of entries in the a period divided by the incumbents in the latter period. 

  - `geocode.R`: script showing the geocode of postal codes.

This script provides information about the process for geo-referencing the units of analysis in the model. This process is important for the calculation of potential elements of interest such as the distances or the closer neighbours to the unit of analysis in the model. Also geo-referenced units are important for geographic data visualisations.

  - `imd.R`: script for linkin data referred to multiple deprivation index.
 
Deprivation index is a measure of the deprivation levels associated to [Super Output Areas](http://webarchive.nationalarchives.gov.uk/20160105160709/http://www.ons.gov.uk/ons/guide-method/geography/beginner-s-guide/census/super-output-areas--soas-/index.html) areas in England. 
  
  
  


