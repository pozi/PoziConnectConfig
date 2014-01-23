select
    spi,
    status,
    count(*) as num_props
from PC_Council_Parcel
where propnum in ( select propnum from PC_Council_Property_Address )
group by spi, status
order by num_props desc