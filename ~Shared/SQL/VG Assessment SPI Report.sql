select distinct
    assnum,
    crefno,
    spi
from
    pc_council_parcel
where
    assnum <> ''
order by
    cast ( assnum as integer ) , spi