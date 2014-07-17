update pc_council_property_address
set
    distance_related_flag = 'Y' ,
    easting = ( select easting from lsc_rural_address where lsc_rural_address.prop_no = pc_council_property_address.propnum ) ,
    northing = ( select northing from lsc_rural_address where lsc_rural_address.prop_no = pc_council_property_address.propnum ) ,    
    datum_proj = 'EPSG:28354'
where
    propnum in ( select prop_no from lsc_rural_address where prop_no <> '' and easting > 0 and northing > 0 )
