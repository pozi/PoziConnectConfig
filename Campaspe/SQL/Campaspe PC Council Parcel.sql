select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when internal_spi <> '' then 'council_spi'
        when generated_spi <> '' then 'council_attributes'
        else ''
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
            case when sec <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as generated_spi
from
(
select
    cast ( P.property_no as varchar ) as propnum,
    '' as crefno,
    ifnull ( L.text1 , '' ) as internal_spi,
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
        when L.plan_desc is null then ''
        when substr ( trim ( ifnull ( L.plan_no , '' ) ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then trim ( ifnull ( L.plan_desc , '' ) ) || ifnull ( L.plan_no , '' )
        else trim ( ifnull ( L.plan_desc , '' ) ) || substr ( trim ( ifnull ( L.plan_no , '' ) ) , 1 , length ( trim ( ifnull ( L.plan_no , '' ) ) ) - 1 )
    end as plan_number,
    case
        when L.plan_desc is null then ''
        else ifnull ( L.plan_desc , '' )
    end as plan_prefix,
    case
        when L.plan_desc is null then ''
        when substr ( trim ( L.plan_no ) , -1 ) in ( '1','2','3','4','5','6','7','8','9','0' ) then L.plan_no
        else ifnull ( substr ( trim ( L.plan_no ) , 1 , length ( trim ( L.plan_no ) ) - 1 ) , '' )
    end as plan_numeral,
    case
        when L.plan_desc is null then ''
        else ifnull ( L.lot , '' )
    end as lot_number,
    case
        when L.plan_desc is null then ifnull ( L.lot , '' )
        else ''
    end as allotment,
    case
        when L.plan_desc is null then ifnull ( L.parish_section , '' )
        else ifnull ( L.section_for_lot , '' )
    end as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case L.parish_desc
        when 'BAL' then '2048'
        when 'BAM' then '2057'
        when 'BBE' then '2299'
        when 'BON' then '2179'
        when 'BUR' then '2298'
        when 'BWG' then '2295'
        when 'CAM' then '2325'
        when 'CAR' then '2332'
        when 'COL' then '2407'
        when 'CRN' then '2455'
        when 'CRO' then '2467'
        when 'CRP' then '2456'
        when 'DIG' then '2523'
        when 'DIN' then '2526'
        when 'ECN' then '2571'
        when 'ECS' then '2572'
        when 'GIR' then '2660'
        when 'GOB' then '2692'
        when 'GUN' then '2732'
        when 'KAM' then '2825'
        when 'KAN' then '2834'
        when 'KOY' then '2935'
        when 'KYE' then '2949'
        when 'KYP' then '2948'
        when 'MIT' then '3126'
        when 'MLO' then '3104'
        when 'MOO' then '3162'
        when 'MOW' then '3178'
        when 'MUN' then '3223'
        when 'MUR' then '3223'
        when 'MUS' then '3243'
        when 'MWA' then '3103'
        when 'NAN' then '3258'
        when 'PAN' then '3369'
        when 'PAT' then '3378'
        when 'PBM' then '3368'
        when 'RED' then '3445'
        when 'ROC' then '3453'
        when 'ROW' then '3454'
        when 'RUN' then '3461'
        when 'TAR' then '3548'
        when 'TBN' then '3663'
        when 'TIM' then '3596'
        when 'TON' then '3602'
        when 'TOO' then '3617'
        when 'TTE' then '3578'
        when 'TUR' then '3662'
        when 'WAN' then '3719'
        when 'WAR' then '3735'
        when 'WGA' then '3747'
        when 'WHA' then '3804'
        when 'WHO' then '3811'
        when 'WRP' then '3731'
        when 'WYU' then '3924'
        else ''
    end as parish_code,
    '' as township_code,
    '310' as lga_code,
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