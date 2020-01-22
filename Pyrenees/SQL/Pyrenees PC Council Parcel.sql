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
        when 'P/AMPHITHEATRE' then '2013'
        when 'P/ARGYLE' then '2027'
        when 'P/AVOCA' then '2032'
        when 'P/BAANGAL' then '2035'
        when 'P/BARKLY' then '2074'
        when 'P/BEAUFORT' then '2096'
        when 'P/BOLERCH' then '2172'
        when 'P/BREWSTER' then '2224'
        when 'P/BUANGOR' then '2243'
        when 'P/BUNG BONG' then '2280'
        when 'P/CARALULUP' then '2333'
        when 'P/CARAMBALLUC NORTH' then '2334'
        when 'P/CARNGHAM' then '2351'
        when 'P/CHEPSTOWE' then '2376'
        when 'P/CROWLANDS' then '2468'
        when 'P/ENUC' then '2595'
        when 'P/ERCILDOUN' then '2597'
        when 'P/EURAMBEEN' then '2605'
        when 'P/EVERSLEY' then '2609'
        when 'P/GLENDHU' then '2672'
        when 'P/GLENLOGIE' then '2676'
        when 'P/GLENMONA' then '2680'
        when 'P/GLENPATRICK' then '2684'
        when 'P/HADDON' then '2740'
        when 'P/LANDSBOROUGH' then '2963'
        when 'P/LANGI-KAL-KAL' then '2965'
        when 'P/LEXTON' then '2989'
        when 'P/LILLICUR' then '2994'
        when 'P/LILLIRIE' then '2997'
        when 'P/LIVINGSTONE' then '3004'
        when 'P/MAHKWALLOK' then '3035'
        when 'P/MOALLAACK' then '3131'
        when 'P/MORTCHUP' then '3195'
        when 'P/MOYREISK' then '3206'
        when 'P/NANIMIA' then '3257'
        when 'P/NATTEYALLOCK' then '3287'
        when 'P/NAVARRE' then '3288'
        when 'P/RAGLAN' then '3439'
        when 'P/RAGLAN WEST' then '3440'
        when 'P/RATHSCAR' then '3441'
        when 'P/REDBANK' then '3443'
        when 'P/SCARSDALE' then '3477'
        when 'P/SHIRLEY' then '3488'
        when 'P/SKIPTON' then '3489'
        when 'P/SMYTHESDALE' then '3491'
        when 'P/TCHIRREE' then '3569'
        when 'P/TRAWALLA' then '3648'
        when 'P/WAREEK' then '3739'
        when 'P/WARRENMANG' then '3761'
        when 'P/WONGAN' then '3860'
        when 'P/WOODNAGGERAK' then '3873'
        when 'P/YALONG' then '3940'
        when 'P/YALONG SOUTH' then '3941'
        when 'P/YANGERAHWILL' then '3949'
        when 'P/YEHRIP' then '3983'
        else ''
    end as parish_code,
    case district
        when 'T/AMPHITHEATRE' then '5010'
        when 'T/AVOCA' then '5023'
        when 'T/BARKLY' then '5043'
        when 'T/BEAUFORT' then '5058'
        when 'T/BUNG BONG' then '5132'
        when 'T/CARNGHAM' then '5157'
        when 'T/CHEPSTOWE' then '5168'
        when 'T/CROWLANDS' then '5214'
        when 'T/EVANSFORD' then '5288'
        when 'T/HOMEBUSH' then '5384'
        when 'T/LAMPLOUGH' then '5449'
        when 'T/LANDSBOROUGH' then '5451'
        when 'T/LEXTON' then '5462'
        when 'T/LOWER HOMEBUSH' then '5481'
        when 'T/MIDDLE CREEK' then '5528'
        when 'T/MOONAMBEL' then '5547'
        when 'T/NATTE YALLOCK' then '5579'
        when 'T/PERCYDALE' then '5630'
        when 'T/RAGLAN' then '5663'
        when 'T/REDBANK' then '5668'
        when 'T/SHIRLEY' then '5714'
        when 'T/STOCKYARD HILL' then '5733'
        when 'T/WAUBRA' then '5843'
        else ''
    end as township_code,
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
