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
    ifnull ( P.override_legal_description , '' ) as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    case 
        when ifnull ( upper ( part_lot ) , '' ) = 'Y' then 'P'
        else  ifnull ( upper ( part_lot ) , '' )
    end as part,
    case
        when upper (l.plan_desc) = 'SEC' then ''
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case
        when upper (l.plan_desc) = 'SEC' then ''
        else ifnull ( L.plan_desc , '' ) 
    end as plan_prefix,
    case
        when upper (l.plan_desc) = 'SEC' then ''
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull (substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when l.parish_desc <> '' then ''
        else upper ( replace ( ifnull ( L.lot , '' ) , ' ' , '' ) ) 
    end as lot_number,
    case
        when l.parish_desc <> '' then l.lot
        else ''
    end as allotment,
    case
        when l.plan_desc = 'SEC' then ifnull ( l.plan_no ,'' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case upper ( L.parish_desc )
        when 'BULLEN' then '2264'
        when 'NUDAWAD' then '3337'
        when 'WARRA' then '3753'
        else ''
    end as parish_code,
    case 
        when P.OVERRIDE_LEGAL_DESCRIPTION like '%Town%' and upper ( L.parish_desc ) = 'TEMPLE' then '5776'
        when P.OVERRIDE_LEGAL_DESCRIPTION like '%Town%' and upper ( L.parish_desc ) = 'WARRA' then '5837'
        else ''
    end as township_code,
    '340' as lga_code,
    cast ( P.property_no as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    ( P.property_no < 550000 or P.property_no >= 700000 ) and
    L.plan_desc <> 'PA' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' )
)
