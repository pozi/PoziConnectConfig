select
    pfi,
    road_index,
    MakePoint ( centroid_x , centroid_y ) as geometry
from vmtrans_road_mod