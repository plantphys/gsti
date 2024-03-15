# Global Spectra-Trait Initiative (GSTI)

Welcome to the Global Spectra-Trait Initiative (GSTI). 

The aim of this project is to generate PLSR models using full range reflectance data for the prediction of leaf traits associated with the photosynthesis capacity of leaves. This includes the maximum carboxylation rate of rubisco (Vcmax), the maximum electron transport rate (Jmax), the dark respiration, as well as the prediction of leaf nitrogen, leaf mass per area (LMA), and leaf water content (LWC). Our aim is to gather datasets from multiple species and biomes over the world in order to build generalizable spectra trait models.

If you want to participate, please send us an email or submit an issue in this github repository. We welcome raw A-Ci data, dark adapted respiration data as well as other structural and chemical leaf traits in a free format, and of course leaf reflectance data (ideally full range from 500 nm to 2400 nm). An overview of the data curation workflow that we follow is presented here: [Curation workflow](https://github.com/TESTgroup-BNL/gsti/blob/main/Documentation/Overal_data_curation.pdf). It also details the data that is required to participate in the project. 

More details on the processing chain to import, homogenise and produce a standardized database from multiple datasets are given in this guide: [Guide](https://github.com/TESTgroup-BNL/gsti/blob/main/Vignettes/How_to_add_a_dataset.md).

The project utilizes the data and metadata formatting recommendations presented in the [Leaf-level gas exchange data and metadata reporting format](https://github.com/ess-dive-community/essdive-leaf-gas-exchange) (Ely et al, 2021). Data contributors are welcome to submit metadata that describes data collection protocols using the [methods metadata template](https://github.com/ess-dive-community/essdive-leaf-gas-exchange/blob/master/templates/methodsMetadataTemplate.xlsx).

The A-Ci fitting is based on the FvCB model of photosynthesis (Farquhar et al. 1980), as implemented and parametrized in CLM4.5, and detailed here: [FvCB equations and parametrization](https://github.com/TESTgroup-BNL/gsti/blob/main/Documentation/FvCB%20equations%20parameters%20and%20fitting%20procedures.docx).

The PLSR modeling approach is based on the best-practice guide by Burnett et al. (2021). An example of fitting is given here: [PLSR](https://github.com/TESTgroup-BNL/gsti/blob/main/PLSR/Validation_Alldatasets_2022-09-19.pdf)

## Principles and general information
Only free use data ([CC BY 4](https://creativecommons.org/licenses/by/4.0/)) accepted. We request that users cite the Zenodo DOI for this repository, and strongly encourage them to (i) cite all dataset primary publications, and (ii) involve data contributors as co-authors when possible.

All data contributors will be included on an introductory paper planned for 2023.

GSTI is not designed to be, and should not be treated as, a permanent data repository. It is a community resource of standardized spectra-trait datasets to facilitate a living set of algorithms that can be used by researchers to predict a host of leaf traits using spectral measurements. It is not an institutionally-backed repository like [Figshare](https://figshare.com/), [DataONE](https://www.dataone.org/), [ESS-DIVE](https://ess-dive.lbl.gov/), etc. We recommend (but not require) depositing your data in one of these first, and providing its DOI in your dataset metadata.

## References

Burnett AC, Anderson J, Davidson KJ, Ely KS, Lamour J, Li Q, Morrison BD, Yang D, Rogers A, Serbin SP. A best-practice guide to predicting plant traits from leaf-level hyperspectral data using partial least squares regression. J Exp Bot. 2021 Sep 30;72(18):6175-6189. doi: 10.1093/jxb/erab295. PMID: 34131723.

Ely KS, Rogers A, Agarwal DA, Ainsworth EA, Albert LP, Ali A, et al. A reporting format for leaf-level gas exchange data and metadata. Ecol Inform. 2021;61: 101232. https:doi.org/10.1016/j.ecoinf.2021.101232

Farquhar, G.D., von Caemmerer, S. & Berry, J.A. A biochemical model of photosynthetic CO2 assimilation in leaves of C3 species. Planta 149, 78–90 (1980). https://doi.org/10.1007/BF00386231


# Overview of the database
<img src="https://github.com/TESTgroup-BNL/gsti/blob/main/Map_datasets.png" width="800">

<img src="https://github.com/TESTgroup-BNL/gsti/blob/main/Hist_Vcmax25.jpeg" width="400"> 

<br>
<img src="https://github.com/TESTgroup-BNL/gsti/blob/main/Leaf_per_species.jpeg" width="400"> 
