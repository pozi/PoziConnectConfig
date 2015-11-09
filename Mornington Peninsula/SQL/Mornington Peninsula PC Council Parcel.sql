select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi <> '' then 'council_spi'
        else 'council_attributes'
    end as source,
    case
        when internal_spi <> '' then internal_spi
        else generated_spi
    end as spi
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
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as generated_spi
from
(
select
    cast ( P.property_no as varchar ) as propnum,
    cast ( L.land_no as varchar ) as crefno,
    ifnull ( L.text6 , '' ) as internal_spi,
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
        when L.plan_desc in ( 'CA' , 'PTCA' , 'PT CA' ) then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' , 'PT CA' ) then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' , 'PT CA' ) then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when L.plan_desc in ( 'CA' , 'PTCA' , 'PT CA' ) then ''
        else upper ( replace ( ifnull ( L.lot , '' ) , ' ' , '' ) )
    end as lot_number,
    case
        when L.plan_desc not in ( 'CA' , 'PTCA' , 'PT CA' ) then ''
        when L.text10 <> '' then L.text10
        when L.plan_no <> '' then L.plan_no
        else ''
    end as allotment,
    ifnull ( L.parish_section , '' ) as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case L.parish_desc
        when 'BALNARRING' then '2054'
        when 'BALNARR' then '2054'
        when 'BITTERN' then '2159'
        when 'BITT' then '2159'
        when 'FINGAL' then '2612'
        when 'FINGA' then '2612'
        when 'FLINDERS' then '2613'
        when 'FRANKSTON' then '2619'
        when 'F/STON' then '2619'
        when 'KANGERONG' then '2831'
        when 'K/RONG' then '2831'
        when 'LANGWARRIN' then '2972'
        when 'MOOROODUC' then '3175'
        when 'M/DUC' then '3175'
        when 'NEPEAN' then '3297'
        when 'TYABB' then '3666'
        when 'WANNAEUE' then '3730'
        when 'WANN' then '3730'
        when 'ROSEBUD' then ''
        else ''
    end as parish_code,
    case L.parish_desc
        when 'KILMORE' then '5420'
        when 'MERINGO TN' then '5518'
        else ''
    end as township_code,
    '352' as lga_code
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