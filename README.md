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

## Article citation

This repository contains the data and code associated with the paper titled “The Global Spectra-Trait Initiative: A database of paired leaf spectroscopy and functional traits associated with leaf photosynthetic capacity”. Cite this paper when referring to the data, methodology, or findings of this study.

Lamour, J., Serbin, S. P., Rogers, A., Acebron, K. T., Ainsworth, E., Albert, L. P., Alonzo, M., Anderson, J., Atkin, O. K., Barbier, N., Barnes, M. L., Bernacchi, C. J., Besson, N., Burnett, A. C., Caplan, J. S., Chave, J., Cheesman, A. W., Clocher, I., Coast, O., Coste, S., Croft, H., Cui, B., Dauvissat, C., Davidson, K. J., Doughty, C., Ely, K. S., Evans, J. R., Féret, J.-B., Filella, I., Fortunel, C., Fu, P., Furbank, R. T., Garcia, M., Gimenez, B. O., Guan, K., Guo, Z., Heckmann, D., Heuret, P., Isaac, M., Kothari, S., Kumagai, E., Kyaw, T. Y., Liu, L., Liu, L., Liu, S., Llusià, J., Magney, T., Maréchaux, I., Martin, A. R., Meacham-Hensold, K., Montes, C. M., Ogaya, R., Ojo, J., Oliveira, R., Paquette, A., Peñuelas, J., Placido, A. D., Posada, J. M., Qian, X., Renninger, H. J., Rodriguez-Caton, M., Rojas-González, A., Schlüter, U., Sellan, G., Siegert, C. M., Silva-Perez, V., Song, G., Southwick, C. D., Souza, D. C., Stahl, C., Su, Y., Sujeeun, L., Ting, T.-C., Vasquez, V., Vijayakumar, A., Vilas-Boas, M., Wang, D. R., Wang, S., Wang, H., Wang, J., Wang, X., Weber, A. P. M., Wong, C. Y. S., Wu, J., Wu, F., Wu, S., Yan, Z., Yang, D., and Zhao, Y.: The Global Spectra-Trait Initiative: A database of paired leaf spectroscopy and functional traits associated with leaf photosynthetic capacity, Earth Syst. Sci. Data, 18, 245–265, https://doi.org/10.5194/essd-18-245-2026, 2026.

