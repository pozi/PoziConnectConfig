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
    cast ( P.property_no as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    ifnull ( substr ( P.override_legal_description , 1 , 99 ) , '' ) as summary,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    case
        when ifnull ( part_lot , '' ) <> '' then 'P'
        else ''
    end as part,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' ) then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' ) then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' ) then ''
        else upper ( replace ( ifnull ( L.lot , '' ) , ' ' , '' ) )
    end as lot_number,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' ) then L.lot
        when L.plan_desc is null and L.plan_no = '' then L.lot
        else ''
    end as allotment,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' ) and L.parish_section not null then L.parish_section
        else ifnull ( L.section_for_lot , '' )
    end as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case L.parish_desc
        when 'MEE' then '3078'
        when 'MEP' then '3087'
        when 'PUR' then '3426'
        when 'TAL' then '3530'
        when 'WAN' then '3729'
        when 'YAN' then '3950'
        else ''
    end as parish_code,
    case L.county_desc
        when 'BUSH' then '5139'
        when 'DENN' then '5235'
        when 'WARN' then '5841'
        when 'WARR' then '5841'
        when 'WOOD' then '5875'
        else ''
    end as township_code,
    '329' as lga_code,
    cast ( P.property_no as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.property_no
where
    A.association_type = 'PropLand' and
    A.date_ended is null and
    P.status in ( 'C' , 'F' ) and
    P.property_no <> 1
)
)
