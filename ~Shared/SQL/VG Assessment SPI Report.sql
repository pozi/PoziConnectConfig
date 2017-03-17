select distinct
    assnum,
    crefno,
    spi,
    case
        when spi <> '' and cp.spi in ( select spi from pc_vicmap_parcel ) then ifnull ( ( select cast ( round ( st_area ( st_transform ( vp.geometry , 3111 ) ) ) as integer ) from pc_vicmap_parcel vp where vp.spi = cp.spi ) , '' )
        when crefno <> '' then ifnull ( ( select cast ( round ( st_area ( st_transform ( vp.geometry , 3111 ) ) ) as integer ) from pc_vicmap_parcel vp where vp.crefno = cp.crefno ) , '' )
        else ''
    end as vicmap_parcel_area_sqm,
    case
        when spi <> '' and cp.spi in ( select spi from pc_vicmap_parcel ) then ifnull ( ( select round ( st_area ( st_transform ( vp.geometry , 3111 ) ) ) / 10000 from pc_vicmap_parcel vp where vp.spi = cp.spi ) , '' )
        when crefno <> '' then ifnull ( ( select round ( st_area ( st_transform ( vp.geometry , 3111 ) ) ) / 10000 from pc_vicmap_parcel vp where vp.crefno = cp.crefno ) , '' )
        else ''
    end as vicmap_parcel_area_ha
from
    pc_council_parcel cp
where
    assnum <> ''
order by
    cast ( assnum as integer ) , spi
