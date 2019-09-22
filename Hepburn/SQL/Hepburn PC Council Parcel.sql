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
    '' as internal_spi,
    ifnull ( substr ( P.override_legal_description , 1 , 99 ) , '' ) as summary,
    case P.status
        when 'C' then 'A'
        when 'F' then 'P'
        else ''
    end as status,
    case
        when ifnull ( part_lot , '' ) <> '' then 'P'
        else ''
    end as part,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then L.plan_desc || L.plan_no
        else ''
    end as plan_number,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then L.plan_desc
        else ''
    end as plan_prefix,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then L.plan_no
        else ''
    end as plan_numeral,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then upper ( replace ( ifnull ( L.lot , '' ) , ' ' , '' ) )
        else ''
    end as lot_number,
    case
        when ifnull ( L.plan_desc , '' ) = '' then L.lot
        else ''
    end as allotment,
    case
        when L.plan_desc in ( 'CP' , 'CS' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else replace ( replace ( ifnull ( L.section_for_lot , '' ) , 'NS' , '' ) , 'No S' , '' )
    end as sec,
    '' as block,
    ifnull ( L.parish_portion , '' ) as portion,
    '' as subdivision,
    case L.parish_desc
        when 'PAM' then '2012'
        when 'PBA' then '2046'
        when 'PBE' then '2097'
        when 'PBK' then '2261'
        when 'PBL' then '2160'
        when 'PBN' then '2279'
        when 'PBO' then '2262'
        when 'PBU' then '2293'
        when 'PCA' then '2326'
        when 'PCL' then '2391'
        when 'PCO' then '2409'
        when 'PCR' then '2464'
        when 'PDE' then '2503'
        when 'PDR' then '2552'
        when 'PED' then '2576'
        when 'PEG' then '2579'
        when 'PFR' then '2618'
        when 'PGL' then '2674'
        when 'PGN' then '2678'
        when 'PHO' then '2760'
        when 'PKO' then '2930'
        when 'PSH' then '3495'
        when 'PSM' then '3490'
        when 'PTO' then '3638'
        when 'PTR' then '3649'
        when 'PTY' then '3673'
        when 'PWO' then '3857'
        when 'PYA' then '3947'
        else ifnull ( L.parish_desc , '' )
    end as parish_code,
    case L.county_desc
        when 'TAL' then ''
        when 'TRI' then ''
        when 'TBO' then '5126'
        when 'TBR' then '5117'
        when 'TBS' then '5127'
        when 'TCA' then '5146'
        when 'TCL' then '5178'
        when 'TCM' then '5189'
        when 'TCR' then '5211'
        when 'TDD' then '5253'
        when 'TDF' then '5231'
        when 'TDW' then '5232'
        when 'TFR' then '5300'
        when 'TGL' then '5323'
        when 'TGN' then '5324'
        when 'THE' then '5377'
        when 'THO' then '5383'
        when 'TLA' then '5456'
        when 'TLH' then '5459'
        when 'TLY' then '5485'
        when 'TNB' then '5589'
        when 'TNE' then '5591'
        when 'TSM' then '5719'
        when 'TTR' then '5802'
        when 'TYA' then '5896'
        else ifnull ( L.county_desc , '' )
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
    ifnull ( L.plan_desc , '' ) in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' )
)
)
