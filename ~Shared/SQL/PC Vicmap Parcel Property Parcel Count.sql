select distinct
    spi,
    ( select count(*) from PC_Vicmap_Parcel t where t.spi = vicmap_parcel.spi group by t.spi ) as num_parcels_in_prop
from PC_Vicmap_Parcel vicmap_parcel
where spi is not null
order by plan_number, lot_number