update pc_council_property_address
set
    distance_related_flag = ifnull (
        ( select
            case
                when ra.distancerelated = 'T' then 'Y'
                else 'N'
            end from lsc_rural_address ra
            where
                ra.prop_no = pc_council_property_address.propnum and
                ra.rural_no = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select X ( geometry ) from lsc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select Y ( geometry ) from lsc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from lsc_rural_address ra where ra.prop_no = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select prop_no from lsc_rural_address where prop_no <> '' and geometry is not null ) and
    is_primary <> 'N'
