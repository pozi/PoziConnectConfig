select
    'Property number ' || council_address.propnum || ' is found in Council''s property system, but not in Vicmap' as comments,
    council_address.propnum,
    council_address.num_road_address,
    council_address.locality_name
from
    PC_Council_Property_Address as council_address
where
    propnum not in ( '' , 'NCPR' ) and
    propnum not in ( select propnum from PC_Vicmap_Property_Address )