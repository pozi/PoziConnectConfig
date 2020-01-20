select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi <> '' then internal_spi
        else constructed_spi
    end as spi,
    case
        when internal_spi <> '' then 'council_spi'
        else 'council_attributes'
    end as spi_source
from
(
select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as constructed_spi
from
(
select
    properties.vg_number as propnum,
    '' as crefno,
    case
        when parcels.survey_no = 'NULL' then ''
        else parcels.survey_no
    end as internal_spi,
    case
        when parcels.spi_number = 'NULL' then ''
        else parcels.spi_number
    end as internal_spi_2,
    parcels.land_parcel as summary,
    '' as status,
    '' as part,
    case
        when parcels.parcel_type in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then part_location
        else ''
    end as plan_number,
    case
        when parcels.parcel_type not in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else ifnull ( parcels.parcel_type , '' )
    end as plan_prefix,
    case
        when parcels.parcel_type in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then substr ( part_location , 3 , 6 )
        else ''
    end as plan_numeral,
    case
        when parcels.parcel_type not in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when parcels.lot_no = 'NULL' then ''
        when substr ( parcels.lot_no , 2 , 1 ) in ( ' ' ) then substr ( parcels.lot_no , 1 , 1 )
        when substr ( parcels.lot_no , 3 , 1 ) in ( ' ' ) then substr ( parcels.lot_no , 1 , 2 )
        when substr ( parcels.lot_no , 4 , 1 ) in ( ' ' ) then substr ( parcels.lot_no , 1 , 3 )
        when substr ( parcels.lot_no , 5 , 1 ) in ( ' ' ) then substr ( parcels.lot_no , 1 , 4 )
  		else trim ( ifnull ( parcels.lot_no , '' ) )
  	end as lot_number,
    case
        when parcels.lot_no = 'NULL' then ''
        when parcels.lot_no like '%PORTION%' then ''
        else replace ( replace ( replace ( parcels.lot_no , 'CA ', '' ) , ' SUBDIVISION A' , '' ) , ' SUBDIVISION B' , '' )
    end as allotment,
    case
        when parcels.parcel_type in ( 'CP' , 'CS' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when location = 'NULL' then ''
        else ifnull ( location , '' )
  	end as sec,
    '' as block,
    case
        when parcels.parcel_type = 'CA' and parcels.lot_no like '%POR%' then trim ( replace ( parcels.lot_no , 'PORTION' , '' ) )
        else ''
    end as portion,
    case
        when parcels.lot_no like '%SUBDIVISION A%' then 'A'
        when parcels.lot_no like '%SUBDIVISION B%' then 'B'
        else ''
    end as subdivision,
    case district
        when 'ARGYLE' then '2027'
        else ''
    end as parish_code,
    '' as township_code,
    '359' as lga_code,
    properties.vg_number as assnum
from
    synergysoft_property_id as parcels join
    synergysoft_parcel_index_properties as parcel_index on parcels.land_parcel = parcel_index.land_parcel join
    synergysoft_properties as properties on properties.assess_no = parcel_index.assess_no
where
  	properties.rate_code <> '98' and
    ( parcels.parcel_type in ( 'CA' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) or parcels.survey_no <> 'NULL' )
)
)
)
