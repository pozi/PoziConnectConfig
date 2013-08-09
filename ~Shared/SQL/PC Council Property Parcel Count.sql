select
    propnum,
    status,
    count(*) as num_parcels
from PC_Council_Parcel
group by propnum, status
order by num_parcels desc