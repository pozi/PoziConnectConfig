update pc_council_property_address
set
    is_primary = ifnull ( ( select replace ( replace ( upper ( ra."is_primary_yn" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' ) ,
    distance_related_flag =  ifnull ( ( select replace ( replace ( upper ( ra."distance_related_yn" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select replace ( replace ( upper ( ra."outside_property_yn" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.property_number = pc_council_property_address.propnum and ra.house_number = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select property_number from msc_rural_address where geometry is not null )
