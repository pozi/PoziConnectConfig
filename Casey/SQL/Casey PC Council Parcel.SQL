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
    end as constructed_spi,
    internal_spi as spi,
    'council_spi' as spi_source
from
(
select
    cast ( A.key1 as varchar) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    ifnull ( L.text10 , '' ) as internal_spi,
    '' as summary,
    case L.status
        when 'F' then 'P'
        else ''
    end as status,
    ifnull ( upper ( part_lot ) , '' ) as part,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( L.plan_desc ) || L.plan_no
        else ifnull ( trim ( L.plan_desc ) || substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_number,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then L.plan_desc
        else ''
    end as plan_prefix,
    case
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    ifnull ( upper ( replace ( lot , ' ' , '' ) ) , '' ) as lot_number,
	ifnull (L.text3,'') as allotment,
    ifnull ( L.parish_section , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    '' as parish_code,
    '' as township_code,
    '312' as lga_code,
    cast ( A.key1 as varchar) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_no = A.key2 and L.status in ( 'C' , 'F' )
    join techone_nucproperty P on A.Key1 = P.Property_no and P.status in ( 'C' , 'F' )
    left join techone_nucassociation T on A.Key1 = T.Key1 and A.key2 = t.key2 and
    T.association_type = 'TransPRLD' and A.date_ended is null
where
    A.association_type = 'PropLand' and
    A.date_ended is null AND
    t.key1 is null
)
)