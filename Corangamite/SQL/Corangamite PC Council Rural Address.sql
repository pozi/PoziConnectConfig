update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select 'Y' from csc_rural_address ra where ra.prop_propnum = pc_council_property_address.propnum and ra.st_no = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from csc_rural_address ra where ra.prop_propnum = pc_council_property_address.propnum and ra.st_no = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from csc_rural_address ra where ra.prop_propnum = pc_council_property_address.propnum and ra.st_no = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from csc_rural_address ra where ra.prop_propnum = pc_council_property_address.propnum and ra.st_no = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select prop_propnum from csc_rural_address where prop_propnum <> '' and geometry is not null )