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

## Description of the dataset

In each dataset folder a csv file called Description.csv has to be
included. An example is given in the Folder 0\_Template. The latitude
and longitude coordinates will be used to position the dataset on a
world map. If you have different sites on the same dataset with wide
difference in positions that makes a difference on a world map, you can
add several rows to your Description.csv file

    Description=read.csv(file='Description.csv')
    knitr::kable(Description)

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 13%" />
<col style="width: 20%" />
<col style="width: 14%" />
<col style="width: 6%" />
<col style="width: 12%" />
<col style="width: 13%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Authors</th>
<th style="text-align: left;">Acknowledgment</th>
<th style="text-align: left;">Dataset_DOI</th>
<th style="text-align: left;">Publication_Citation</th>
<th style="text-align: left;">Email</th>
<th style="text-align: left;">Lat</th>
<th style="text-align: left;">Long</th>
<th style="text-align: left;">Elevation</th>
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
<td style="text-align: left;">Latitude of the dataset site study in
decimal units (Y)</td>
<td style="text-align: left;">Longitude of the dataset site study in
decimals units (X)</td>
<td style="text-align: left;">Elevation of the dataset site study if
known.</td>
</tr>
</tbody>
</table>

## Adding the gas exchange A-Ci data to the dataset folder

The idea of this project is to include the raw A-Ci data so we can fit
the curves and estimate V<sub>cmax</sub> using the same method for all
datasets.

We have requirements for the final A-Ci data to be used by the fitting
procedure (see table below with the needed column names). However, we
don’t have hard requirements in the way to obtain this final data. Note
that the SampleID\_num column will be used by the fitting procedure to
identify individual A-Ci curves. If you made several A-Ci curves on the
same leaf we recommend to only keep the best one. We decided to use a
column SampleID and a column SampleID\_num. SampleID should correspond
to the original identifier of the leaves in the raw dataset which is
often a complex string. The column SampleID\_num should be an integer.
We made the choice to use the SampleID\_num to facilitate the QAQC of
the curves and the ploting of the figures (title name).

The A-Ci data should be cleaned from spurious measurements and points
that would impact V<sub>cmax</sub> or J<sub>max</sub> estimation should
not be included.

The curated A-Ci data should be present in the dataset folder in a Rdata
format called ‘1\_QC\_data.Rdata’ which contains the A-Ci data in a
data.frame with at least the columns listed in the table below.

Note that we usually include in the dataset folder the raw data, as well
as the R code used to read, import and transform the raw data. All those
preliminary steps are made in a R code called
‘0\_Import\_transform\_original\_ACi\_data.R’.We recommend to do the
same, but again, we don’t have requirements on the code to do that.

We also include the code used to check the quality of the A-Ci data
where we flag the bad points and delete the bad curves. This code is
called ‘1\_QaQc\_curated\_ACi.R’ and produces the file
‘1\_QC\_data.Rdata’. This code usually produces a PDF file with a plot
of each of the A-Ci curves with the good point in dark and the bad
points in red. You can find some examples in the different dataset
folders.

We are usually quite severe on the quality analysis to only keep the
curves where the estimation of Vcmax will be good. If we have doubts on
the quality of the data we tend to remove them from the final curated
data.

    Aci_data=read.csv(file='Aci_data.csv')
    knitr::kable(Aci_data)

<table>
<colgroup>
<col style="width: 4%" />
<col style="width: 10%" />
<col style="width: 13%" />
<col style="width: 8%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 6%" />
<col style="width: 25%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Column_Names</th>
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
<td style="text-align: left;">Definition</td>
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
<td style="text-align: left;">Unit</td>
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

## Fitting the A\_Ci data to estimate the photosynthetic traits

Estimation of Vcmax is done in the ‘2\_Fit\_ACi.R’ code included in each
dataset folder. This code calls the function f.fit\_Aci() to estimate
the photosynthetic parameters Vcmax25, Jmax25, TPU25 and Rday25 from
A-Ci curve. It produces several pdf files:

-   2\_ACi\_fitting\_Ac.pdf

-   2\_ACi\_fitting\_Ac\_Aj.pdf

-   2\_ACi\_fitting\_Ac\_Aj\_Ap.pdf

and

-   2\_ACi\_fitting\_best\_model.pdf

