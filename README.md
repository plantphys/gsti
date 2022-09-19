# Global_Vcmax

The aim of this project is to generate a global PLSR model for Vcmax25 prediction from full range reflectance data.

To do so, we curate and combine ACi datasets that are linked to full range reflectancce data (350 or 400 to 2400 or 2500 nm). The A-Ci data are fitted using the same procedure and the same model to avoid including biases between datasets if they were fitted using multiple methods.

An overview of the process to curate the datasets is given in the pdf: [Curation workflow](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/Overal_data_curation.pdf). The curation is divided in 4 steps (0 to 3) to import, analyse and produce and dataset with a determined format. Since all datasets are different, the code can be adapted for any of the steps but the format have to be similar so all the datasets can be, in the end, combined.

The A-Ci fitting is based on the FvCB model of photosynthesis (Farquhar et al. 1980), as implemented and parametrized in FATES terrestrial biosphere model (Fisher et al. 2015, Koven et al. 2020).

The PLSR modeling approach is based on the best-practice guide by Burnett et al. (2021). An example of fitting is given here: [PLSR](https://github.com/TESTgroup-BNL/Global_Vcmax/blob/main/PLSR/Validation_Alldatasets%202021-11-04.pdf)

## References

Burnett AC, Anderson J, Davidson KJ, Ely KS, Lamour J, Li Q, Morrison BD, Yang D, Rogers A, Serbin SP. A best-practice guide to predicting plant traits from leaf-level hyperspectral data using partial least squares regression. J Exp Bot. 2021 Sep 30;72(18):6175-6189. doi: 10.1093/jxb/erab295. PMID: 34131723.

Farquhar, G.D., von Caemmerer, S. & Berry, J.A. A biochemical model of photosynthetic CO2 assimilation in leaves of C3 species. Planta 149, 78–90 (1980). https://doi.org/10.1007/BF00386231

Fisher, R. A., Muszala, S., Verteinstein, M., Lawrence, P., Xu, C., McDowell, N. G., Knox, R. G., Koven, C., Holm, J., Rogers, B. M., Spessa, A., Lawrence, D., and Bonan, G.: Taking off the training wheels: the properties of a dynamic vegetation model without climate envelopes, CLM4.5(ED), 8, 3593–3619, https://doi.org/10.5194/gmd-8-3593-2015, 2015.

Koven, C. D., Knox, R. G., Fisher, R. A., Fisher, R. A., Chambers, J. Q., Chambers, J. Q., Christoffersen, B. O., Davies, S. J., Detto, M., Detto, M., Dietze, M. C., Faybishenko, B., Holm, J., Huang, M., Kovenock, M., Kueppers, L. M., Kueppers, L. M., Lemieux, G., Massoud, E., McDowell, N. G., Muller-Landau, H. C., Muller-Landau, H. C., Needham, J. F., Norby, R. J., Powell, T., Rogers, A., Serbin, S. P., Shuman, J. K., Swann, A. L. S., Swann, A. L. S., Varadharajan, C., Walker, A. P., Joseph Wright, S., and Xu, C.: Benchmarking and parameter sensitivity of physiological and vegetation dynamics using the Functionally Assembled Terrestrial Ecosystem Simulator (FATES) at Barro Colorado Island, Panama, 17, 3017–3044, https://doi.org/10.5194/bg-17-3017-2020, 2020.

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
