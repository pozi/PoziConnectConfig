select
    smbal.ogc_fid as id,
    smbal.*,
    case
        when smbal.propnum in ( select propnum from pc_council_property_address ) then 'Y'
        else 'N'
    end as propnum_in_fuj,
    case
        when smbal.propnum in ( select propnum from pc_vicmap_property_address ) then 'Y'
        else 'N'
    end as propnum_in_vicmap,
    vp.parcel_spi as vicmap_spi,
    vp.parcel_status as vicmap_status,
    ( select group_concat ( propnum ) from pc_vicmap_parcel vpx where vpx.spi = vp.parcel_spi ) as vicmap_propnums
from
    ca_smbal smbal,
    vmprop_parcel_mp vp
where
    st_contains ( vp.geometry , smbal.geometry ) = 1 and
    smbal.rowid in (
        select rowid
        from SpatialIndex
        where
            f_table_name = 'ca_smbal' and
            search_frame = vp.geometry )
