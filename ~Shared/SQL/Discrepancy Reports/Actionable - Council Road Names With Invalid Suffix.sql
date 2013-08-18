select
    propnum,
    road_name,
    road_type,
    road_suffix,
    locality_name
from
    PC_Council_Property_Address
where
    road_name like '% NORTH' or    
    road_name like '% SOUTH' or      
    road_name like '% EAST' or      
    road_name like '% WEST'