select
    *
from assetic_road_mod assetic, vmtrans_road_mod road
where
    assetic.road_index = road.road_index and
    assetic.[start_point] like '%' || ( select intersecting_road_name from vmtrans_road_intersections x where x.[pfi] = road.[PFI] ) || '%'