select
    spi as spi,
    parcel_pfi as parcel_pfi,
    '=hyperlink("http://www.pozi.com/vicmap/ws/goto.php?lga_code=' || lga_code || '&parcel_pfi=' || parcel_pfi || '","map")' as pozi_map,
    crefno as crefno,
    status as status,
    further_description as further_description,
    multi_assessment,
    ( select count(*) from pc_council_parcel x where x.spi = vp.spi and length ( vp.spi ) >= 5 ) as spi_in_council,
    substr ( ifnull ( ( select group_concat ( propnum , ';' ) from pc_council_parcel x where x.spi = vp.spi and length ( vp.spi ) >= 5 ) , '' ) , 1 , 99 ) as council_propnums,
    ( select count(*) from pc_vicmap_parcel vpx where vpx.spi = vp.spi and length ( vp.spi ) >= 5 ) as spi_in_vicmap,
    substr ( ifnull ( ( select group_concat ( propnum , ';' ) from pc_vicmap_parcel vpx where vpx.spi = vp.spi and length ( vp.spi ) >= 5 ) , 0 ) , 1 , 99 ) as vicmap_propnums,
    ( select count(*) from pc_council_parcel cp where cp.simple_spi = vp.simple_spi and cp.spi <> vp.spi and length ( vp.spi ) >= 5 ) as partial_spi_in_council,
    ( select count(*) from pc_council_parcel cp where cp.spi = vp.further_description and length ( cp.spi ) >= 5 ) as alt_spi_in_council,
    ifnull ( ( select num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = vp.propnum ) , 0 ) as propnum_in_council,
    ifnull ( ( select num_parcels from pc_vicmap_property_parcel_count vppc where vppc.propnum = vp.propnum ) , 0 ) as propnum_in_vicmap,
    ifnull ( ( select crefno from pc_council_parcel cp where cp.spi = vp.spi and length ( cp.spi ) >= 5 ) , '' ) as council_crefno,
    ifnull ( ( select edit_code from M1 where m1.spi = vp.spi and length ( vp.spi ) >= 5 limit 1 ) , '' ) as m1_edit_code,
    ifnull ( ( select comments from M1 where m1.spi = vp.spi and length ( vp.spi ) >= 5 limit 1 ) , '' ) as m1_comments,
    area ( st_transform ( geometry , 3111 ) ) as area_sqm,
    geometry as geometry
from pc_vicmap_parcel vp
group by parcel_pfi