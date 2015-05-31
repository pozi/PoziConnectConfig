select
    CastToLinestring ( geometry ) as geometry,
    *,
    replace ( replace ( road_name , ' ' , '' ) , '-' , '' ) || road_type || road_suffix || replace ( left_locality , ' ' , '' ) as road_index,
    ( x ( StartPoint ( geometry ) ) + x ( EndPoint ( geometry ) ) ) / 2 as centroid_x,
    ( y ( StartPoint ( geometry ) ) + y ( EndPoint ( geometry ) ) ) / 2 as centroid_y,
    x ( StartPoint ( geometry ) ) as start_x,
    y ( StartPoint ( geometry ) ) as start_y,
    x ( EndPoint ( geometry ) ) as end_x,
    y ( EndPoint ( geometry ) ) as end_y
from vmtrans_road

union

select
    CastToLinestring ( geometry ) as geometry,
    *,
    replace ( replace ( road_name , ' ' , '' ) , '-' , '' ) || road_type || road_suffix || replace ( right_locality , ' ' , '' ) as road_index,
    ( x ( StartPoint ( geometry ) ) + x ( EndPoint ( geometry ) ) ) / 2 as centroid_x,
    ( y ( StartPoint ( geometry ) ) + y ( EndPoint ( geometry ) ) ) / 2 as centroid_y,
    x ( StartPoint ( geometry ) ) as start_x,
    y ( StartPoint ( geometry ) ) as start_y,
    x ( EndPoint ( geometry ) ) as end_x,
    y ( EndPoint ( geometry ) ) as end_y
from vmtrans_road
