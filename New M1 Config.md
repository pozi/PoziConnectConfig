# New M1 Config

* obtain council data
* order and download Vicmap data
* create new folder _Council Name_ based on client name
* copy INI and SQL files from similar site (based on an existing site using the same property system)
  * Tasks\\_Council Name_\\M1 _Council Name_ - 1 - Import _Property System_.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 1.5 - Process _Property System_.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 2 - Import Vicmap _SHPs/TABs_.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 2.5 - Process Vicmap.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 3 - Generate M1.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 3.5 - Generate Discrepancy Reports.ini
  * Tasks\\_Council Name_\\M1 _Council Name_ - 4 - Generate SPEAR Report.ini
  * Tasks\\_Council Name_\\SQL\\_Council Name_ PC Council Parcel.sql
  * Tasks\\_Council Name_\\SQL\\_Council Name_ PC Council Property Address.sql
* look up [LGA code](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADMIN_LGA.csv) and update INI settings in Process Vicmap task and SQL files

For each of Parcel and Property/Address SQL:

* replace tabs with spaces (4)
* convert upper case SQL syntax to lower case
* replace old field names (if using existing PIQA SQL as a starting point)
* add expression for num_road_address/ezi_address or spi/simple_spi
* include expression in road name to replace apostrophes with nothing?
* ensure propnum and crefno fields are character fields
* remove unneeded fields
* eliminate null values (replace with blanks if appropriate), *especially spi, propnum*
* test query against council's data
* test if the Parcel and Property/Address queries return the same set of property numbers
  * check for parcels without properties
  * check for properties without parcels

Ask council

* assign 'NCPR' to all common properties?
* how are parish and township attributes stored?