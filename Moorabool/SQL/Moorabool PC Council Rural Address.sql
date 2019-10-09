update pc_council_property_address
set
    is_primary = ifnull ( ( select replace ( replace ( upper ( ra."is_primary" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    distance_related_flag =  ifnull ( ( select replace ( replace ( upper ( ra."distance_related_flag" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select replace ( replace ( upper ( ra."outside_property" ) , 'T' , 'Y' ) , 'F' , 'N' ) from msc_rural_address ra where ra.moo_prop_no = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select moo_prop_no from msc_rural_address where geometry is not null )
