# Reference

### Updating CSV Files

MapBasic code supplied is for recreating the CSV files from the VMREFTAB download (in MapInfo format).

To use
* copy and paste code snippets below into text editor
* search and replace to change directory path as required
* copy and paste into MapBasic window in MapInfo Professional
* highlight all code and hit `Enter`

## Vicmap Address

```mapbasic
Open Table "D:\Data\VMREFTAB\table\ADDRESS_ACCESS_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_BLG_UNIT_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_CLASS.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_DISTANCE_RELATED_FLAG.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_FEATURE_QUALITY.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_FLOOR_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_GEOCODE_FEATURE.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_HOTEL_STYLE_FLAG.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_IS_PRIMARY.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_LOCATION_DESCRIPTOR.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_OUTSIDE_PROPERTY.tab"
Open Table "D:\Data\VMREFTAB\table\ADDRESS_SOURCE.tab"

Export "ADDRESS_ACCESS_TYPE" Into "D:\Data\VMREFTAB\table\VMADD_ACCESS_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_BLG_UNIT_TYPE" Into "D:\Data\VMREFTAB\table\VMADD_BLG_UNIT_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_CLASS" Into "D:\Data\VMREFTAB\table\VMADD_CLASS.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_DISTANCE_RELATED_FLAG" Into "D:\Data\VMREFTAB\table\VMADD_DISTANCE_RELATED_FLAG.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_FEATURE_QUALITY" Into "D:\Data\VMREFTAB\table\VMADD_FEATURE_QUALITY.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_FLOOR_TYPE" Into "D:\Data\VMREFTAB\table\VMADD_FLOOR_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_GEOCODE_FEATURE" Into "D:\Data\VMREFTAB\table\VMADD_GEOCODE_FEATURE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_HOTEL_STYLE_FLAG" Into "D:\Data\VMREFTAB\table\VMADD_HOTEL_STYLE_FLAG.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_IS_PRIMARY" Into "D:\Data\VMREFTAB\table\VMADD_IS_PRIMARY.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_LOCATION_DESCRIPTOR" Into "D:\Data\VMREFTAB\table\VMADD_LOCATION_DESCRIPTOR.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_OUTSIDE_PROPERTY" Into "D:\Data\VMREFTAB\table\VMADD_OUTSIDE_PROPERTY.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ADDRESS_SOURCE" Into "D:\Data\VMREFTAB\table\VMADD_SOURCE.csv" Type "ASCII" Delimiter "," Titles Overwrite

Open Table "D:\Data\VMREFTAB\table\ROAD_SUFFIX.tab"
Open Table "D:\Data\VMREFTAB\table\ROAD_TYPE.tab"

Export "ROAD_SUFFIX" Into "D:\Data\VMREFTAB\table\VMADD_ROAD_SUFFIX.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "ROAD_TYPE" Into "D:\Data\VMREFTAB\table\VMADD_ROAD_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
```

## Vicmap Admin

```mapbasic
Open Table "D:\Data\VMREFTAB\table\LGA.tab"
Open Table "D:\Data\VMREFTAB\table\PARISH.tab"
Open Table "D:\Data\VMREFTAB\table\PARISH_TOWN.tab"
Open Table "D:\Data\VMREFTAB\table\TOWNSHIP.tab"

Export "LGA" Into "D:\Data\VMREFTAB\table\VMADMIN_LGA.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PARISH" Into "D:\Data\VMREFTAB\table\VMADMIN_PARISH.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PARISH_TOWN" Into "D:\Data\VMREFTAB\table\VMADMIN_PARISH_TOWN.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "TOWNSHIP" Into "D:\Data\VMREFTAB\table\VMADMIN_TOWNSHIP.csv" Type "ASCII" Delimiter "," Titles Overwrite
```

## Vicmap Property

```mapbasic
Open Table "D:\Data\VMREFTAB\table\PR_CROWN_STATUS.tab"
Open Table "D:\Data\VMREFTAB\table\PR_DESC_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\PR_FOOTPRINT_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\PR_GRAPHIC_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\PR_INTERSECTION.tab"
Open Table "D:\Data\VMREFTAB\table\PR_MULTI_ASSESSMENT.tab"
Open Table "D:\Data\VMREFTAB\table\PR_PART.tab"
Open Table "D:\Data\VMREFTAB\table\PR_PLAN_NUMBER.tab"
Open Table "D:\Data\VMREFTAB\table\PR_PROPERTY_TYPE.tab"
Open Table "D:\Data\VMREFTAB\table\PR_SPI.tab"
Open Table "D:\Data\VMREFTAB\table\PR_STATUS.tab"
Open Table "D:\Data\VMREFTAB\table\PR_TRANSFERRABLE.tab"

Export "PR_CROWN_STATUS" Into "D:\Data\VMREFTAB\table\VMPROP_CROWN_STATUS.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_DESC_TYPE" Into "D:\Data\VMREFTAB\table\VMPROP_DESC_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_FOOTPRINT_TYPE" Into "D:\Data\VMREFTAB\table\VMPROP_FOOTPRINT_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_GRAPHIC_TYPE" Into "D:\Data\VMREFTAB\table\VMPROP_GRAPHIC_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_INTERSECTION" Into "D:\Data\VMREFTAB\table\VMPROP_INTERSECTION.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_MULTI_ASSESSMENT" Into "D:\Data\VMREFTAB\table\VMPROP_MULTI_ASSESSMENT.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_PART" Into "D:\Data\VMREFTAB\table\VMPROP_PART.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_PLAN_NUMBER" Into "D:\Data\VMREFTAB\table\VMPROP_PLAN_NUMBER.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_PROPERTY_TYPE" Into "D:\Data\VMREFTAB\table\VMPROP_PROPERTY_TYPE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_SPI" Into "D:\Data\VMREFTAB\table\VMPROP_SPI.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_STATUS" Into "D:\Data\VMREFTAB\table\VMPROP_STATUS.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "PR_TRANSFERRABLE" Into "D:\Data\VMREFTAB\table\VMPROP_TRANSFERRABLE.csv" Type "ASCII" Delimiter "," Titles Overwrite
```

## Vicmap Reference Tables

```mapbasic
Open Table "D:\Data\VMREFTAB\table\REFERENCE_TABLE.tab"
Open Table "D:\Data\VMREFTAB\table\REFERENCE_TABLE_RELATIONSHIP.tab"

Export "REFERENCE_TABLE" Into "D:\Data\VMREFTAB\table\VMREFTAB_REFERENCE_TABLE.csv" Type "ASCII" Delimiter "," Titles Overwrite
Export "REFERENCE_TABLE_RELATIONSHIP" Into "D:\Data\VMREFTAB\table\VMREFTAB_REFERENCE_TABLE_RELATIONSHIP.csv" Type "ASCII" Delimiter "," Titles Overwrite
```