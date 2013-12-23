update PC_Council_Property_Address
set
    is_primary = ( select case when is_primary = 'T' then 'Y' else 'N' end from SHRCC_Rural_Address where SHRCC_Rural_Address.ra_complete = PC_Council_Property_Address.num_road_address ),
    distance_related_flag = 'Y' ,
    easting = ( select xcoord from SHRCC_Rural_Address where SHRCC_Rural_Address.ra_complete = PC_Council_Property_Address.num_road_address ),
    northing = ( select ycoord from SHRCC_Rural_Address where SHRCC_Rural_Address.ra_complete = PC_Council_Property_Address.num_road_address ),    
    datum_proj = 'MGA Zone 54 (GDA 94)'
where
    num_road_address in ( select ra_complete from SHRCC_Rural_Address where ra_complete <> '' and xcoord > 0 and ycoord > 0 )
