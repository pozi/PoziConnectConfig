update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select 'Y' from csc_rural_address ra where ra.propnum = pc_council_property_address.propnum and cast ( ra.st_no as varchar ) = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from csc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and cast ( ra.st_no as varchar ) = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from csc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and cast ( ra.st_no as varchar ) = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from csc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and cast ( ra.st_no as varchar ) = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select propnum from csc_rural_address where propnum <> '' and geometry is not null )