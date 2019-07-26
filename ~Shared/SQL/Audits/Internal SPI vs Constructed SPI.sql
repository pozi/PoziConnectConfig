select
    case
        when propnum in ( select propnum from pc_vicmap_property_address ) then '=HYPERLINK("https://vicmap.pozi.com/?propertypfi=' || ( select property_pfi from pc_vicmap_property_address vpa where vpa.propnum = x.propnum ) || '" , "' || propnum || '")'
        else propnum
    end as propnum,
    case
        when propnum in ( select propnum from pc_vicmap_property_address ) or propnum in ( select propnum from m1 ) then 'Y'
        else 'N'
    end as propnum_in_vicmap,
    crefno,
    case
        when internal_spi in ( select spi from pc_vicmap_parcel where spi <> '' ) then '=HYPERLINK("https://vicmap.pozi.com/?parcelspi=' || internal_spi || '" , "' || internal_spi || '")'
        else internal_spi
    end as internal_spi,
    case
        when internal_spi in ( select spi from pc_vicmap_parcel where spi <> '' ) then 'Y'
        else 'N'
    end as internal_spi_in_vicmap,
    case
        when constructed_spi in ( select spi from pc_vicmap_parcel where spi <> '' ) then '=HYPERLINK("https://vicmap.pozi.com/?parcelspi=' || constructed_spi || '" , "' || constructed_spi || '")'
        else constructed_spi
    end as constructed_spi,
    case
        when constructed_spi in ( select spi from pc_vicmap_parcel where spi <> '' ) then 'Y'
        else 'N'
    end as constructed_spi_in_vicmap,
    ifnull ( ( select '=HYPERLINK("https://vicmap.pozi.com/?parcelspi=' || spi || '" , "' || spi || '")' from pc_vicmap_parcel vp where vp.crefno = x.crefno and vp.spi <> internal_spi and vp.spi <> constructed_spi ) , '' ) as alt_spi
from pc_council_parcel x

