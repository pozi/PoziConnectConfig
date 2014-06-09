select distinct
    assnum,
    spi
from
    pc_council_parcel
where
    assnum <> ''
order by
    cast ( assnum as integer ) , spi