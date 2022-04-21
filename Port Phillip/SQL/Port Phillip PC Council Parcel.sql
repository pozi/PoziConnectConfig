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
    cast ( P.prop_id as varchar ) as propnum,
    cast ( L.land_id as varchar ) as crefno,
    case
        when L.land_text_5 <> '' then L.land_text_5
        when L.land_text_9 <> '' then L.land_text_9
        else ''
    end as internal_spi,
    ifnull ( substr ( P.override_legal_description , 1 , 99 ) , '' ) as summary,
    case L.land_status_ind
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
        when L.land_text_10 <> '' then L.land_text_10
        when L.plan_no <> '' then L.plan_no
        else ''
    end as allotment,
    ifnull ( L.parish_section , '' ) as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case L.parish_desc
        when 'BAYNTON' then '2094'
        when 'BROADFORD' then '2235'
        when 'BYLANDS' then '2318'
        when 'CLONBINANE' then '2389'
        when 'DERRIL' then '2515'
        when 'DWEIT GUIM' then '2496'
        when 'FLOWERDALE' then '2614'
        when 'FORBES' then '2615'
        when 'GHIN GHIN' then '2651'
        when 'GLENAROUA' then '2665'
        when 'GLENBURNIE' then '2667'
        when 'GLENHOPE' then '2675'
        when 'GOLDIE' then '2694'
        when 'HEATHCOTE' then '2750'
        when 'KERRISDALE' then '2866'
        when 'KOBYBOYN' then '2894'
        when 'LANGLEY' then '2970'
        when 'LOWRY' then '3018'
        when 'MANGALORE' then '3053'
        when 'MERRIANG' then '3093'
        when 'MITCHELL' then '3125'
        when 'MORANDING' then '3182'
        when 'NORTHWOOD' then '3324'
        when 'PANYULE' then '3370'
        when 'PUCKAPUNYAL' then '3420'
        when 'PYALONG' then '3430'
        when 'SEYMOUR' then '3481'
        when 'SPRING PLAINS' then '3496'
        when 'TALLAROOK' then '3532'
        when 'TOOBORAC' then '3611'
        when 'TRAAWOOL' then '3645'
        when 'WALLAN WALLAN' then '3707'
        when 'WARROWITUE' then '3766'
        when 'WILLOWMAVIN' then '3828'
        when 'WINDHAM' then '3834'
        when 'WORROUGH' then '3903'
        when 'PUCKA' then '3420'
        when 'SPRING PL' then '3496'
        when 'WILLOWMAV' then '3828'
        when 'WALLAN WAL' then '3707'
        else ''
    end as parish_code,
    case L.parish_desc
        when 'KILMORE' then '5420'
        when 'MERINGO TN' then '5518'
        else ''
    end as township_code,
    '358' as lga_code,
    cast ( P.prop_id as varchar ) as assnum
from
    techone_nucland L
    join techone_nucassociation A on L.land_id = A.key2 and L.land_status_ind in ( 'C' , 'F')
    join techone_nucproperty P on A.key1 = P.prop_id
where
    A.association_type = '$PROPLAND' and
    ifnull ( A.date_ended , '' ) in ( '' , '1/01/1900' ) and
    P.prop_status_ind in ( 'C' , 'F' )
)
)
)