The first three pdf shows the fitting of each A-Ci curves when including
the rate of maximum carboxylation (Ac), the rate of electron transport
(Aj) and the rate of triose phosphate utilisation (Ap). The best model
corresponds to the model with the lowest AIC that includes Ac or Ac + Aj
or Ac + Aj + Ap. Note that if the models with the best AIC is the one
only including Ac, then Vcmax25 and Rday25 are the only parameters
estimated. If the model with the best AIC is Ac + Aj, then Jmax25 is
also estimated. TPU25 is estimated if Ac, Aj and Ap are limiting. In all
cases, transition between the Ac, Aj and Ap rates is determined
automatically by the fitting procedure to avoid manual and somehow
subjective choices in the transitions.

This codes produces a dataframe, called Bilan which includes the
folowing column:

    Bilan=read.csv(file='Bilan.csv',header = TRUE)
    knitr::kable(Bilan)

<table style="width:100%;">
<colgroup>
<col style="width: 1%" />
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
<col style="width: 5%" />
<col style="width: 3%" />
<col style="width: 4%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Column_Names</th>
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
<td style="text-align: left;">Definition</td>
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
<td style="text-align: left;">Unit</td>
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

It is also possible to estimate Vcmax25 by the one point method (De
Kauwe et al. 2016; Burnett et al. 2019). In that case, the measurements
should be done at saturating irradiance in ambient CO2 conditions. You
can use the function f.fit\_One\_Point() to estimate Vcmax25. It will
produce the exact same data frame as when using the function f.fit\_Aci.

## Adding the leaf spectra data and the leaf metadata information

We merge the fitted parameters, the spectra and the leaf information in
the code called ‘3\_Combine\_spectra\_traits.R’. This code produces a
dataframe with as columns:

    Spectra=read.csv(file='Spectra.csv',header = TRUE)
    knitr::kable(Spectra)

<table>
<colgroup>
<col style="width: 1%" />
<col style="width: 3%" />
<col style="width: 4%" />
<col style="width: 2%" />
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 3%" />
<col style="width: 5%" />
<col style="width: 15%" />
<col style="width: 17%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 4%" />
<col style="width: 2%" />
<col style="width: 3%" />
<col style="width: 4%" />
<col style="width: 1%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Column_Names</th>
<th style="text-align: left;">SampleID</th>
<th style="text-align: left;">SampleID_num</th>
<th style="text-align: left;">Dataset</th>
<th style="text-align: left;">Species</th>
<th style="text-align: left;">Growth_environment</th>
<th style="text-align: left;">Plant_type</th>
<th style="text-align: left;">Vcmax_method</th>
<th style="text-align: left;">Vcmax25</th>
<th style="text-align: left;">Jmax25</th>
<th style="text-align: left;">TPU25</th>
<th style="text-align: left;">Tleaf</th>
<th style="text-align: left;">Spectra</th>
<th style="text-align: left;">LMA</th>
<th style="text-align: left;">Narea</th>
<th style="text-align: left;">N</th>
<th style="text-align: left;">LWC</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Definition</td>
<td style="text-align: left;">Identifier of the measured leaf</td>
<td style="text-align: left;">Integer Identifier of the measured
leaf</td>
<td style="text-align: left;">Name of the dataset folder</td>
<td style="text-align: left;">Full species name for example Cecropia
insignis</td>
<td style="text-align: left;">Growth environment for the measured plant
(Natural, Glasshouse, Managed)</td>
<td style="text-align: left;">Type of plant (Wild or Agricultural)</td>
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
<td style="text-align: left;">Nitrogen content in percentage of dry
mass</td>
<td style="text-align: left;">Leaf water content</td>
</tr>
<tr class="even">
<td style="text-align: left;">Unit</td>
<td style="text-align: left;"></td>
<td style="text-align: left;">Integer</td>
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
<td style="text-align: left;">percent 0 - 100</td>
</tr>
</tbody>
</table>

Note that the reflectance wavelength stored in the Spectra data should
be from 350 nm to 2500 nm with 1 nm interval. If you dont have values
for 350 nm to 500 nm or from 2400 nm to 2500 nm, that is not a problem,
you can put NA in those wavelengths.

The columns LMA, Narea and LWC do not neccessary need to be filled if
you don’t have the data.

For the species name, please write “Genus species”, for exemple
Cercropia insignis. If you know the genus but not the species, write for
example “Cecropia species”. If you dont know the genus, write “Family
genus” for example (Urticaceae genus). If you don’t know anything, well
you can write “Unknown”.
