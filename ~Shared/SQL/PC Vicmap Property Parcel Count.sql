select
    propnum,
    status,
    count(*) as num_parcels
from pc_vicmap_parcel
group by propnum, status
order by num_parcels desc