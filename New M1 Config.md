# New M1 Config

* obtain council data
* order and download Vicmap data
* create new folder _Council Name_ based on client name
* copy INI and SQL files from similar site (based on an existing site using the same property system) into new folder
* look up [LGA code](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADMIN_LGA.csv) and update INI settings in Process Vicmap task and SQL files

Ask council

* are there any "dummy" property numbers?
* assign 'NCPR' to all common properties?

For each of Parcel and Property/Address SQL:

* replace tabs with spaces (4)
* convert upper case SQL syntax to lower case (edit manually or try [Instant SQL Formatter](http://www.dpriver.com/pp/sqlformat.htm))
* replace old field names (if using existing PIQA SQL as a starting point)
* add expression for num_road_address/ezi_address or spi/simple_spi
* include any necessary expression in road name standardise with Vicmap
  * replace (apostrophe) with (blank)
  * replace & with AND
  * replace ' - ' with '-'
  * etc
* ensure propnum and crefno fields are character fields
* remove any unneeded fields
* eliminate null values (replace with blanks if appropriate), *especially spi, propnum*
* test query against council's data
* check that address values comply with:
  * [BLG_UNIT_TYPE](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADD_BLG_UNIT_TYPE.csv)
  * [FLOOR_TYPE](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADD_FLOOR_TYPE.csv)
  * [LOCATION_DESCRIPTOR](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADD_LOCATION_DESCRIPTOR.csv)
* test if the Parcel and Property/Address queries return the same set of property numbers
  * check for parcels without properties
  * check for properties without parcels
* update/create PIQA query

Supply to council

* select 10 properties from the 'S' list - ask if they're satisfied with the  address we've extracted
* select 10 properties from the 'E' and 'R' lists - ask if they're satisfied for them  to be retired
* select 10 properties from the 'A' list - ask if they're satisfied with them being added as multi-assessments
* select 10 properties from the 'C' list (mix of new and replacement records)
* select 10 properties from the 'P' list (mix of new and replacement records)

Await feedback, adjust configuration as required, generate M1, send to council
