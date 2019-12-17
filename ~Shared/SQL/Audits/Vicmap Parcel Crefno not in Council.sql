select
    '=HYPERLINK("https://vicmap.pozi.com/?parcelpfi=' || parcel_pfi || '" , "' || parcel_pfi || '")' as parcel_pfi,
    spi,
    propnum,
    ifnull ( ( select ezi_address from pc_vicmap_property_address where propnum = vp.propnum ) , '' ) as address,
    crefno
from pc_vicmap_parcel vp
where crefno not in ( select crefno from pc_council_parcel ) and crefno <> ''