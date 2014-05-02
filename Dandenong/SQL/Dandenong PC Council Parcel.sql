select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
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
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    cast ( A.key1 as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    '' as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    ifnull ( upper ( part_lot ) , '' ) as part,
    case
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    ifnull ( L.plan_desc , '' ) as plan_prefix,
    case
        when substr ( L.plan_no , 1 , 1 ) not in ( '1','2','3','4','5','6','7','8','9','0' ) then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull (substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    ifnull ( L.lot , '' ) as lot_number,
    case
        when ifnull ( L.plan_desc , '' ) = '' then ifnull ( L.parish_portion , '' )
        else ''
    end as allotment,
    case
        when ifnull ( L.plan_desc , '' ) = '' then ifnull ( L.parish_section , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case upper ( L.parish_desc )
        when 'DAN' then '2483'
        when 'EUM' then '2603'
        when 'LYND' then '3025'
        when 'MORD' then '3186'
        else ''
    end as parish_code,
    case upper ( L.parish_desc )
        when 'TOWN' then '5221'
        else ''
    end as township_code,
    '326' as lga_code
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' )
)
