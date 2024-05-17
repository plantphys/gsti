This guide provides a comprehensive overview of all the necessary steps
to add a new dataset. The folder “Lamour\_et\_al\_2021” can be used as a
template since the code within the folder has been commented and
corresponds to each step outlined in this guide.

An overview of the process and database organisation is presented
[here](https://github.com/TESTgroup-BNL/gsti/blob/main/Overal_data_curation.pdf).

## Creation of a Dataset folder

Each dataset should be put into a folder named “Names\_Year” for example
“Serbin\_et\_al\_2019”. Please, also include any article associated with
the dataset and the protocol of measurement, which should detail the gas
exchange measurements, leaf reflectance measurements, as well as the
equipment used. The protocol should also provide information about the
location, growing conditions (e.g., natural environment, greenhouse,
agricultural or experimental field, plants in pots), species (e.g.,
natural or agricultural), and plant status (e.g., stressed or not
stressed).

In addition, please include details about your stability criterion to
initiate the A-Ci curves. For example, did you wait for stability of the
photosynthesis rate and stomatal conductance before starting the curve?
What was the average acclimation time of the leaf within the leaf
chamber? Also include this information if you used the “one point
method” to estimate Vcmax (De Kauwe et al. 2016, Burnett et al. 2019).

## Adding a dataset description csv file

Within each dataset folder, a csv file called **Description.csv** has to
be included.

This file will be used to list the authors, associated papers, and
acknowledgements.

    Description=read.csv(file='Description.csv')
    knitr::kable(Description)

<table>
<colgroup>
<col style="width: 2%" />
<col style="width: 13%" />
<col style="width: 39%" />
<col style="width: 10%" />
<col style="width: 30%" />
<col style="width: 3%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Dataset_name</th>
<th style="text-align: left;">Authors</th>
<th style="text-align: left;">Acknowledgment</th>
<th style="text-align: left;">Dataset_DOI</th>
<th style="text-align: left;">Publication_Citation</th>
<th style="text-align: left;">Contact_email</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Dataset name</td>
<td style="text-align: left;">List of authors of the dataset</td>
<td style="text-align: left;">Acknowledgement of funding and help to
generate the dataset</td>
<td style="text-align: left;">Digital Object Identifier (DOI) associated
with the dataset if the dataset was published</td>
<td style="text-align: left;">Full citation associated with the paper
that uses the dataset</td>
<td style="text-align: left;">Contact email for the dataset</td>
</tr>
<tr class="even">
<td style="text-align: left;">Lamour_et_al_2021</td>
<td style="text-align: left;">Julien Lamour, Kenneth J. Davidson, Kim S.
Ely, Jeremiah A. Anderson, Alistair Rogers, Jin Wu , Shawn P.
Serbin</td>
<td style="text-align: left;">This work was supported by the
Next-Generation Ecosystem Experiments (NGEE Tropics) project that is
supported by the Office of Biological and Environmental Research in the
Department of Energy, Office of Science, and through the United States
Department of Energy contract No. DE-SC0012704 to Brookhaven National
Laboratory.</td>
<td style="text-align: left;">10.15486/ngt/1781003,
10.15486/ngt/1781004</td>
<td style="text-align: left;">Julien Lamour, Kenneth J. Davidson, Kim S.
Ely, Jeremiah A. Anderson, Alistair Rogers, Jin Wu , Shawn P. Serbin.
Rapid estimation of photosynthetic leaf traits of tropical plants in
diverse environmental conditions using reflectance spectroscopy</td>
<td style="text-align: left;"><a href="mailto:jlamour.sci@gmail.com"
class="email">jlamour.sci@gmail.com</a></td>
</tr>
</tbody>
</table>

## Adding a site description csv file

A file named **Site.csv** must be included in the dataset folder with
the columns listed below. The latitude and longitude coordinates will be
used to position the dataset on a world map.

If you have different sites for the same dataset with wide difference in
positions that makes a difference on a world map or if this includes
different biomes, you can add several rows to your Site.csv file.

    Site=read.csv(file='Site.csv')
    knitr::kable(Site)

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 17%" />
<col style="width: 27%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Site_name</th>
<th style="text-align: left;">Latitude</th>
<th style="text-align: left;">Longitude</th>
<th style="text-align: left;">Elevation</th>
<th style="text-align: left;">Biome_number</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Short text name for the site where the
measurements were taken</td>
<td style="text-align: left;">Latitude in decimal units</td>
<td style="text-align: left;">Longitude in decimal units</td>
<td style="text-align: left;">Elevation in meters above sea level</td>
<td style="text-align: left;">Biome number as described in the
documentation (1 to 19)</td>
</tr>
<tr class="even">
<td style="text-align: left;">BCI</td>
<td style="text-align: left;">9.1562792</td>
<td style="text-align: left;">-79.862707</td>
<td style="text-align: left;">30</td>
<td style="text-align: left;">1</td>
</tr>
<tr class="odd">
<td style="text-align: left;">PNM</td>
<td style="text-align: left;">8.9943457</td>
<td style="text-align: left;">-79.543073</td>
<td style="text-align: left;">100</td>
<td style="text-align: left;">2</td>
</tr>
<tr class="even">
<td style="text-align: left;">BRF</td>
<td style="text-align: left;">41.413708</td>
<td style="text-align: left;">-74.010606</td>
<td style="text-align: left;">1100</td>
<td style="text-align: left;">5</td>
</tr>
</tbody>
</table>

For the Biome\_number column, please chose a number within the list
below. We chose to use the Olson et al. (2001) list of 14 natural Biomes
that we complemented with agricultural and managed biomes.

    Biomes=read.csv(file='Biomes.csv')
    knitr::kable(Biomes)

<table>
<colgroup>
<col style="width: 82%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Biome</th>
<th style="text-align: right;">Biome_number</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Tropical and subtropical moist broadleaf
forests</td>
<td style="text-align: right;">1</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tropical and subtropical dry broadleaf
forests</td>
<td style="text-align: right;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Tropical and subtropical coniferous
forests</td>
<td style="text-align: right;">3</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tropical and subtropical grasslands,
savannas and shrublands</td>
<td style="text-align: right;">4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Temperate broadleaf and mixed forests</td>
<td style="text-align: right;">5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Temperate coniferous forests</td>
<td style="text-align: right;">6</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Temperate grasslands and savannas</td>
<td style="text-align: right;">7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Flooded grasslands and savannas</td>
<td style="text-align: right;">8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Montane grasslands and shrublands</td>
<td style="text-align: right;">9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Tundra</td>
<td style="text-align: right;">10</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Mediterranean forests, woodlands and
scrub</td>
<td style="text-align: right;">11</td>
</tr>
<tr class="even">
<td style="text-align: left;">Boreal forests/Taiga</td>
<td style="text-align: right;">12</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Desert and xeric shrublands</td>
<td style="text-align: right;">13</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mangroves</td>
<td style="text-align: right;">14</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Managed Grasslands</td>
<td style="text-align: right;">15</td>
</tr>
<tr class="even">
<td style="text-align: left;">Field Crop Ecosystems</td>
<td style="text-align: right;">16</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Tree Crop Ecosystems</td>
<td style="text-align: right;">17</td>
</tr>
<tr class="even">
<td style="text-align: left;">Greenhouse Ecosystems</td>
<td style="text-align: right;">18</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Other Managed Ecosystems</td>
<td style="text-align: right;">19</td>
</tr>
</tbody>
</table>

## Adding the gas exchange A-C<sub>i</sub> data to the dataset folder

The aim of this project is to include the raw A-C<sub>i</sub> data so
that we can fit the curves and estimate V<sub>cmax</sub> using the same
method for all datasets.

The final A-C<sub>i</sub> data to be used by the fitting procedure must
meet certain requirements (see table below with the required column
names). However, we don’t have hard requirements in the way to obtain
this final data. Note that the SampleID\_num column will be used by the
fitting procedure to identify individual A-C<sub>i</sub> curves. If you
made several A-C<sub>i</sub> curves on the same leaf we recommend to
only keep the best one. We decided to use a column SampleID\_num in
addition to the SampleID column. SampleID should correspond to the
original identifier of the leaves in the raw dataset which is often a
complex string. The column SampleID\_num should be an integer. We made
the choice to use the SampleID\_num to facilitate the QAQC of the curves
and the ploting of the figures.

The A-C<sub>i</sub> data should be cleaned from spurious measurements
and points that would bias V<sub>cmax</sub> or J<sub>max</sub>
estimation should not be included. If several measurements were taken at
a given Ci, please only chose one so each Ci has the same number of
measurements. We are usually quite conservative on the quality analysis
and only keep the curves where the estimation of V<sub>cmax</sub> will
be good. If we have doubts on the quality of the data we tend to remove
them from the final curated data.

The curated A-C<sub>i</sub> data should be present in the dataset folder
in a Rdata format called **‘2\_Fitted\_ACi\_data.Rdata’** which contains
the A-C<sub>i</sub> data in a data.frame with at least the columns
listed in the table below.

Note that we include in the dataset folder the raw data, as well as the
R code used to read, import and transform the raw data. All those
preliminary steps are made in two R codes called
**‘0\_Import\_transform\_ACi\_data.R’** and
**‘1\_QaQc\_curated\_ACi.R’**.

    Aci_data=read.csv(file='Aci_data.csv')
    knitr::kable(Aci_data)

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 10%" />
<col style="width: 13%" />
<col style="width: 7%" />
<col style="width: 26%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">SampleID</th>
<th style="text-align: left;">SampleID_num</th>
<th style="text-align: left;">record</th>
<th style="text-align: left;">A</th>
<th style="text-align: left;">Ci</th>
<th style="text-align: left;">Patm</th>
<th style="text-align: left;">Qin</th>
<th style="text-align: left;">Tleaf</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Identifier of the measured leaf</td>
<td style="text-align: left;">Integer Identifier of the measured
leaf</td>
<td style="text-align: left;">Observation record number</td>
<td style="text-align: left;">Net CO2 exchange per leaf area</td>
<td style="text-align: left;">Intercellular CO2 concentration in
air</td>
<td style="text-align: left;">Atmospheric pressure</td>
<td style="text-align: left;">In chamber photosynthetic flux density
incident on the leaf in quanta per area</td>
<td style="text-align: left;">Leaf surface temperature</td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;">Integer</td>
<td style="text-align: left;">Integer</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol mol-1</td>
<td style="text-align: left;">kPa</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">degrees celcius</td>
</tr>
</tbody>
</table>

## Fitting the A-C<sub>i</sub> data to estimate the photosynthetic traits

Estimation of V<sub>cmax</sub> is done in the **‘2\_Fit\_ACi.R’** code
included in each dataset folder. This code calls the function
f.fit\_Aci() to estimate the photosynthetic parameters
V<sub>cmax25</sub>, J<sub>max25</sub>, TPU<sub>25</sub> and
R<sub>day25</sub> of the A-C<sub>i</sub> curve. It produces several pdf
files:

-   2\_ACi\_fitting\_Ac.pdf

-   2\_ACi\_fitting\_Ac\_Aj.pdf

-   2\_ACi\_fitting\_Ac\_Aj\_Ap.pdf

and

-   2\_ACi\_fitting\_best\_model.pdf

The first three pdf show the fitting of each A-C<sub>i</sub> curves when
including the rate of maximum carboxylation (A<sub>c</sub>), the rate of
electron transport (A<sub>j</sub>) and the rate of triose phosphate
utilization (A<sub>p</sub>).

The best model corresponds to the model with the lowest AIC that
includes A<sub>c</sub> or A<sub>c</sub> + A<sub>j</sub> or
A<sub>c</sub> + A<sub>j</sub> + A<sub>p</sub>. Note that if the model
with the best AIC is the one including A<sub>c</sub> only, then
V<sub>cmax25</sub> and R<sub>day25</sub> are the only parameters
estimated. If the model with the best AIC is A<sub>c</sub> +
A<sub>j</sub>, then J<sub>max25</sub> is also estimated.
TPU<sub>25</sub> is estimated if A<sub>c</sub>, A<sub>j</sub> and
A<sub>p</sub> are limiting. In all cases, transition between the
A<sub>c</sub>, A<sub>j</sub>, and A<sub>p</sub> rates is determined
automatically by the fitting procedure to avoid manual and somehow
subjective choices in the transitions.

This codes produces a dataframe, called Bilan with the folowing columns:

    Bilan=read.csv(file='Bilan.csv',header = TRUE)
    knitr::kable(Bilan)

<table style="width:100%;">
<colgroup>
<col style="width: 3%" />
<col style="width: 4%" />
<col style="width: 15%" />
<col style="width: 17%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 2%" />
<col style="width: 6%" />
<col style="width: 3%" />
<col style="width: 4%" />
<col style="width: 7%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">SampleID</th>
<th style="text-align: left;">SampleID_num</th>
<th style="text-align: left;">Vcmax25</th>
<th style="text-align: left;">Jmax25</th>
<th style="text-align: left;">TPU25</th>
<th style="text-align: left;">Rday25</th>
<th style="text-align: left;">StdError_Vcmax25</th>
<th style="text-align: left;">StdError_Jmax25</th>
<th style="text-align: left;">StdError_TPU25</th>
<th style="text-align: left;">StdError_Rday25</th>
<th style="text-align: left;">Tleaf</th>
<th style="text-align: left;">Sigma</th>
<th style="text-align: left;">AIC</th>
<th style="text-align: left;">Model</th>
<th style="text-align: left;">Vcmax_method</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Identifier of the measured leaf</td>
<td style="text-align: left;">Integer Identifier of the measured
leaf</td>
<td style="text-align: left;">Maximum rate of carboxylation at the
reference temperature 25 degrees celcius calculated assuming infinite
mesophyl conductance i.e. apparent Vcmax</td>
<td style="text-align: left;">Maximum rate of electron transport per
leaf area at the reference temperature 25 degrees celcius calculated
assuming infinite mesophyll conductance and saturating light</td>
<td style="text-align: left;">Triose phosphate utilization rate per leaf
area at the reference temperature 25 degrees celcius</td>
<td style="text-align: left;">CO2 release from the leaf in the light at
the reference temperature of 25 degrees celcius</td>
<td style="text-align: left;">Standard error of Vcmax25 estimation</td>
<td style="text-align: left;">Standard Error of Jmax25 estimation</td>
<td style="text-align: left;">Standard Error of TPU25 estimation</td>
<td style="text-align: left;">Standard Error of Rday25 estimation</td>
<td style="text-align: left;">Leaf surface temperature</td>
<td style="text-align: left;">standard error of the residuals of the
fitted A-Ci curve</td>
<td style="text-align: left;">Akaike information criterion</td>
<td style="text-align: left;">Model used for the fitting of the A-Ci
curves</td>
<td style="text-align: left;">Method used to estimate Vcmax. Can be
‘A-Ci curve’ or ‘One point’</td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;">Integer</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">degrees celcius</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

It is also possible to estimate V<sub>cmax25</sub> by the one point
method (De Kauwe et al. 2016; Burnett et al. 2019).In that case, the
measurements should be done at saturating irradiance in ambient
CO<sub>2</sub> conditions. You can use the function f.fit\_One\_Point()
to estimate V<sub>cmax25</sub>. It will produce the exact same data
frame as when using the function f.fit\_Aci.

Importantly, the same temperature correction is used for all the
datasets to estimate the parameters at 25°C. Since the Tleaf is also
given in the output of the table, it will be possible to re estimate the
parameters at the leaf temperature and to try other temperature
dependence parametrization if needed. The A-C<sub>i</sub> fitting can
also be re-run with different parametrizations for all the datasets
using the output from step 1.

## Adding dark adapted leaf respiration data (optional)

If you measured the dark respiration of leaves you can also add them to
the dataset. All you need is to include a file with as columns:

-   SampleID (the leaf identifier that is used everywhere to link
    different data)
-   Rdark (the dark respiration value, in micromol m-2 s-1, which
    corresponds to the CO2 release from the leaf in the dark, at
    measurement temperature, reported as a positive value)
-   Tleaf\_Rdark, in degree celcius, the measurement leaf temperature

## Adding the leaf spectra data

The spectral information is ideally a full range reflectance measurement
(350 nm to 2500 nm) with a 1 nm resolution.

If you don’t have values for all the wavelengths (for example from 350
nm to 500 nm or from 2400 nm to 2500 nm), you can put NA in those
wavelengths.

A code **“3\_Import\_transform\_Reflectance.R”** should be used to
create a R data frame file called **“3\_QC\_Reflectance\_data.Rdata”**
with four columns:

-   SampleID which has to be consistent with the previous files for each
    leaf,

-   Spectrometer, which informs what was the spectrometer model used (SE
    PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD
    FieldSpec 4, ASD FieldSpec 4 Hi-Res, …)

-   Leaf\_clip, which informs what was the leaf clip used (SVC LC-RP,
    SVC LC-RP Pro, ASD Leaf Clip, …)

-   Reflectance, which is a matrix with the Reflectance in column
    expressed in percent from 0 to 100.

We use a matrix in the column Reflectance, folowing the “pls” package
requirement (Mevik & Wehrens, 2007). More information is given in the
“pls” package documentation and manual
(<https://cran.r-project.org/web/packages/pls/vignettes/pls-manual.pdf>)

Bjørn-Helge Mevik and Ron Wehrens. The pls package: Principal component
and partial least squares regression in R. Journal of Statistical
Software, 18(2):1–24, 2007.

### Adding a leaf sample information description csv file

A code called **“4\_Import\_transform\_SampleDetails.R”** should be used
to create a **‘SampleDetails’** dataframe with the folowing columns:

    SampleDetails=read.csv(file='SampleDetails.csv')
    knitr::kable(SampleDetails)

<table style="width:100%;">
<colgroup>
<col style="width: 3%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 5%" />
<col style="width: 15%" />
<col style="width: 15%" />
<col style="width: 5%" />
<col style="width: 4%" />
<col style="width: 9%" />
<col style="width: 4%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">SampleID</th>
<th style="text-align: left;">Dataset_name</th>
<th style="text-align: left;">Site_name</th>
<th style="text-align: left;">Species</th>
<th style="text-align: left;">Leaf_match</th>
<th style="text-align: left;">Sun_Shade</th>
<th style="text-align: left;">Phenological_stage</th>
<th style="text-align: left;">Plant_type</th>
<th style="text-align: left;">Soil</th>
<th style="text-align: left;">LMA</th>
<th style="text-align: left;">Narea</th>
<th style="text-align: left;">Nmass</th>
<th style="text-align: left;">Parea</th>
<th style="text-align: left;">Pmass</th>
<th style="text-align: left;">LWC</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Identifier of the measured leaf</td>
<td style="text-align: left;">Name of the dataset</td>
<td style="text-align: left;">Name of the site</td>
<td style="text-align: left;">Full species name, for example Cecropia
insignis</td>
<td style="text-align: left;">Were the gas exchange and spectra measured
in the exact same leaf or distinct, similar leaves? Choose between
“Same” and “Similar”.</td>
<td style="text-align: left;">Was the leaf at the top of the canopy and
usually receiving light (sun) or a shaded leaf? Choose between Sun,
Shade or leave empty</td>
<td style="text-align: left;">Leaf phenological stage (Young, Mature,
Old)</td>
<td style="text-align: left;">Choose between Wild or Agricultural</td>
<td style="text-align: left;">Please choose between natural ground, pot,
or managed ground (Natural, Pot, Managed)</td>
<td style="text-align: left;">Leaf dry mass per unit area in g m-2</td>
<td style="text-align: left;">Nitrogen content of leaf per unit leaf
area in g m-2</td>
<td style="text-align: left;">Nitrogen content of leaf by dry mass in mg
g-1</td>
<td style="text-align: left;">Phosphorus content of leaf per unit leaf
area in g m-2</td>
<td style="text-align: left;">Phosophorus content of leaf by dry mass in
mg g-1</td>
<td style="text-align: left;">Leaf water content. Percent water content
of fresh leaf by mass in % (0-100)</td>
</tr>
<tr class="even">
<td style="text-align: left;">BNL20202</td>
<td style="text-align: left;">Davidson_et_al_2020</td>
<td style="text-align: left;">SLZ</td>
<td style="text-align: left;">Cecropia insignis</td>
<td style="text-align: left;">Same</td>
<td style="text-align: left;">Sun</td>
<td style="text-align: left;">Mature</td>
<td style="text-align: left;">Wild</td>
<td style="text-align: left;">Natural</td>
<td style="text-align: left;">90.24</td>
<td style="text-align: left;">2.35</td>
<td style="text-align: left;">26</td>
<td style="text-align: left;">0.27</td>
<td style="text-align: left;">3</td>
<td style="text-align: left;">62</td>
</tr>
<tr class="odd">
<td style="text-align: left;">BNL10101</td>
<td style="text-align: left;">Burnett_et_al_2018</td>
<td style="text-align: left;">BNL</td>
<td style="text-align: left;">Cucurbit pepo</td>
<td style="text-align: left;">Similar</td>
<td style="text-align: left;">Sun</td>
<td style="text-align: left;">Old</td>
<td style="text-align: left;">Agricultural</td>
<td style="text-align: left;">Pot</td>
<td style="text-align: left;">118.65</td>
<td style="text-align: left;">2.59</td>
<td style="text-align: left;">21.8</td>
<td style="text-align: left;">0.42</td>
<td style="text-align: left;">3.5</td>
<td style="text-align: left;">70</td>
</tr>
</tbody>
</table>

Importantly, the Site\_name has to be consistent with the Site\_name
written in the Site.csv file and the SampleID will have to be consistent
with the identifier used for the gas exchange and for the spectra as the
SampleID will be used to merge all the different data.

The first columns have to be filled (SampleID, Dataset\_name,
Site\_name, Species, Leaf\_match, Sun\_Shade, Phenological\_stage,
Plant\_type, Soil), the columns related to the leaf traits can be left
empty if you don’t have the data (LMA, Narea, Nmass, Parea, Pmass, LWC).
Note that the leaf water content, LWC, corresponds to (fresh weight -
dry weight) / fresh weight.

For the species name, please write “Genus species”, for exemple
Cercropia insignis. If you know the genus but not the species, write for
example “Cecropia species”. If you dont know the genus, write “Family
genus” for example (Urticaceae genus). If you don’t know anything, well
you can write “Unknown”.

The SampleDetails dataframe is stored in the Rdata file
**‘4\_SampleDetails.Rdata’**.

## Checking the overall dataset information

The function “f.Check\_data()” can be used to validate that the format
of the curated dataset is correct and that all the required files are
provided. The function checks if required variables are present in the
data files and if all the information can be merged together.

This function is called in the last R file
“4\_Import\_transform\_SampleDetails.R”

### References

Burnett, AC, Davidson, KJ, Serbin, SP, Rogers, A. The “one-point method”
for estimating maximum carboxylation capacity of photosynthesis: A
cautionary tale. Plant Cell Environ. 2019; 42: 2472– 2481.
<https://doi.org/10.1111/pce.13574>

De Kauwe, M. G., Lin, Y. S., Wright, I. J., Medlyn, B. E., Crous, K. Y.,
Ellsworth, D. S., … Domingues, T. F. (2016b). A test of the “one-point
method” for estimating maximum carboxylation capacity from
field-measured, light-saturated photosynthesis. New Phytologist, 210(3),
1130– 1144. <https://doi.org/10.1111/nph.13815>

David M. Olson, Eric Dinerstein, Eric D. Wikramanayake, Neil D. Burgess,
George V. N. Powell, Emma C. Underwood, Jennifer A. D’amico, Illanga
Itoua, Holly E. Strand, John C. Morrison, Colby J. Loucks, Thomas F.
Allnutt, Taylor H. Ricketts, Yumiko Kura, John F. Lamoreux, Wesley W.
Wettengel, Prashant Hedao, Kenneth R. Kassem, Terrestrial Ecoregions of
the World: A New Map of Life on Earth: A new global map of terrestrial
ecoregions provides an innovative tool for conserving biodiversity,
BioScience, Volume 51, Issue 11, November 2001, Pages 933–938,
<https://doi.org/10.1641/0006-3568(2001)051%5B0933:TEOTWA%5D2.0.CO;2>
