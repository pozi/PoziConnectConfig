select
    spi,
    status,
    count(*) as num_props
from pc_vicmap_parcel
group by spi, status
order by num_props desc