select
    parcel.parcel_pfi as parcel_pfi,
    ifnull ( parcel.parcel_spi , '' ) as spi,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( parcel.parcel_spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi,
    parcel.pc_spic as spi_code,
    parcel.pc_dtype as desc_type,
    parcel.pc_lgac as lga_code,
    ifnull ( parcel.pc_planno , '' ) as plan_number,
    substr ( ifnull ( parcel.pc_planno , '' ) , 1 , 2 ) as plan_prefix,
    substr ( ifnull ( parcel.pc_planno , '' ) , 3 , 6 ) as plan_numeral,
    ifnull ( parcel.pc_lotno , '' ) as lot_number,
    ifnull ( parcel.parc_acclt , '' ) as accessory_lot,
    ifnull ( parcel.pc_all , '' ) as allotment,
    ifnull ( parcel.parcel_sec , '' ) as sec,
    ifnull ( parcel.pc_blk , '' ) as block,
    ifnull ( parcel.pc_port , '' ) as portion,
    ifnull ( parcel.pc_sub , '' ) as subdivision,
    ifnull ( parcel.pc_crstat , '' ) as crown_status,
    ifnull ( parcel.pc_parc , '' ) as parish_code,
    ifnull ( parcel.pc_townc , '' ) as township_code,
    ifnull ( parcel.pc_pnum , '' ) as p_number,
    ifnull ( parcel.pc_fdesc , '' ) as further_description,
    ifnull ( parcel.pc_part , '' ) as part,
    ifnull ( parcel.pc_crefno , '' ) as crefno,
    parcel.pc_stat as status,
    ifnull ( prop_pfi , '' ) as property_pfi,
    ifnull ( pr_stat , '' ) as property_status,
    ifnull ( pr_multass , '' ) as multi_assessment,
    ifnull ( pr_propnum , '' ) as propnum,
    ifnull ( propv_pfi , '' ) as property_view_pfi,
    parcel.parv_pfi as parcel_view_pfi,
    parcel.pc_pfi_cr_char as parcel_pfi_created,
    ifnull ( (
        select pfi
        from vmadd_address address
        where
            address.pr_pfi = property_lut.pr_pfi and
            address.is_primary = 'Y' and
            st_within ( address.geometry , parcel.geometry )
        limit 1 ) , '' ) as primary_address_pfi,
    parcel.geometry as geometry
from
    vmprop_parcel_mp parcel left join
    ( select * from vmprop_parcel_property parcel_property join
      vmprop_property_mp property on parcel_property.pr_pfi = property.prop_pfi and property.pr_ptype = 'O' ) property_lut on parcel.parcel_pfi = property_lut.parcel_pfi