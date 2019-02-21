update pc_council_property_address
set
    is_primary = ifnull ( ( select is_primary from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    distance_related_flag =  ifnull ( ( select dist_related_flag from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property =  ifnull ( ( select outside_property from cogb_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) 
where
    propnum in ( select propnum from cogb_rural_address where geometry is not null )
