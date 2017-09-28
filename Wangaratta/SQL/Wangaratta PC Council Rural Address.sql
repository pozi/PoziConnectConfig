update pc_council_property_address
set
    is_primary = ifnull ( ( select replace ( replace ( upper ( ra."primary" ) , 'T' , 'Y' ) , 'F' , 'N' ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' ) ,
    distance_related_flag =  ifnull ( ( select replace ( replace ( upper ( ra."dist_related_flag" ) , 'T' , 'Y' ) , 'F' , 'N' ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select replace ( replace ( upper ( ra."os_poly_flag" ) , 'T' , 'Y' ) , 'F' , 'N' ) from wrcc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1= pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select propnum from wrcc_rural_address where geometry is not null )
