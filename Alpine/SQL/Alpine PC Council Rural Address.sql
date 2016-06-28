update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select 'Y' from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    easting = ifnull ( ( select cast ( cast ( ra.easting as integer ) as varchar ) from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select cast ( cast ( ra.northing as integer ) as varchar ) from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select ra.datum_proj from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select ra.outside_property from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' ) ,
    is_primary = ifnull ( ( select ra.is_primary from asc_rural_address ra where ra.propnum = pc_council_property_address.propnum and ra.house_number_1 = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select propnum from asc_rural_address ra where ra.propnum <> '' )
