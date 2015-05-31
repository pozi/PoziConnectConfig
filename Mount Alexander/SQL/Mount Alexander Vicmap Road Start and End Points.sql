select
    cast ( min ( pfi ) as integer ) as pfi,
    road_index,
    count(*) as road_connectivity,
    x ( geometry ) as x,
    y ( geometry ) as y,
    geometry
from
(
    select
        pfi,
        road_index,
        StartPoint ( geometry ) as geometry from ( select pfi , road_index , geometry from vmtrans_road_mod ) a
    union all
    select
        pfi,
        road_index,
        EndPoint ( geometry ) as geometry
    from ( select pfi , road_index , geometry from vmtrans_road_mod ) b
)
group by geometry
--having count(*) > 2
