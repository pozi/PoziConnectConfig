select
    spi,
    status,
    count(*) as num_props
from PC_Vicmap_Parcel
group by spi, status
order by num_props desc