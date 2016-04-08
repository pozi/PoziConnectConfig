update pc_council_property_address
set
    distance_related_flag = ifnull ( ( select replace ( replace ( upper ( distance_based ) , 'T' , 'Y' ) , 'F' , 'N' ) from campaspe_rural_road_numbers ra where ra.prop_num = pc_council_property_address.propnum and ra.road_number = pc_council_property_address.house_number_1 ) , '' ) ,
    easting =  ifnull ( ( select round ( X ( geometry ) , 0 ) from campaspe_rural_road_numbers ra where ra.prop_num = pc_council_property_address.propnum and ra.road_number = pc_council_property_address.house_number_1 ) , '' ) ,
    northing = ifnull ( ( select round ( Y ( geometry ) , 0 ) from campaspe_rural_road_numbers ra where ra.prop_num = pc_council_property_address.propnum and ra.road_number = pc_council_property_address.house_number_1 ) , '' ) ,
    datum_proj = ifnull ( ( select 'EPSG:' || SRID ( geometry ) from campaspe_rural_road_numbers ra where ra.prop_num = pc_council_property_address.propnum and ra.road_number = pc_council_property_address.house_number_1 ) , '' ) ,
    outside_property = ifnull ( ( select replace ( replace ( upper ( outside_property ) , 'T' , 'Y' ) , 'F' , 'N' ) from campaspe_rural_road_numbers ra where ra.prop_num = pc_council_property_address.propnum and ra.road_number = pc_council_property_address.house_number_1 ) , '' )
where
    propnum in ( select prop_num from campaspe_rural_road_numbers where geometry is not null )