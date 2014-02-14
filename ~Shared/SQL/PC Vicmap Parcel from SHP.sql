select
    parcel.parcel_pfi as parcel_pfi,
    ifnull ( parcel.parcel_spi , '' ) as spi,
    ifnull ( case
        when parcel.pc_parc not null then replace ( parcel_spi , '\PP' , '\' )
        when parcel.pc_planno like 'CP%' then substr ( parcel.pc_planno , 3 , 6 )
        when parcel.pc_planno like 'PC%' then substr ( parcel.pc_planno , 3 , 6 )
        when parcel.pc_planno like 'CS%' then replace ( parcel_spi , '\CS' , '\' )
        when parcel.pc_planno like 'LP%' then replace ( parcel_spi , '\LP' , '\' )
        when parcel.pc_planno like 'PS%' then replace ( parcel_spi , '\PS' , '\' )
        when parcel.pc_planno like 'RP%' then replace ( parcel_spi , '\RP' , '\' )
        when parcel.pc_planno like 'SP%' then replace ( parcel_spi , '\SP' , '\' )
        when parcel.pc_planno like 'TP%' then replace ( parcel_spi , '\TP' , '\' )
    end , '' ) as simple_spi,
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
    property.prop_pfi as property_pfi,
    property.pr_multass as multi_assessment,
    ifnull ( property.pr_propnum , '' ) as propnum,
    parcel.parv_pfi as parcel_view_pfi,
    parcel.geometry as geometry
from
    vmprop_parcel_mp parcel,
    vmprop_parcel_property parcel_property,
    vmprop_property_mp property
where
    parcel.parcel_pfi = parcel_property.parcel_pfi and    
    parcel_property.pr_pfi = property.prop_pfi and 
    property.pr_ptype = 'O'
