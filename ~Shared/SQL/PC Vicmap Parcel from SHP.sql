SELECT
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
    parcel.pc_lgac as lga_code,
    ifnull ( parcel.pc_planno , '' ) as plan_number,
    substr ( ifnull ( parcel.pc_planno , '' ) , 1 , 2 ) as plan_prefix,
    substr ( ifnull ( parcel.pc_planno , '' ) , 3 , 6 ) as plan_numeral,
    ifnull ( parcel.pc_lotno , '' ) as lot_number,
    ifnull ( parcel.pc_crefno , '' ) as crefno,
    parcel.pc_stat as status,
    property.prop_pfi as property_pfi,
    property.pr_multass as multi_assessment,
    ifnull ( property.pr_propnum , '' ) as propnum
FROM
    VMPROP_PARCEL parcel,
    VMPROP_PARCEL_PROPERTY parcel_property,
    VMPROP_PROPERTY property
WHERE
    parcel.parcel_pfi = parcel_property.parcel_pfi and    
    parcel_property.pr_pfi = property.prop_pfi and 
    property.pr_ptype = 'O'
