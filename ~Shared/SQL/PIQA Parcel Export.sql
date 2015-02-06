select distinct
    propnum,
    status,
    crefno,
    spi,
    summary
from
    pc_council_parcel
order by
    cast ( propnum as integer )