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
world map.

    Description=read.csv(file='Description.csv')
    knitr::kable(Description, "html")

<table>
<thead>
<tr>
<th style="text-align:left;">
Authors
</th>
<th style="text-align:left;">
Acknowledgment
</th>
<th style="text-align:left;">
Dataset\_DOI
</th>
<th style="text-align:left;">
Publication\_Citation
</th>
<th style="text-align:left;">
Email
</th>
<th style="text-align:left;">
Lat
</th>
<th style="text-align:left;">
Long
</th>
<th style="text-align:left;">
Elevation
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
List of authors of the dataset
</td>
<td style="text-align:left;">
Acknowledgement of funding and help to generate the dataset
</td>
<td style="text-align:left;">
Digital Object Identifier (DOI) associated with the dataset if the
dataset was published
</td>
<td style="text-align:left;">
Full citation associated with the paper that uses the dataset
</td>
<td style="text-align:left;">
Contact email for the dataset
</td>
<td style="text-align:left;">
Latitude of the dataset site study in decimal units (Y)
</td>
<td style="text-align:left;">
Longitude of the dataset site study in decimals units (X)
</td>
<td style="text-align:left;">
Elevation of the dataset site study if known.
</td>
</tr>
</tbody>
</table>

## Adding the gas exchange A-Ci data to the dataset folder

The idea of this project is to include the raw A-Ci data so we can fit
the curves and estimate Vcmax using the same method for all datasets.

We have requirements for the final A-Ci data to be used by the fitting
procedure (see table below with the needed column names). However, we
don’t have hard requirements in the way to obtain this final data. Note
that the SampleID\_num column will be used by the fitting procedure to
identify individual A-Ci curves. If you made several A-Ci curves on the
same leaf we recommend to only keep the best one. We decided to use a
column SampleId and a column SampleID\_num. SampleID should correspond
to the original identifier of the leaves in the raw dataset which is
often a complex string. The column SampleID\_num should be an integer.
We made the choice to use the SampleID\_num to facilitate the QAQC of
the curves and the ploting of the figures (title name).

The A-Ci data should be cleaned from spurious measurements and points
that would impact Vcmax or Jmax estimation should not be included.

The curated A-Ci data should be present in the dataset folder in a Rdata
format called ‘1\_QC\_data.Rdata’ which contains the A-Ci data in a
data.frame with at least the columns listed in the table below.

Note that we usually include in the dataset folder the raw data, as well
as the R code used to read, import and transform the raw data. All those
preliminary steps are made in a R code called
‘Import\_transform\_original\_ACi\_data.R’.We recommend to do the same,
but again, we don’t have requirements on the code to do that.

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
    knitr::kable(Aci_data, "html")

<table>
<thead>
<tr>
<th style="text-align:left;">
Column\_Names
</th>
<th style="text-align:left;">
SampleID
</th>
<th style="text-align:left;">
SampleID\_num
</th>
<th style="text-align:left;">
A
</th>
<th style="text-align:left;">
Ci
</th>
<th style="text-align:left;">
Patm
</th>
<th style="text-align:left;">
Qin
</th>
<th style="text-align:left;">
Tleaf
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Definition
</td>
<td style="text-align:left;">
Identifier of the measured leaf
</td>
<td style="text-align:left;">
Integer Identifier of the measured leaf
</td>
<td style="text-align:left;">
Net CO2 exchange per leaf area
</td>
<td style="text-align:left;">
Intercellular CO2 concentration in air
</td>
<td style="text-align:left;">
Atmospheric pressure
</td>
<td style="text-align:left;">
In chamber photosynthetic flux density incident on the leaf in quanta
per area
</td>
<td style="text-align:left;">
Leaf surface temperature
</td>
</tr>
<tr>
<td style="text-align:left;">
Unit
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Integer
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol mol-1
</td>
<td style="text-align:left;">
kPa
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
degrees celcius
</td>
</tr>
</tbody>
</table>

