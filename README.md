# Global Spectra-Trait Initiative (GSTI)

Welcome to the Global Spectra-Trait Initiative (GSTI). 

This project aims to generate spectra trait models using reflectance data to predict leaf traits associated with the photosynthesis capacity of leaves. This includes the maximum carboxylation rate of rubisco (Vcmax), the maximum electron transport rate (Jmax), the dark respiration, as well as the prediction of leaf nitrogen, leaf mass per area (LMA), and leaf water content (LWC). We aim to gather datasets from multiple species and biomes worldwide to build generalizable spectra trait models.

If you want to participate, please email us or submit an issue in this GitHub repository. We welcome raw A-Ci data, dark-adapted respiration data as well as other structural and chemical leaf traits in a free format, and of course leaf reflectance data (ideally full range from 500 nm to 2400 nm).

Details on the processing chain to import, homogenize, and produce a standardized database from multiple datasets are given in this guide: [Guide](https://github.com/plantphys/gsti/wiki/Dataset-creation-guide). 

The project utilizes the data and metadata formatting recommendations presented in the [Leaf-level gas exchange data and metadata reporting format](https://github.com/ess-dive-community/essdive-leaf-gas-exchange) (Ely et al, 2021).

The A-Ci fitting is based on the FvCB model of photosynthesis (Farquhar et al. 1980), as implemented and parametrized in CLM4.5, and detailed here: [FvCB equations and parametrization](https://github.com/plantphys/gsti/blob/main/Documentation/FvCB_equations_parameters_and_fitting_procedures.pdf).

## Principles and general information
Only free use data ([CC BY 4](https://creativecommons.org/licenses/by/4.0/)) accepted. GSTI is not designed to be, and should not be treated as a permanent data repository. It is a community resource of standardized spectra-trait datasets to facilitate a living set of algorithms that researchers can use to predict a host of leaf traits using spectral measurements. It is not an institutionally-backed repository like [Figshare](https://figshare.com/), [DataONE](https://www.dataone.org/), [ESS-DIVE](https://ess-dive.lbl.gov/), etc. We recommend (but not require) depositing your data in one of these first and providing its DOI in your dataset metadata.

## Overview of the database

The raw datasets are stored in individual folders [Datasets](https://github.com/plantphys/gsti/tree/main/Datasets).

The curated GSTI database is available here [Database](https://github.com/plantphys/gsti/tree/main/Database).

<img src="https://github.com/plantphys/gsti/blob/main/Outputs/Map_datasets.png" width="742">

<img src="https://github.com/plantphys/gsti/blob/main/Outputs/Hist_values_GSTI.jpeg" height="800">

<img src="https://github.com/plantphys/gsti/blob/main/Outputs/Number_observations.jpeg" height="500"> 

[List of Species](https://github.com/plantphys/gsti/blob/main/Outputs/Leaf_per_species.jpeg)

Examples of generalized spectra trait models for the prediction of Vcmax25, Jmax25, and Rdark25 using the GSTI database are presented here: [Spectra trait models](https://github.com/plantphys/gsti/blob/main/Outputs/Results_PLSR.jpeg). These models were obtained using partial least squares regressions following Burnett et al.'s 2021 best practices.

## Database citation
More information soon

## References

Burnett, A.C., Anderson, J., Davidson, K.J., Ely, K.S., Lamour, J., Li, Q., Morrison, B.D., Yang, D., Rogers, A. and Serbin, S.P., 2021. A best-practice guide to predicting plant traits from leaf-level hyperspectral data using partial least squares regression. Journal of Experimental Botany, 72(18), pp.6175-6189.

Ely KS, Rogers A, Agarwal DA, Ainsworth EA, Albert LP, Ali A, et al. A reporting format for leaf-level gas exchange data and metadata. Ecol Inform. 2021;61: 101232. https:doi.org/10.1016/j.ecoinf.2021.101232

Farquhar, G.D., von Caemmerer, S. & Berry, J.A. A biochemical model of photosynthetic CO2 assimilation in leaves of C3 species. Planta 149, 78–90 (1980). https://doi.org/10.1007/BF00386231

