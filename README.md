# Global Spectra-Trait Initiative (GSTI)

Welcome to the Global Spectra-Trait Initiative (GSTI)! The aim of this project is to generate a PLSR model able to predict the maximum carboxylation capacity (Vcmax25) of leaves from multiple species and biomes using full range reflectance data.

To do so, we curate and combine ACi datasets that are linked to full range reflectancce data (500 to 2400 nm). The A-Ci data are fitted using the same procedure and the same model to avoid including biases between datasets if they were fitted using multiple methods.

An overview of the process to curate the datasets is given in the pdf: [Curation workflow](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Overal_data_curation.pdf). The curation is divided in 4 steps (0 to 3) to import, analyse and produce a dataset with a determined format. Since all datasets are different, the code can be adapted for any of the steps but the data format have to be similar so all the datasets can be, in the end, combined. A guide to add a dataset is given here: [Guide](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Vignettes/How_to_add_a_dataset.md). Please, don't hesitate to contact us when you add your dataset by submitting an "issue" on github or by sending us an email.

The project utilizes the data and metadata formatting recommendations presented in the [Leaf-level gas exchange data and metadata reporting format](https://github.com/ess-dive-community/essdive-leaf-gas-exchange) (Ely et al, 2021). Data contributors are welcome to submit metadata that describes data collection protocols using the [methods metadata template] (https://github.com/ess-dive-community/essdive-leaf-gas-exchange/blob/master/templates/methodsMetadataTemplate.xlsx).

The A-Ci fitting is based on the FvCB model of photosynthesis (Farquhar et al. 1980), as implemented and parametrized in CLM4.5, and detailed here: [FvCB equations and parametrization](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/FvCB%20equations%20parameters%20and%20fitting%20procedures.docx).

The PLSR modeling approach is based on the best-practice guide by Burnett et al. (2021). An example of fitting is given here: [PLSR](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/PLSR/Validation_Alldatasets_2022-09-19.pdf)

## References

Burnett AC, Anderson J, Davidson KJ, Ely KS, Lamour J, Li Q, Morrison BD, Yang D, Rogers A, Serbin SP. A best-practice guide to predicting plant traits from leaf-level hyperspectral data using partial least squares regression. J Exp Bot. 2021 Sep 30;72(18):6175-6189. doi: 10.1093/jxb/erab295. PMID: 34131723.

Ely KS, Rogers A, Agarwal DA, Ainsworth EA, Albert LP, Ali A, et al. A reporting format for leaf-level gas exchange data and metadata. Ecol Inform. 2021;61: 101232. doi:10.1016/j.ecoinf.2021.101232

Farquhar, G.D., von Caemmerer, S. & Berry, J.A. A biochemical model of photosynthetic CO2 assimilation in leaves of C3 species. Planta 149, 78–90 (1980). https://doi.org/10.1007/BF00386231


## Map of identified datasets

<img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Map_datasets.png" width="800">

## Overview of the combined dataset and performance of the PLSR model
<img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Hist_Vcmax25.jpeg" width="400"> <img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Reflectance.jpeg" width="400">

<br>

### Validation of the PLSR model on the validation dataset which comprises 20 % of the observation of each individual datasets

<br>

<img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/PLSR/Validation_random.jpeg" width="600">

<br>
<br>

### Validation of the PLSR model using successively each dataset as a validation dataset

<br>

<img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/PLSR/Validation_datasets.jpeg" width="600">

<br>
<br>

### List of species and number of observations
<img src="https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Leaf_per_species.jpeg" width="400"> 
