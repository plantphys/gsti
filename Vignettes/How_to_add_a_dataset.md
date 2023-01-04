## Creation of a Dataset folder

Each dataset is put into a folder called “Names\_Year” for example
“Serbin\_et\_al\_2019”. Please, also add any article associated with the
dataset or the protocol of measurement, which should include the
description of the gas exchange measurements, leaf reflectance
measurements, as well as the equipments used. It should also include the
location description, information on the growing conditions (Natural
environment? Green house? Agricultural or experimental field? Plants in
pots?) and information on the species (Natural species, agricultural
species) as well as the status of the plants (stressed, not stressed?)

### Adding a dataset description csv file

In each dataset folder a csv file called Description.csv has to be
included. An example is given in the Folder 0\_Template. This file will
be used to list the authors as well as associated papers and
acknoledgements.

    Description=read.csv(file='Description.csv')
    knitr::kable(Description)

<table>
<colgroup>
<col style="width: 13%" />
<col style="width: 40%" />
<col style="width: 11%" />
<col style="width: 30%" />
<col style="width: 3%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Authors</th>
<th style="text-align: left;">Acknowledgment</th>
<th style="text-align: left;">Dataset_DOI</th>
<th style="text-align: left;">Publication_Citation</th>
<th style="text-align: left;">Email</th>
</tr>
</thead>
<tbody>
<tr class="odd">
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

### Adding a site description csv file

A file called Site.csv also has to be included with the column listed
below.The latitude and longitude coordinates will be used to position
the dataset on a world map. If you have different sites on the same
dataset with wide difference in positions that makes a difference on a
world map, you can add several rows to your Description.csv file.

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
<td style="text-align: left;">Black Rock Forest</td>
<td style="text-align: left;">41.413708</td>
<td style="text-align: left;">-74.010606</td>
<td style="text-align: left;">1100</td>
<td style="text-align: left;">5</td>
</tr>
</tbody>
</table>

For the Biome\_number column, please chose a number among the list
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
<td style="text-align: left;">Bioindustrial Ecosystems</td>
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
the figures (title name).

The A-C<sub>i</sub> data should be cleaned from spurious measurements
and points that would impact V<sub>cmax</sub> or J<sub>max</sub>
estimation should not be included. If several measurements were taken at
a given Ci, please only chose one so each Ci has the same number of
measurements.We are usually quite severe on the quality analysis to only
keep the curves where the estimation of V<sub>cmax</sub> will be good.
If we have doubts on the quality of the data we tend to remove them from
the final curated data.

The curated A-C<sub>i</sub> data should be present in the dataset folder
in a Rdata format called ‘1\_QC\_data.Rdata’ which contains the
A-C<sub>i</sub> data in a data.frame with at least the columns listed in
the table below.

Note that we usually include in the dataset folder the raw data, as well
as the R code used to read, import and transform the raw data. All those
preliminary steps are made in a R code called
‘0\_Import\_transform\_original\_ACi\_data.R’.We recommend to do the
same, but again, we don’t have requirements on the code to do that.

We also include the code used to check the quality of the
A-C<sub>i</sub> data where we flag the bad points and delete the bad
curves. This code is called ‘1\_QaQc\_curated\_ACi.R’ and produces the
file ‘1\_QC\_data.Rdata’. This code usually produces a PDF file with a
plot of each of the A-C<sub>i</sub> curves with the good point in dark
and the bad points in red. You can find some examples in the different
dataset folders.

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

Estimation of V<sub>cmax</sub> is done in the ‘2\_Fit\_ACi.R’ code
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
folowing column:

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
<th style="text-align: left;">sigma</th>
<th style="text-align: left;">AIC</th>
<th style="text-align: left;">model</th>
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
method (De Kauwe et al. 2016; Burnett et al. 2019). In that case, the
measurements should be done at saturating irradiance in ambient
CO<sub>2</sub> conditions. You can use the function f.fit\_One\_Point()
to estimate V<sub>cmax25</sub>. It will produce the exact same data
frame as when using the function f.fit\_Aci.

Importantly, the same temperature correction is used for all the
datasets to estimate the parameters at 25°C. Since the Tleaf is also
given in the output of the table, it will be possible to re estimate the
parameters at the leaf temperature and to try other temperature
dependence parametrization if needed.

## Adding the leaf spectra data and the leaf sample information

We merge the fitted parameters, the spectra and the leaf information in
the code called ‘3\_Combine\_spectra\_traits.R’. This code produces a
dataframe with the folowing columns:

    Spectra=read.csv(file='Spectra.csv',header = TRUE)
    knitr::kable(Spectra)

