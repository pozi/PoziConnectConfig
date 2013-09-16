select
    'Council address is ' || council_address.ezi_address || ' vs Vicmap address ' || vicmap_address.ezi_address as comments,
    council_address.propnum,
    council_address.ezi_address as council_address,
    vicmap_address.ezi_address as vicmap_address
from
    PC_Council_Property_Address council_address,
    PC_Vicmap_Property_Address vicmap_address
where
    council_address.propnum = vicmap_address.propnum and
    council_address.propnum <> 'NCPR' and
    council_address.num_road_address <> vicmap_address.num_road_address and    
    vicmap_address.is_primary <> 'N' and    
    council_address.is_primary <> 'N'