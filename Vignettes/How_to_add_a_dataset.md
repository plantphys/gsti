This guide describes all the steps needed to add a new dataset. An
overview of the process is presented
[here](https://github.com/TESTgroup-BNL/gsti/blob/main/Overal_data_curation.pdf).

The folder Lamour\_et\_al\_2021 can be used as a template. The code
within this folder has been commented and correspond to all the steps of
this guide.

## Creation of a Dataset folder

Each dataset is put into a folder called “Names\_Year” for example
“Serbin\_et\_al\_2019”. Please, also add any article associated with the
dataset and the protocol of measurement, which should include the
description of the gas exchange measurements, leaf reflectance
measurements, as well as the equipments used. It should also include the
location description, information on the growing conditions (Natural
environment? Green house? Agricultural or experimental field? Plants in
pots?) and information on the species (Natural species, agricultural
species) as well as the status of the plants (stressed, not stressed?).

Please, also mention what was your stability criterion to start the A-Ci
curves (did you wait for stability of the photosynthesis rate and
stomatal conductance before starting the curve? What was the average
acclimation time of the leaf within the leaf chamber?) and within the
A-Ci curves. Also include this information if you used the “one point
method” to estimate Vcmax (De Kauwe et al. 2016, Burnett et al. 2019).

## Adding a dataset description csv file

In each dataset folder a csv file called **Description.csv** has to be
included. This file will be used to list the authors as well as
associated papers and acknowledgements.

## Adding a site description csv file

A file called **Site.csv** also has to be included with the columns
listed below. The latitude and longitude coordinates will be used to
position the dataset on a world map.

If you have different sites for the same dataset with wide difference in
positions that makes a difference on a world map or if this include
different biomes, you can add several rows to your Site.csv file.

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

The idea of this project is to include the raw A-C<sub>i</sub> data so
we can fit the curves and estimate V<sub>cmax</sub> using the same
method for all datasets.

We have requirements for the final A-C<sub>i</sub> data to be used by
the fitting procedure (see table below with the needed column names).
However, we don’t have hard requirements in the way to obtain this final
data. Note that the SampleID\_num column will be used by the fitting
procedure to identify individual A-C<sub>i</sub> curves. If you made
several A-C<sub>i</sub> curves on the same leaf we recommend to only
keep the best one. We decided to use a column SampleID and a column
SampleID\_num. SampleID should correspond to the original identifier of
the leaves in the raw dataset which is often a complex string. The
column SampleID\_num should be an integer. We made the choice to use the
SampleID\_num to facilitate the QAQC of the curves and the ploting of
the figures.

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

The first three pdf shows the fitting of each A-C<sub>i</sub> curves
when including the rate of maximum carboxylation (A<sub>c</sub>), the
rate of electron transport (A<sub>j</sub>) and the rate of triose
phosphate utilisation (A<sub>p</sub>).

The best model corresponds to the model with the lowest AIC that
includes A<sub>c</sub> or A<sub>c</sub> + A<sub>j</sub> or
A<sub>c</sub> + A<sub>j</sub> + A<sub>p</sub>. Note that if the models
with the best AIC is the one only including A<sub>c</sub>, then
V<sub>cmax25</sub> and R<sub>day25</sub> are the only parameters
estimated. If the model with the best AIC is A<sub>c</sub> +
A<sub>j</sub>, then J<sub>max25</sub> is also estimated.
TPU<sub>25</sub> is estimated if A<sub>c</sub>, A<sub>j</sub> and
A<sub>p</sub> are limiting. In all cases, transition between the
A<sub>c</sub>, A<sub>j</sub>, and A<sub>p</sub> rates is determined
automatically by the fitting procedure to avoid manual and somehow
subjective choices in the transitions.

This codes produces a dataframe, called Bilan which includes the
folowing columns:

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
dependence parametrization if needed.

## Adding dark adapted leaf respiration data (optional)

If you measured the dark respiration of leaves you can also add them to
the project. All you need is to include a file with as columns:

-   SampleID (the leaf identifier that is used everywhere to link
    different data)
-   Rdark (the dark respiration value, in micromol m-2 s-1, which
    corresponds to the CO2 release from the leaf in the dark, at
    measurement temperature, reported as a positive value)
-   Tleaf, in degree celcius, the measurement leaf temperature

## Adding the leaf spectra data

The spectral information should be a full range reflectance measurement
(350 nm to 2500 nm) with a 1 nm resolution.

If you don’t have values for all the wavelengths (for example from 350
nm to 500 nm or from 2400 nm to 2500 nm), you can put NA in those
wavelengths.

A code **“3\_Import\_transform\_Reflectance.R”** should be used to
create a R data frame file called **“3\_QC\_Reflectance\_data.Rdata”**
with four columns:

-   SampleID which has to be consistent with the previous files for each
    leaf,

-   Spectrometer, which informs what was the spectrometer model used
    (PSR+ 3500, SVC HR-1024i, SVC XHR-1024i, ASD FieldSpec 3, ASD
    FieldSpec 4, ASD FieldSpec 4 Hi-Res, …)

-   Leaf\_clip, which informs what was the leaf clip used (SVC LC-RP,
    SVC LC-RP Pro, ASD Leaf Clip, …)

-   Reflectance, which is a matrix with the reflectance in column
    (expressed in percent from 0 to 100).

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

Importantly, the Site\_name has to be consistent with the Site\_name
written in the Site.csv file and the SampleID will have to be consistent
with the identifier used for the gas exchange and for the spectra as the
SampleID will be used to merge all the different data.

The first columns have to be filled (SampleID, Dataset\_name,
Site\_name, Species, Sun\_Shade, Plant\_type, Soil), the columns related
to the leaf traits can be left empty if you don’t have the data (LMA,
Narea, Nmass, Parea, Pmass, LWC). Note that the leaf water content, LWC,
corresponds to (fresh weight - dry weight) / fresh weight.

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
