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
    cast ( P.property_no as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    ifnull ( L.text5 , '' ) as internal_spi,
    ifnull ( substr ( P.override_legal_description , 1 , 99 ) , '' ) as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    case
        when upper ( L.plan_no ) like '%(PT%' then 'P'
        when ifnull ( part_lot , '' ) <> '' then 'P'
        else ''
    end as part,
    case
        when substr ( trim ( ifnull ( replace ( upper ( L.plan_no ) , '(PT' , '' ) , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || trim ( ifnull ( replace ( upper ( L.plan_no ) , '(PT' , '' ) , '' ) )
        else trim ( ifnull ( L.plan_desc , '' ) ) || trim ( substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 ) )
    end as plan_number,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then L.plan_desc
        else ''
    end as plan_prefix,
    case
        when substr ( trim ( replace ( upper ( L.plan_no ) , '(PT' , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( replace ( upper ( L.plan_no ) , '(PT' , '' ) )
        else trim ( ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' ) )
    end as plan_numeral,
    upper ( replace ( replace ( ifnull ( upper ( L.lot ) , '' ) , 'PT' , '' ) , ' ' , '' ) ) as lot_number,
    case
        when L.plan_desc is null then replace ( replace ( ifnull ( upper ( L.text3 ) , '' ) , 'PT' , '' ) , ' ' , '' )
        else ''
    end as allotment,
    case
        when L.section_for_lot is not null then trim ( replace ( L.section_for_lot , ')' , '' ) )
        when L.parish_section is not null then L.parish_section
        else ''
    end as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case when L.plan_desc is null then case
        when override_legal_description like '%ALLAMBEE EAST%' then '2011'
        when override_legal_description like '%DROUIN EAST%' then '2547'
        when override_legal_description like '%DROUIN WEST%' then '2548'
        when override_legal_description like '%KOO-WEE-RUP EAST%' then '2921'
        when override_legal_description like '%LANG LANG EAST%' then '2969'
        when override_legal_description like '%NAYOOK WEST%' then '3290'
        when override_legal_description like '%NEERIM EAST%' then '3293'
        when override_legal_description like '%NOOJEE EAST%' then '3318'
        when override_legal_description like '%NARRACAN SOUTH%' then '3274'
        when override_legal_description like '%NARROBUK NORTH%' then '3282'
        when override_legal_description like '%POOWONG EAST%' then '3412'
        when override_legal_description like '%TANJIL EAST%' then '3543'
        when override_legal_description like '%TELBIT WEST%' then '3574'
        when override_legal_description like '%TONIMBUK EAST%' then '3609'
        when override_legal_description like '%TOONGABBIE NORTH%' then '3626'
        when override_legal_description like '%WALHALLA EAST%' then '3703'
        when override_legal_description like '%ALLAMBEE%' then '2010'
        when override_legal_description like '%BAW BAW%' then '2093'
        when override_legal_description like '%BEENAK%' then '2101'
        when override_legal_description like '%BINNUC%' then '2154'
        when override_legal_description like '%BOOLA BOOLA%' then '2183'
        when override_legal_description like '%BRIMBONGA%' then '2229'
        when override_legal_description like '%BULLUNG%' then '2268'
        when override_legal_description like '%BUNYIP%' then '2290'
        when override_legal_description like '%BUTGULLA%' then '2310'
        when override_legal_description like '%COORNBURT%' then '2443'
        when override_legal_description like '%DARNUM%' then '2494'
        when override_legal_description like '%ELLINGING%' then '2587'
        when override_legal_description like '%FUMINA%' then '2623'
        when override_legal_description like '%JINDIVICK%' then '2801'
        when override_legal_description like '%LICOLA%' then '2991'
        when override_legal_description like '%LONGWARRY%' then '3011'
        when override_legal_description like '%MATLOCK%' then '3073'
        when override_legal_description like '%MOE%' then '3135'
        when override_legal_description like '%MOOLPAH%' then '3156'
        when override_legal_description like '%MOONDARRA%' then '3158'
        when override_legal_description like '%NARRACAN%' then '3273'
        when override_legal_description like '%NARROBUK%' then '3281'
        when override_legal_description like '%NAYOOK%' then '3289'
        when override_legal_description like '%NEERIM%' then '3292'
        when override_legal_description like '%NOOJEE%' then '3317'
        when override_legal_description like '%NUMBRUK%' then '3336'
        when override_legal_description like '%POOWONG%' then '3411'
        when override_legal_description like '%ST CLAIR%' then '3464'
        when override_legal_description like '%STANDER%' then '3497'
        when override_legal_description like '%TANJIL%' then '3542'
        when override_legal_description like '%TELBIT%' then '3573'
        when override_legal_description like '%TOOMBON%' then '3622'
        when override_legal_description like '%TOORONGO%' then '3632'
        when override_legal_description like '%WALHALLA%' then '3702'
        when override_legal_description like '%WARRAGUL%' then '3748'
        when override_legal_description like '%WURUTWUN%' then '3914'
        when override_legal_description like '%YANNATHAN%' then '3953'
        when override_legal_description like '%YARRAGON%' then '3962'
        else ''
    end else '' end as parish_code,
    case when L.plan_desc is null then case
        when override_legal_description like '%ABERFELDY TOWNSHIP%' then '5001'
        when override_legal_description like '%BULN BULN TOWNSHIP%' then '5129'
        when override_legal_description like '%CHILDERS TOWNSHIP%' then '5172'
        when override_legal_description like '%COALVILLE TOWNSHIP%' then '5179'
        when override_legal_description like '%COOPERS CREEK TOWNSHIP%' then '5193'
        when override_legal_description like '%CROSSOVER TOWNSHIP%' then '5213'
        when override_legal_description like '%DARNUM TOWNSHIP%' then '5227'
        when override_legal_description like '%DROUIN TOWNSHIP%' then '5252'
        when override_legal_description like '%GOULD TOWNSHIP%' then '5341'
        when override_legal_description like '%LONGWARRY TOWNSHIP%' then '5476'
        when override_legal_description like '%MATLOCK TOWNSHIP%' then '5511'
        when override_legal_description like '%NEERIM TOWNSHIP%' then '5582'
        when override_legal_description like '%NILMA TOWNSHIP%' then '5596'
        when override_legal_description like '%NOOJEE TOWNSHIP%' then '5600'
        when override_legal_description like '%ROKEBY TOWNSHIP%' then '5679'
        when override_legal_description like '%ST CLAIR TOWNSHIP%' then '5693'
        when override_legal_description like '%TOOMBON TOWNSHIP%' then '5794'
        when override_legal_description like '%TRAFALGAR TOWNSHIP%' then '5800'
        when override_legal_description like '%WALHALLA TOWNSHIP%' then '5819'
        when override_legal_description like '%WARRAGUL TOWNSHIP%' then '5835'
        when override_legal_description like '%WESTBURY TOWNSHIP%' then '5850'
        when override_legal_description like '%WHISKEY CREEK TOWNSHIP%' then '5853'
        when override_legal_description like '%WILLOW GROVE TOWNSHIP%' then '5862'
        when override_legal_description like '%YARRAGON TOWNSHIP%' then '5898'
        else ''
    end else '' end as township_code,
    '305' as lga_code
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' )
)
