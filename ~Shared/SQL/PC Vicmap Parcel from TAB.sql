select
    parcel.parcel_pfi as parcel_pfi,
    parcel.parcel_spi as spi,
    case
        when parcel.parcel_parish_code <> '' then replace ( parcel.parcel_spi , '\PP' , '\' )
        when parcel.parcel_plan_number like 'CP%' then substr ( parcel.parcel_plan_number , 3 , 6 )
        when parcel.parcel_plan_number like 'PC%' then substr ( parcel.parcel_plan_number , 3 , 6 )
        when parcel.parcel_plan_number like 'CS%' then replace ( parcel.parcel_spi , '\CS' , '\' )
        when parcel.parcel_plan_number like 'LP%' then replace ( parcel.parcel_spi , '\LP' , '\' )
        when parcel.parcel_plan_number like 'PS%' then replace ( parcel.parcel_spi , '\PS' , '\' )
        when parcel.parcel_plan_number like 'RP%' then replace ( parcel.parcel_spi , '\RP' , '\' )
        when parcel.parcel_plan_number like 'SP%' then replace ( parcel.parcel_spi , '\SP' , '\' )
        when parcel.parcel_plan_number like 'TP%' then replace ( parcel.parcel_spi , '\TP' , '\' )
        else ''
    end as simple_spi,
    parcel.parcel_spi_code as spi_code,
    parcel.parcel_desc_type as desc_type,
    parcel.parcel_lga_code as lga_code,
    parcel.parcel_plan_number as plan_number,
    substr ( parcel.parcel_plan_number , 1 , 2 ) as plan_prefix,
    substr ( parcel.parcel_plan_number , 3 , 6 ) as plan_numeral,
    parcel.parcel_lot_number as lot_number,
    parcel.parcel_crefno as crefno,
    parcel.parcel_status as status,
    property.prop_pfi as property_pfi,
    property.prop_multi_assessment as multi_assessment,
    property.prop_propnum as propnum,
    parcel.geometry as geometry
from
    VMPROP_PARCEL parcel,
    VMPROP_PARCEL_PROPERTY parcel_property,
    VMPROP_PROPERTY property
where
    parcel.parcel_pfi = parcel_property.parcel_pfi and    
    parcel_property.property_pfi = property.prop_pfi and 
    property.prop_property_type = 'O'