.ris or .bib references are available at [https://essd.copernicus.org/articles/18/245/2026/](https://essd.copernicus.org/articles/18/245/2026/) 

## Database citation

Data and code associated with the article were developed in this GitHub repository. The version associated with the article is v1.0.0, available using the releases tab in GitHub. In addition, v1.0.0 has been archived with a permanent DOI on ESS-DIVE for long-term preservation and should be cited if you use any data or code from this project. https://data.ess-dive.lbl.gov/view/doi:10.15485/2530733

Lamour J ; Serbin S ; Rogers A ; Ely K ; Acebron K T ; Ainsworth E ; Albert L P ; Alonzo M ; Anderson J ; Atkin O K ; Barbier N ; Barnes M L ; Bernacchi C J ; Besson N ; Burnett A C ; Caplan J S ; Chave J ; Cheesman A W ; Clocher I ; Coast O ; Coste S ; Croft H ; Cui B ; Dauvissat C ; Davidson K J ; Doughty C ; Evans J ; Feret J ; Filella I ; Fortunel C ; Fu P ; Furbank R ; Garcia M ; Gimenez B O ; Guan K ; Guo Z ; Heckman D ; Heuret P ; Marney I ; Kothari S ; Kumagai E ; Kyaw T Y ; Liu L ; Liu L ; Liu S ; Llusià J ; Magney T ; Maréchaux I ; Martin A R ; Meacham-Hensold K ; Montes C M ; Ogaya R ; Ojo J ; Oliveira R ; Paquette A ; Peñuelas J ; Placido A D ; Posada J M ; Qian X ; Renninger H J ; Rodriguez-Caton M ; Rojas-González A ; Schlüter U ; Sellan G ; Siegert C M ; Silva Pérez V ; Song G ; Southwick C D ; Souza D C ; Stahl C ; Su Y ; Sujeeun L ; Ting T ; Vasquez V ; Vijayakumar V ; Vilas-Boas M ; Wang D R ; Wang S ; Wang H ; Wang J ; Wang X ; Weber A P ; Wong C Y ; Wu J ; Wu F ; Wu S ; Yan Z ; Yang D ; Zhao Y (2025): The Global Spectra-Trait Initiative: A database of paired leaf spectroscopy and functional traits associated with leaf photosynthetic capacity (v1.0.0). Next-Generation Ecosystem Experiments (NGEE) Tropics, ESS-DIVE repository. Dataset. doi:10.15485/2530733

Further development of the code, documentation, and data is pursued in this GitHub repository. To reference a specific release after v1.0.0, please use the relevant citation available using the releases tab in GitHub.  


Current version is v.1.0.1 (since 2026/02/06). 

Lamour J ; Serbin S ; Rogers A ; Ely K ; Acebron K T ; Ainsworth E ; Albert L P ; Alonzo M ; Anderson J ; Atkin O K ; Barbier N ; Barnes M L ; Bhattarai R ; Bernacchi C J ; Besson N ; Burnett A C ; Caplan J S ; Chave J ; Cheesman A W ; Clocher I ; Coast O ; Coste S ; Croft H ; Cui B ; Dauvissat C ; Davidson K J ; Doughty C ; Du J Q ; Evans J ; Feret J ; Filella I ; Fortunel C ; Fu P ; Furbank R ; Garcia M ; Gimenez B O ; Guan K ; Guo Z ; Heckman D ; Heuret P ; Marney I ; Kothari S ; Kumagai E ; Kyaw T Y ; Liu L ; Liu L ; Liu S ; Llusià J ; Magney T ; Maréchaux I ; Martin A R ; Meacham-Hensold K ; Montes C M ; Ogaya R ; Ojo J ; Oliveira R ; Paquette A ; Paudel B ; Peñuelas J ; Placido A D ; Poudel K ; Posada J M ; Qian X ; Renninger H J ; Rodriguez-Caton M ; Rojas-González A ; Schlüter U ; Sellan G ; Siegert C M ; Silva Pérez V ; Song G ; Southwick C D ; Souza D C ; Stahl C ; Su Y ; Sujeeun L ; Ting T ; Vasquez V ; Vijayakumar V ; Vilas-Boas M ; Wang D R ; Wang S ; Wang H ; Wang J ; Wang X ; Weber A P ; Wong C Y ; Wu J ; Wu F ; Wu S ; Yan Z ; Yang D ; Zhao Y (2025): The Global Spectra-Trait Initiative: A database of paired leaf spectroscopy and functional traits associated with leaf photosynthetic capacity (v1.0.1). https://github.com/plantphys/gsti/releases/tag/v1.0.1


## References

Burnett, A.C., Anderson, J., Davidson, K.J., Ely, K.S., Lamour, J., Li, Q., Morrison, B.D., Yang, D., Rogers, A. and Serbin, S.P., 2021. A best-practice guide to predicting plant traits from leaf-level hyperspectral data using partial least squares regression. Journal of Experimental Botany, 72(18), pp.6175-6189.

Ely KS, Rogers A, Agarwal DA, Ainsworth EA, Albert LP, Ali A, et al. A reporting format for leaf-level gas exchange data and metadata. Ecol Inform. 2021;61: 101232. https:doi.org/10.1016/j.ecoinf.2021.101232

Farquhar, G.D., von Caemmerer, S. & Berry, J.A. A biochemical model of photosynthetic CO2 assimilation in leaves of C3 species. Planta 149, 78–90 (1980). https://doi.org/10.1007/BF00386231

