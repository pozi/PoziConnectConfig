update pc_council_property_address
set
    is_primary = ( select case when is_primary = 'T' then 'Y' else 'N' end from shrcc_rural_address where shrcc_rural_address.ra_complete = pc_council_property_address.num_road_address ),
    distance_related_flag = 'Y' ,
    easting = ( select xcoord from shrcc_rural_address where shrcc_rural_address.ra_complete = pc_council_property_address.num_road_address ),
    northing = ( select ycoord from shrcc_rural_address where shrcc_rural_address.ra_complete = pc_council_property_address.num_road_address ),    
    datum_proj = 'MGA Zone 54 (GDA 94)'
where
    num_road_address in ( select ra_complete from shrcc_rural_address where ra_complete <> '' and xcoord > 0 and ycoord > 0 )
