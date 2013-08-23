select
    'Vicmap identifies this property''s locality as ' || vicmap_address.locality_name || ' but Council has it recorded as ' || council_address.locality_name as comments,
    council_address.propnum,
    council_address.num_road_address,
    council_address.locality_name as council_locality,
    vicmap_address.locality_name as vicmap_locality
from
    PC_Council_Property_Address council_address,
    PC_Vicmap_Property_Address vicmap_address
where
    council_address.propnum = vicmap_address.propnum and
    council_address.num_road_address = vicmap_address.num_road_address and    
    council_address.locality_name <> vicmap_address.locality_name