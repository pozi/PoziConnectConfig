select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
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
    end as spi
from
(
select
    cast ( A.key1 as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    '' as internal_spi,
    '' as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    ifnull ( upper ( part_lot ) , '' ) as part,
    case
        when L.plan_desc = 'CA' then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case
        when L.plan_desc = 'CA' then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
        when L.plan_desc = 'CA' then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull (substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when L.plan_desc = 'CA' then ''
        else ifnull ( L.lot , '' )
    end as lot_number,
    case
        when L.plan_desc = 'CA' and L.Lot <> '' then ifnull ( L.lot , '' )
        else ''
    end as allotment,
    ifnull ( L.parish_section , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'PRAHRAN' then '3416'
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'BOROONDARA' then '2209'
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'MELBOURNE SOUTH' then '3084'
        else ''
    end as parish_code,
    case
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'CAULFIELD' then '3416A'
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'GARDINER' then '3416E'
        when L.plan_desc = 'CA' and upper ( parish_desc ) = 'SOUTH YARRA' then '3084E'
        else ''
    end as township_code,
    '363' as lga_code,
    cast ( A.key1 as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
    left join techone_nucassociation T on A.key1 = T.key1 and A.key2 = t.key2 and
    T.association_type is null and A.date_ended is null
where
    A.association_type in ( 'PropLand' , 'Propland' ) and
    A.date_ended is null and
    L.plan_desc in ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' , 'CA' )
    and t.key1 is null and
    P.status in ( 'C' , 'F' )
)
)
