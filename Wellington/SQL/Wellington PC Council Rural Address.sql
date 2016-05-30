update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select 'Y' from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' ) ,
    easting = ifnull ( ( select round ( X ( geometry ) , 0 ) from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:28355' from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' ) ,
    is_primary = ifnull ( ( select case when primary_ = -1 then 'Y' else 'N' end from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' ) ,
    outside_property = ifnull ( ( select case when ospolyflag = -1 then 'Y' else 'N' end from wsc_rural_address ra where ra.assessment = pc_council_property_address.propnum and ra.rural_no = pc_council_property_address.num_address ) , '' )
where
    propnum in ( select assessment from wsc_rural_address ra where ra.assessment <> '' )