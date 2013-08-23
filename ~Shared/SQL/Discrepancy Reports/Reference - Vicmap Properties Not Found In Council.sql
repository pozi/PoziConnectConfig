select
    'Property number ' || vicmap_address.propnum || ' is found in Vicmap, but not in the Council''s property system' as comments,
    vicmap_address.propnum,
    vicmap_address.num_road_address,
    vicmap_address.locality_name
from
    PC_Vicmap_Property_Address as vicmap_address
where
    propnum not in ( '' , 'NCPR' ) and
    propnum not in ( select propnum from PC_Council_Property_Address )