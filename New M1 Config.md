# New M1 Config

* create new folder based on client name
* copy INI and SQL files from similar site (based on an existing site using the same property system)

For each of Parcel and Property/Address SQL:

* replace old field names (if using existing PIQA SQL)
* add expression for num_road_address or spi/simple_spi
* replace tabs with spaces
* convert upper case syntax to lower case
* ensure propnum and crefno fields are character
* remove unneeded fields
* test query against council's sqlite database
* eliminate null values (replace with blanks if appropriate), *especially spi, propnum*


