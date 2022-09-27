## Creation of a Dataset folder

Each dataset is put into a folder called “Names\_Year” for example
“Serbin\_et\_al\_2019”. We recommand to put into the folder the article
associated with the dataset or the protocol of measurement, which should
include the description of the gas exchange, spectrometers, and of the
species.

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

The idea of this project is to include the raw A-Ci data so we can
re-fit the curves and estimate Vcmax using the same fitting procedure
for all the datasets.

We have requirements for the final A-Ci data to be used by the fitting
procedure. However, we don’t have hard requirements in the way to obtain
this final data.

The A-Ci data should be cleaned from spurious measurements and points
that would impact Vcmax or Jmax estimation should not be included.

    Description=read.csv(file='Aci_data.csv')
    knitr::kable(Description, "html")

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
record
</th>
<th style="text-align:left;">
A
</th>
<th style="text-align:left;">
Ci
</th>
<th style="text-align:left;">
CO2s
</th>
<th style="text-align:left;">
gsw
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
Definition,Identifier of the measured leaf,Observation record number
(also called Obs in some gas exchange instruments),Net CO2 exchange per
leaf area,Intercellular CO? concentration in air,CO2 concentration in
wet air inside the chamber,stomatal conductance to water vapor per leaf
area,Atmospheric pressure,"In chamber photosynthetic flux density
incident on the leaf, quanta per area",Leaf surface temperature
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
Unit
</td>
<td style="text-align:left;">
NA
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
micromol mol-1
</td>
<td style="text-align:left;">
mmol m-2 s-1
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
