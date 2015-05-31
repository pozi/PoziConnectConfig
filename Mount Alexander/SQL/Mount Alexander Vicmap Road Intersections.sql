select
    *,
    x ( geometry ) as x,
    y ( geometry ) as y
from
(
select
    a.pfi as pfi,
    a.road_index,
    b.pfi as intersecting_pfi,
    replace ( replace ( b.road_name , ' ' , '' ) , '-' , '' ) as intersecting_road_name,
    CastToPoint ( ST_Intersection ( a.geometry , b.geometry ) ) as geometry
from
    vmtrans_road_mod a,
    vmtrans_road_mod b
where
    a.road_index <> b.road_index and
    ST_Touches ( a.geometry , b.geometry )
)