delete
from pc_council_parcel
where
    spi <> '' and
    spi in (
        select spi
            from pc_council_parcel
            where status in ( '' , 'A' ) ) and
    spi in (
        select spi
            from pc_council_parcel
            where status = 'P' ) and
    status in ( '' , 'A' )