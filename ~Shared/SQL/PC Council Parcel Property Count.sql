select
    spi,
    status,
    count(*) as num_props,
    group_concat ( propnum , ';' ) as propnums
from pc_council_parcel
where propnum in ( select propnum from pc_council_property_address )
group by spi, status
order by num_props desc