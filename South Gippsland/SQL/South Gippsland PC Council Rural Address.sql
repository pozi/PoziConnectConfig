update pc_council_property_address
set
    distance_related_flag = ifnull (
        ( select
            case
                when upper ra.dist_flag = 'N' then 'N'
                else 'Y'
            end from sgsc_rural_address ra
            where
                ra.prop_key = pc_council_property_address.propnum and
                ra.house = cast ( pc_council_property_address.house_number_1 as integer )  , '' ) ,
    easting = ifnull ( ( select round ( X ( geometry ) , 0 ) from sgsc_rural_address ra where ra.prop_key = pc_council_property_address.propnum and ra.house = cast ( pc_council_property_address.house_number_1 as integer ) ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from sgsc_rural_address ra where ra.prop_key = pc_council_property_address.propnum and ra.house = cast ( pc_council_property_address.house_number_1 as integer ) ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from sgsc_rural_address ra where ra.prop_key = pc_council_property_address.propnum and ra.house = cast ( pc_council_property_address.house_number_1 as integer ) ) , '' ) ,
    outside_property = ifnull ( ( select ra.outside from sgsc_rural_address ra where ra.prop_key = pc_council_property_address.propnum and ra.house = cast ( pc_council_property_address.house_number_1 as integer ) ) , '' )
where
    propnum in ( select prop_key from sgsc_rural_address where prop_key <> '' and geometry is not null ) and
    is_primary <> 'N'