## Fitting the A\_Ci data to estimate the photosynthetic traits

The fitting of each individual curves is done using the package
LeafGasExchange by a R code called ‘2\_Fit\_ACi.R’ included in each
dataset folder.

This code produces several pdf files:

-   2\_ACi\_fitting\_Ac.pdf

-   2\_ACi\_fitting\_Ac\_Aj.pdf

-   2\_ACi\_fitting\_Ac\_Aj\_Ap.pdf

and

-   2\_ACi\_fitting\_best\_model.pdf

The first three pdf shows the fitting of each A-Ci curves when including
the rate of maximum carboxylation (Ac), the rate of electron transport
(Aj) and the rate of triose phosphate utilisation (Ap). The best model
corresponds to the model with the lowest AIC that includes Ac or Ac + Aj
or Ac + Aj + Ap.

Note that in all the cases, the transition between Ac, Aj and Ap rates
is determined automatically by the fitting procedure to avoid manual and
somehow subjective choices in the transitions (References).

This codes produces a dataframe, called Bilan which includes the
folowing column:

    Bilan=read.csv(file='Bilan.csv')
    knitr::kable(Bilan, "html")

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:left;">
Column\_Names
</th>
<th style="text-align:left;">
SampleID
</th>
<th style="text-align:left;">
SampleID\_num
</th>
<th style="text-align:left;">
Vcmax25
</th>
<th style="text-align:left;">
Jmax25
</th>
<th style="text-align:left;">
TPU25
</th>
<th style="text-align:left;">
Rday25
</th>
<th style="text-align:left;">
Tleaf
</th>
<th style="text-align:left;">
Vcmax
</th>
<th style="text-align:left;">
Jmax
</th>
<th style="text-align:left;">
TPU
</th>
<th style="text-align:left;">
Rday
</th>
<th style="text-align:left;">
sigma
</th>
<th style="text-align:left;">
AIC
</th>
<th style="text-align:left;">
model
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Definition
</td>
<td style="text-align:left;">
Identifier of the measured leaf
</td>
<td style="text-align:left;">
Integer Identifier of the measured leaf
</td>
<td style="text-align:left;">
Maximum rate of carboxylation at the reference temperature 25 degrees
celcius calculated assuming infinite mesophyl conductance i.e. apparent
Vcmax
</td>
<td style="text-align:left;">
Maximum rate of electron transport per leaf area at the reference
temperature 25 degrees celcius calculated assuming infinite mesophyll
conductance and saturating light
</td>
<td style="text-align:left;">
Triose phosphate utilization rate per leaf area at the reference
temperature 25 degrees celcius
</td>
<td style="text-align:left;">
CO2 release from the leaf in the light at the reference temperature of
25 degrees celcius
</td>
<td style="text-align:left;">
Leaf surface temperature
</td>
<td style="text-align:left;">
Maximum rate of carboxylation at measurement temperature calculated
assuming infinite mesophyl conductance i.e. apparent Vcmax
</td>
<td style="text-align:left;">
Maximum rate of electron transport per leaf area at measurement
temperature calculated assuming infinite mesophyll conductance and
saturating light
</td>
<td style="text-align:left;">
Triose phosphate utilization rate per leaf area at measurement
temperature
</td>
<td style="text-align:left;">
CO2 release from the leaf in the light at measurement temperature
</td>
<td style="text-align:left;">
standard error of the residuals of the fitted A-Ci curve
</td>
<td style="text-align:left;">
Akaike information criterion
</td>
<td style="text-align:left;">
Model used for the fitting of the A-Ci curves
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
Unit
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
Integer
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
degrees celcius
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
micromol m-2 s-1
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
NA
</td>
</tr>
</tbody>
</table>

## Adding the leaf species and metadata information

In the code ‘2\_Fit\_ACi.R’ we add the sample information to the the
dataframe Bilan that contains the photosynthetic parameters.

XXX Column

## Adding the leaf spectra data
