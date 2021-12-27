update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select substr ( Distance_Related_Flag__Yes_No_ , 1 , 1 ) from cgsc_rural_address ra where ra.Property_Number = pc_council_property_address.propnum ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from cgsc_rural_address ra where ra.Property_Number = pc_council_property_address.propnum ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from cgsc_rural_address ra where ra.Property_Number = pc_council_property_address.propnum ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from cgsc_rural_address ra where ra.Property_Number = pc_council_property_address.propnum ) , '' ) ,
    outside_property = ifnull ( ( select substr ( Outside_Property__Yes_No_ , 1 , 1 ) from cgsc_rural_address ra where ra.Property_Number = pc_council_property_address.propnum ) , '' )
where
    propnum in ( select Property_Number from cgsc_rural_address )
    