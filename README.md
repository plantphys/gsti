# Global_Vcmax

The code 0_transform_import_original_ACi_data.R aims to import the raw ACi files and to curate them in one dataframe called 'curated_data' and saved in the file '0_curated_data.Rdata'.
The colums of the dataframe must be: "SampleID", "Obs", "A", "Ci", "CO2s", "gsw", "Patm", "Qin", "RHs", "Tleaf" folowing the ESS standard (...).
The columns Obs is used to identify the points within the ACi curves and help to remove erroneous measurements.


##List of datasets
| Reference | Species | Location | Year |
| --- | --- | ---|---|
| Barnes et al. 2017 | Hybrid poplar |Arizona, USA| 2013|
| Albert et al. 2018 | Tropical species | Brazil|2012 - 2013 - 2015|
| Wu et al. 2019 | Tropical species | Panama|2016 - 2017|
| Lamour et al. 2021 | Tropical species | Panama | 2021 |



## References
Barnes ML, Breshears DD, Law DJ, Leeuwen WJD van, Monson RK, Fojtik AC, Barron-Gafford GA, Moore DJP. 2017. Beyond greenness: Detecting temporal changes in photosynthetic capacity with hyperspectral reflectance data. PLOS ONE 12: e0189539.

Albert LP, Wu J, Prohaska N, Camargo PB de, Huxman TE, Tribuzy ES, Ivanov VY, Oliveira RS, Garcia S, Smith MN, et al. 2018. Age-dependent leaf physiology and consequences for crown-scale carbon uptake during the dry season in an Amazon evergreen forest. New Phytologist 219: 870–884.

Wu J, Rogers A, Albert LP, Ely K, Prohaska N, Wolfe BT, Oliveira RC, Saleska SR, Serbin SP. 2019. Leaf reflectance spectroscopy captures variation in carboxylation capacity across species, canopy environment and leaf age in lowland moist tropical forests. New Phytologist 224: 663–674.