<table style="width:100%;">
<colgroup>
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 4%" />
<col style="width: 12%" />
<col style="width: 3%" />
<col style="width: 7%" />
<col style="width: 5%" />
<col style="width: 13%" />
<col style="width: 15%" />
<col style="width: 9%" />
<col style="width: 5%" />
<col style="width: 4%" />
<col style="width: 2%" />
<col style="width: 3%" />
<col style="width: 1%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">SampleID</th>
<th style="text-align: left;">SampleID_num</th>
<th style="text-align: left;">Dataset</th>
<th style="text-align: left;">Site_name</th>
<th style="text-align: left;">Species</th>
<th style="text-align: left;">Sun_Shade</th>
<th style="text-align: left;">Plant_type</th>
<th style="text-align: left;">Soil</th>
<th style="text-align: left;">Vcmax_method</th>
<th style="text-align: left;">Vcmax25</th>
<th style="text-align: left;">Jmax25</th>
<th style="text-align: left;">TPU25</th>
<th style="text-align: left;">Tleaf</th>
<th style="text-align: left;">Spectra</th>
<th style="text-align: left;">LMA</th>
<th style="text-align: left;">Narea</th>
<th style="text-align: left;">LWC</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Identifier of the measured leaf</td>
<td style="text-align: left;">Integer Identifier of the measured
leaf</td>
<td style="text-align: left;">Name of the dataset folder</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Full species name for example Cecropia
insignis</td>
<td style="text-align: left;">Was the leaf at the top of the canopy and
usually receiving light (sun) or a shaded leaf? Chose between Sun, Shade
or leave empty</td>
<td style="text-align: left;">Chose between Wild or Agricultural</td>
<td style="text-align: left;">Please chose between natural ground, pot,
or managed ground (Natural, Pot, Managed)</td>
<td style="text-align: left;">Method used to estimate Vcmax (A-Ci curve
or One point)</td>
<td style="text-align: left;">Maximum rate of carboxylation at the
reference temperature 25 degrees celcius calculated assuming infinite
mesophyl conductance i.e. apparent Vcmax</td>
<td style="text-align: left;">Maximum rate of electron transport per
leaf area at the reference temperature 25 degrees celcius calculated
assuming infinite mesophyll conductance and saturating light</td>
<td style="text-align: left;">Triose phosphate utilization rate per leaf
area at the reference temperature 25 degrees celcius</td>
<td style="text-align: left;">Leaf surface temperature during the gas
exchange measurements</td>
<td style="text-align: left;">Reflectrance spectra from 350 nm to 2500
nm</td>
<td style="text-align: left;">Leaf mass per surface area</td>
<td style="text-align: left;">Nitrogen content per surface area</td>
<td style="text-align: left;">Leaf water content</td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;">Integer</td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">micromol m-2 s-1</td>
<td style="text-align: left;">Degrees celcius</td>
<td style="text-align: left;">percent 0 - 100</td>
<td style="text-align: left;">g m-2</td>
<td style="text-align: left;">g m-2</td>
<td style="text-align: left;">percent 0 - 100</td>
</tr>
<tr class="odd">
<td style="text-align: left;">BNL20202</td>
<td style="text-align: left;">1</td>
<td style="text-align: left;">Doe_et_al_2010</td>
<td style="text-align: left;">SLZ</td>
<td style="text-align: left;">Cecropia insignis</td>
<td style="text-align: left;">Sun</td>
<td style="text-align: left;">Wild</td>
<td style="text-align: left;">Natural</td>
<td style="text-align: left;">A-Ci curve</td>
<td style="text-align: left;">88.77</td>
<td style="text-align: left;">144.22</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">32</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">112</td>
<td style="text-align: left;">1.63</td>
<td style="text-align: left;">55</td>
</tr>
<tr class="even">
<td style="text-align: left;">BNL10101</td>
<td style="text-align: left;">2</td>
<td style="text-align: left;">Doe_et_al_2010</td>
<td style="text-align: left;">BNL_greenhouse</td>
<td style="text-align: left;">Cucurbit pepo</td>
<td style="text-align: left;">Sun</td>
<td style="text-align: left;">Agricultural</td>
<td style="text-align: left;">Pot</td>
<td style="text-align: left;">One point</td>
<td style="text-align: left;">75.51</td>
<td style="text-align: left;">112.2</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">28</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">90</td>
<td style="text-align: left;">1.42</td>
<td style="text-align: left;">60</td>
</tr>
</tbody>
</table>

Note that the Spectra column stores a vector ranging from 350 nm to 2500
nm with a 1 nm interval (see code for storing a vector in a column). If
you dont have values for 350 nm to 500 nm or from 2400 nm to 2500 nm,
you can put NA in those wavelengths.

The columns LMA, Narea and LWC do not neccessary need to be filled if
you don’t have the data.

For the species name, please write “Genus species”, for exemple
Cercropia insignis. If you know the genus but not the species, write for
example “Cecropia species”. If you dont know the genus, write “Family
genus” for example (Urticaceae genus). If you don’t know anything, well
you can write “Unknown”.
