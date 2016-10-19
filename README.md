# Market entry 

This repository presents different scripts for static market entry analysis. It is applied to the care homes sector in the UK. The dataset for the analysis consists of a register of care homes in the [Care Quality Commission](http://www.cqc.org.uk) . This dataset includes care homes registries from 2010 to February 2016. 

Besides the data, the repository also includes various files that show the creation of both the dependent and independent variables used in the model as well as the files used for the econometric analysis

  - `active.xlsx`: Data with th register of care homes.
  - `entries_2016_08.R`: script for the calculation of entry rates.

Entries are the dependent variable of the model. They are calculated according to the typical formula on the literature where entry rates are expressed as the number of entries in the a period divided by the incumbents in the latter period. 

  - `geocode.R`: script showing the geocode of postal codes.

This script provides information about the process for geo-referencing the units of analysis in the model. Geo-coding varibles is an important part for the calculation of potential elements of interest such as the distances or the closer neighbours to the units of analysis in the model. Also geo-referenced units are important for geographic data visualisations. Data used correspond to the [ONS postcode directory](https://data.gov.uk/dataset/ons-postcode-directory-uk-feb-2016)

  - `imd.R`: script for linking data referred to the index of multiple deprivation.
  - `imd2015.csv`:  dataset corresponding to the multiple deprivation index for 2015. 
 
[Deprivation](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/464430/English_Index_of_Multiple_Deprivation_2015_-_Guidance.pdf) indices are measures associated with the deprivation levels referred to [Super Output Areas](http://webarchive.nationalarchives.gov.uk/20160105160709/http://www.ons.gov.uk/ons/guide-method/geography/beginner-s-guide/census/super-output-areas--soas-/index.html) areas in England. 


  - `expertise.R`: script for calculating the number of experts in the market. 

Experts are those providers that operate in more than 1 market (_experts_) or 10 markets (_experts2_). It is a measure to understand the density and type of firms in the market.

 - `average.prices.R`: script for obtaining the average price of houses associated with the postcodes. 

Home average prices characterize the market. Data for home prices corresponds to the [price paid data](https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads) released by the [Land Regsitry](https://www.gov.uk/government/organisations/land-registry). I calculate average prices for each month considering the [postcode sector](https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Postcode_sector) for each month. 

  - `home_prices.R`: scripts for linking home prices to the information referred to the registry of care homes.
  - `demographics.R`: scripts for linking demographic information associated with the type of population. 

Data are extracted from the Census (2011) and the Department of Work and Pensions ([DWP](https://www.gov.uk/government/organisations/department-for-work-pensions/about/statistics)). I use data on unemployment and benefits. 

  - `HHI_year`: calculation of the HHI index for sample of time intervals based on years.
  - `HHI_wave2`: calculation of the HHI index for sample of time intervals based on two years.
 
HHI is a concentration index to analyse the competition in the market. 
 
 - `Analysis`: configuration of the samples of analysis. Each sample corresponds to a different time interval. 
 
  
  
  


