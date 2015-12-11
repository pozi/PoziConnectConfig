select
    parcel.parcel_pfi as parcel_pfi,
    parcel.parcel_spi as spi,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( parcel.parcel_spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi,
    parcel.parcel_spi_code as spi_code,
    parcel.parcel_desc_type as desc_type,
    parcel.parcel_lga_code as lga_code,
    parcel.parcel_plan_number as plan_number,
    substr ( parcel.parcel_plan_number , 1 , 2 ) as plan_prefix,
    substr ( parcel.parcel_plan_number , 3 , 6 ) as plan_numeral,
    parcel.parcel_lot_number as lot_number,
    parcel_accessory_lot as accessory_lot,
    parcel_allotment as allotment,
    parcel_sec as sec,
    parcel_block as block,
    parcel_portion as portion,
    parcel_subdivision as subdivision,
    parcel_crown_status as crown_status,
    parcel_parish_code as parish_code,
    parcel_township_code as township_code,
    parcel_p_number as p_number,
    parcel.parcel_further_description as further_description,
    parcel_part as part,
    parcel.parcel_crefno as crefno,
    parcel.parcel_status as status,
    ifnull ( prop_pfi , '' ) as property_pfi,
    ifnull ( prop_status , '' ) as property_status,
    ifnull ( prop_multi_assessment , '' ) as multi_assessment,
    ifnull ( prop_propnum , '' ) as propnum,
    ifnull ( propv_pfi , '' ) as property_view_pfi,
    parcel.parv_pfi as parcel_view_pfi,
    ifnull ( (
        select pfi
        from vmadd_address address
        where
            address.property_pfi = property_lut.property_pfi and
            address.is_primary = 'Y' and
            st_within ( address.geometry , parcel.geometry )
        limit 1 ) , '' ) as primary_address_pfi,
    parcel.geometry as geometry
from
    vmprop_parcel_mp parcel left join
    ( select * from vmprop_parcel_property parcel_property join
      vmprop_property_mp property on parcel_property.property_pfi = property.prop_pfi and property.prop_property_type = 'O' ) property_lut on parcel.parcel_pfi = property_lut.parcel_pfi