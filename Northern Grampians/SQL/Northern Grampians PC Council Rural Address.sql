update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select distance_r from nsc_rural_address ra where propnum = pc_council_property_address.propnum and ra.house_numb = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from nsc_rural_address ra where propnum = pc_council_property_address.propnum and ra.house_numb = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from nsc_rural_address ra where propnum = pc_council_property_address.propnum and ra.house_numb = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from nsc_rural_address ra where propnum = pc_council_property_address.propnum and ra.house_numb = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select outside_p from nsc_rural_address ra where propnum = pc_council_property_address.propnum and ra.house_numb = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select propnum from nsc_rural_address where propnum <> '' and geometry is not null ) and
    is_primary <> 'N'
