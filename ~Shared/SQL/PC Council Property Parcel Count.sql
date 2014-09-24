select
    propnum,
    status,
    count(*) as num_parcels,
    group_concat ( spi , ';' ) as spis
from pc_council_parcel
group by propnum, status
order by num_parcels desc