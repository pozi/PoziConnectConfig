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
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    substr ( parcel_index.assess_no , 2 , 99 ) as propnum,
    '' as crefno,
    '' as internal_spi,
    parcels.land_parcel as summary,
    '' as status,
    case
        when lot_no like '%PT%' then 'P'
        else ''
    end as part,
    case
        when parcel_type in ( 'L' , 'CP' , 'PC' , 'RS' ) then part_location
        else ''
    end as plan_number,
    case
        when parcel_type in ( 'L' , 'CP' , 'PC' , 'RS' ) then substr ( part_location , 1 , 2 )
        else ''
    end as plan_prefix,
    case
        when parcel_type in ( 'L' , 'CP' , 'PC' , 'RS' ) then substr ( part_location , 3 , 6 )
        else ''
    end as plan_numeral,
    case
        when parcel_type not in ( 'L' , 'RS' ) then ''
        when substr ( lot_no , 2 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 1 )
        when substr ( lot_no , 3 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 2 )
        when substr ( lot_no , 4 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 3 )
  		else trim ( replace ( replace ( replace ( lot_no , 'RATES' , '' ) , 'PT' , '' ) , 'ROAD' , '' ) )
  	end as lot_number,
    case
        when parcel_type <> 'CA' then ''
        when lot_no like '%POR%' then ''
        when substr ( lot_no , 2 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 1 )
        when substr ( lot_no , 3 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 2 )
        when substr ( lot_no , 4 , 1 ) in ( ' ' ) then substr ( lot_no , 1 , 3 )
        else trim ( replace ( lot_no , ' PT' , ' ' ) )
    end as allotment,
    case
  		when parcel_type <> 'CA' then ''
        when location like 'NO SEC%' then ''
        else ifnull ( location , '' )
  	end as sec,
    '' as block,
    case
        when parcel_type = 'CA' and lot_no like '%POR%' then trim ( replace ( replace ( lot_no , 'PORTION' , '' ) , 'POR' , ' ' ) )
        else ''
    end as portion,
    case
        when parcel_type = 'CA' and part_location like 'SUBD %' then trim ( replace ( part_location , 'SUBD' , '' ) )
        else ''
    end as subdivision,
    case district
        when 'ARGYLE' then '2027'
        when 'BAMGANIE' then '2060'
        when 'BURTWARRAH' then '2308'
        when 'CARDIGAN' then '2344'
        when 'CARGERIE' then '2345'
        when 'CARNGHAM' then '2351'
        when 'CARRAH' then '2355'
        when 'CLARKESDALE' then '2388'
        when 'COMMERALGHIP' then '2417'
        when 'COOLEBARGHURK' then '2429'
        when 'CORINDHAP' then '2452'
        when 'DARRIWIL' then '2498'
        when 'DARRIWELL' then '2498'
        when 'DEREEL' then '2511'
        when 'DOROQ' then '2540'
        when 'DURDIDWARRAH' then '2568'
        when 'ENFIELD' then '2592'
        when 'GALLA' then '2629'
        when 'GHERINEGHAP' then '2650'
        when 'HADDON' then '2740'
        when 'HESSE' then '2753'
        when 'KURUC-A-RUC' then '2947'
        when 'LAWALUK' then '2980'
        when 'LYNCHFIELD' then '3024'
        when 'MANNIBADAR' then '3054'
        when 'MEREDITH' then '3090'
        when 'MINDAI' then '3109'
        when 'MOREEP' then '3188'
        when 'MORTCHUP' then '3195'
        when 'MURDEDUKE' then '3224'
        when 'MURGHEBOLUC' then '3225'
        when 'NARINGHIL NORTH' then '3268'
        when 'NARINGHIL SOUTH' then '3269'
        when 'POORNEET' then '3410'
        when 'SCARSDALE' then '3477'
        when 'SHELFORD' then '3484'
        when 'SHELFORD WEST' then '3485'
        when 'SMYTHESDALE' then '3491'
        when 'WABDALLAH' then '3692'
        when 'WALLINDUC' then '3709'
        when 'WARRAMBINE' then '3752'
        when 'WINGEEL' then '3836'
        when 'WURROOK' then '3912'
        when 'YARIMA' then '3959'
        when 'YARROWEE' then '3971'
        when 'GHERINGHAP' then '2650'
        when 'NARINGHIL NTH' then '3268'
        when 'NARINGHIL STH' then '3269'
        else ''
    end as parish_code,
    case
        when district like 'BANNOCKBURN T%' then '5040'
        when district like 'BERRINGA T%' then '5073'
        when district like 'CAMBRIAN HILL T%' then '5144'
        when district like 'CAPE CLEAR T%' then '5149'
        when district like 'CORINDHAP T%' then '5197'
        when district like 'CRESSY T%' then '5210'
        when district like 'DEREEL T%' then '5237'
        when district like 'GARIBALDI T%' then '5308'
        when district like 'GOLDEN LAKE T%' then '5331'
        when district like 'GRENVILLE T%' then '5356'
        when district like 'HADDON T%' then '5362'
        when district like 'HAPPY VALLEY T%' then '5365'
        when district like 'INVERLEIGH T%' then '5392'
        when district like 'LETHBRIDGE T%' then '5461'
        when district like 'LINTON T%' then '5467'
        when district like 'MAUDE T%' then '5512'
        when district like 'MEREDITH T%' then '5517'
        when district like 'NAPOLEONS T%' then '5573'
        when district like 'PITFIELD T%' then '5641'
        when district like 'PITFIELD PLAINS T%' then '5642'
        when district like 'ROKEWOOD T%' then '5680'
        when district like 'SHELFORD T%' then '5712'
        when district like 'SMYTHESDALE T%' then '5721'
        when district like 'SOUTH BANNOCKBURN T%' then '5723'
        when district like 'STEIGLITZ T%' then '5731'
        when district like 'TEESDALE T%' then '5774'
        when district like 'WINGEEL T%' then '5865'
        when district = 'KALENO' then '5642'
        when district = 'LINTON' then '5467'
        when district = 'TEESDALE' then '5774'
        else ''
    end as township_code,
    '324' as lga_code
from
    synergysoft_property_id as parcels join
    synergysoft_parcel_index_properties as parcel_index on parcels.land_parcel = parcel_index.land_parcel
where
  	parcel_type in ( 'CA' , 'CP' , 'L' , 'PC' , 'RS' ) and
  	substr ( parcels.lot_no , 1 , 4 ) not in ( 'HIST' , 'CANC' , 'EXTE' )
)
