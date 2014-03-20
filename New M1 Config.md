# New M1 Config

* obtain council data
* order and download Vicmap data
* create new folder _Council Name_ based on client name
* copy INI and SQL files from similar site (based on an existing site using the same property system) into new folder
* look up [LGA code](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/Reference/VMADMIN_LGA.csv) and update INI settings in Process Vicmap task and SQL files

Ask council

* any status codes for filtering properties?
* number of properties at date of extract
* example retired/cancelled/historic/dummy property numbers
* assign 'NCPR' to all common properties?
* SHP or TAB?
* folder location for Vicmap Address
* folder location for Vicmap Property Simplified 1
* file location of any rural address table
* rural addressing (separate table and/or flag in property system)

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
  * check for parcels without properties: `select * from pc_council_parcel where propnum not in ( select propnum from pc_council_property_address )`
  * check for properties without parcels: `select * from pc_council_property_address where propnum not in ( select propnum from pc_council_parcel )`
* check for blank values in road_type field: `select * from pc_council_property_address where road_type = ''`
* update/create PIQA query
* create SPEAR task
* generate 'sampler' query (10 records from each edit code)
* copy/paste results into audit template and email to council

Await feedback...

* adjust configuration as required
* generate M1
* send to council

Await feedback...

* send instructions for installing and running Pozi Connect, and/or
* organise site visit
