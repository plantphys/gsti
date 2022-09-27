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
