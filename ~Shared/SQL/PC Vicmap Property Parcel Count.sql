select
    propnum,
    status,
    count(*) as num_parcels
from PC_Vicmap_Parcel
group by propnum, status
order by num_parcels desc