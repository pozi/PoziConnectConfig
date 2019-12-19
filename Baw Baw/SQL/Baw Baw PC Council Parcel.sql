select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    constructed_spi as spi,
    'council_attributes' as spi_source
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
    case
        when L.lot like 'CM%' then 'NCPR'
        else cast ( P.property_no as varchar )
    end as propnum,
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
        when L.plan_no is null then ifnull ( L.section_for_lot , '' )
        else ''
    end as sec,
    ifnull ( L.text6 , '' ) as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case upper ( L.parish_desc )
        when 'ALLAMBEE' then '2010'
        when 'ALLAMEAST' then '2011'
        when 'ALLAMBEEEA' then '2011'
        when 'BAWBAW' then '2093'
        when 'BINNUC' then '2154'
        when 'BOOLABOOLA' then '2183'
        when 'BULLUNG' then '2268'
        when 'BUNDOWRA' then '2274'
        when 'BUTGULLA' then '2310'
        when 'COORNBURT' then '2443'
        when 'DARNUM' then '2494'
        when 'DROUINEAST' then '2547'
        when 'DROUINWEST' then '2548'
        when 'ELLINGING' then '2587'
        when 'FUMINA' then '2623'
        when 'FUMINANTH' then '2624'
        when 'JINDIVICK' then '2801'
        when 'LANGLANGE' then '2969'
        when 'LONNGWARRY' then '3011'
        when 'LONGWARRY' then '3011'
        when 'MATLOCK' then '3073'
        when 'MOE' then '3135'
        when 'MOOLAP' then '3156'
        when 'MOOLPAH' then '3156'
        when 'MOONDARRA' then '3158'
        when 'NARRACAN' then '3273'
        when 'NARRACANS' then '3274'
        when 'NAYOOK' then '3289'
        when 'NAYOOKWEST' then '3290'
        when 'NEERIM' then '3292'
        when 'NEERIMEAST' then '3293'
        when 'NOOJEE' then '3317'
        when 'NOOJEEEAST' then '3318'
        when 'NUMBRUK' then '3336'
        when 'POOWONG' then '3411'
        when 'POOWONGE' then '3412'
        when 'STCLAIR' then '3464'
        when 'TANJIL' then '3542'
        when 'TANJILEAST' then '3543'
        when 'TELBIT' then '3573'
        when 'TELBITWEST' then '3574'
        when 'TOOMBON' then '3622'
        when 'TOORONGO' then '3632'
        when 'WALHALLA' then '3702'
        when 'WARRAGUL' then '3748'
        when 'WURUTWUN' then '3914'
        when 'YANNATHAN' then '3953'
        when 'YARRAGON' then '3962'
        else ''
    end as parish_code,
    case upper ( L.text4 )
        when 'ABERFELDY' then '5001'
        when 'BULNBULN' then '5129'
        when 'CHILDERS' then '5172'
        when 'COALVILLE' then '5179'
        when 'COOPERSCK' then '5193'
        when 'CROSSOVER' then '5213'
        when 'DARNUM' then '5227'
        when 'DROUIN' then '5252'
        when 'GOULD' then '5341'
        when 'LONGWARRY' then '5476'
        when 'MATLOCK' then '5511'
        when 'NEERIM' then '5582'
        when 'NILMA' then '5596'
        when 'NOOJEE' then '5600'
        when 'ROKEBY' then '5679'
        when 'ST.CLAIR' then '5693'
        when 'TOOMBON' then '5794'
        when 'TRAFALGAR' then '5800'
        when 'WALHALLA' then '5819'
        when 'WARRAGUL' then '5835'
        when 'WESTBURY' then '5850'
        when 'WHISKEYCK' then '5853'
        when 'WHISKYCK' then '5853'
        when 'WILLOWGVE' then '5862'
        when 'YARRAGON' then '5898'
        else ''
    end as township_code,
    '305' as lga_code,
    cast ( P.property_no as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' )
)
)
)