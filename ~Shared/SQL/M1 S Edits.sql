select
    council_address.propnum,
    council_address.num_road_address,
	'S' as edit_code,
	'replacing old address: ' || vicmap_address.num_road_address as comments
from
    PC_Council_Property_Address council_address,
    PC_Vicmap_Property_Address vicmap_address
where
    council_address.propnum = vicmap_address.propnum and
	council_address.num_road_address <> vicmap_address.num_road_address

union

select
    council_address.propnum,
    council_address.num_road_address,
	'S' as edit_code,
	'adding new property address' as comments
from
    PC_Council_Property_Address council_address
where
    propnum not in ( select propnum from PC_Vicmap_Property_Address where propnum is not null )