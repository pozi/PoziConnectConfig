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
select distinct
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as crefno,
    case
        when lpaparc.parcelcode in ( 'PT' , 'PTL' , 'PTRES' , 'PTU' ) then 'P'
        when lpaparc.parcelnum in ( 'PT' , 'PTL' , 'PART' ) then 'P'
        else ''
    end as part,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else lpaparc.plancode ||
            case
                when substr ( lpaparc.plannum , 1 , 4 ) = '0000' then cast ( cast ( substr ( lpaparc.plannum , 5 , 6 ) as integer ) as varchar )
                when substr ( lpaparc.plannum , 1 , 3 ) = '000' then cast ( cast ( substr ( lpaparc.plannum , 4 , 6 ) as integer ) as varchar )
                when substr ( lpaparc.plannum , 1 , 2 ) = '00' then cast ( cast ( substr ( lpaparc.plannum , 3 , 6 ) as integer ) as varchar )
                when substr ( lpaparc.plannum , 1 , 1 ) = '0' then cast ( cast ( substr ( lpaparc.plannum , 2 , 6 ) as integer ) as varchar )
                when substr ( lpaparc.plannum , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then cast ( cast ( substr ( lpaparc.plannum , 3 , 6 ) as integer ) as varchar )
                when substr ( trim ( lpaparc.plannum ) , 1 , 1 ) in ( '1','2','3','4','5','6','7','8','9' ) then cast ( cast ( trim ( lpaparc.plannum ) as integer ) as varchar )
            else ifnull ( lpaparc.plannum , '' )
        end
    end as plan_number,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when substr ( lpaparc.plannum , 1 , 4 ) = '0000' then cast ( cast ( substr ( lpaparc.plannum , 5 , 6 ) as integer ) as varchar )
        when substr ( lpaparc.plannum , 1 , 3 ) = '000' then cast ( cast ( substr ( lpaparc.plannum , 4 , 6 ) as integer ) as varchar )
        when substr ( lpaparc.plannum , 1 , 2 ) = '00' then cast ( cast ( substr ( lpaparc.plannum , 3 , 6 ) as integer ) as varchar )
        when substr ( lpaparc.plannum , 1 , 1 ) = '0' then cast ( cast ( substr ( lpaparc.plannum , 2 , 6 ) as integer ) as varchar )
        when substr ( lpaparc.plannum , 1 , 2 ) in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then cast ( cast ( substr ( lpaparc.plannum , 3 , 6 ) as integer ) as varchar )
        when substr ( trim ( lpaparc.plannum ) , 1 , 1 ) in ( '1','2','3','4','5','6','7','8','9' ) then cast ( cast ( trim ( lpaparc.plannum ) as integer ) as varchar )
        else ifnull ( lpaparc.plannum , '' )
    end as plan_numeral,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        else
            case
                when parcelcode in ( 'PTRES' , 'RES' ) then 'RES'
                else ''
            end ||
            ifnull ( replace ( replace ( replace ( lpaparc.parcelnum , 'PTL' , '' ) , 'PT' , '' ) , 'PART' , '' ) , '' )
    end as lot_number,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then replace ( ifnull ( lpaparc.parcelnum , '' ) , 'PT' , '' )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    case
        when lpaparc.plancode is null or lpaparc.plancode not in ( '' , 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ifnull ( lpaparc.plannum , '' )
        else ''
    end as portion,
    '' as subdivision,
    case upper ( lpadesc.descr )
        when 'DANDENONG' then '2483'
        when 'MORDIALLOC' then '3186'
        when 'MULGRAVE' then '3212'
        when 'PRAHRAN' then '3416'
        else ''
    end as parish_code,
    case
        when lpaparc.fmtparcel like '%Township Oakleigh%' then '5614'
        else ''
    end as township_code,
    '348' as lga_code,
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as assnum
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_lpaprti as lpaprti on lpaprop.tpklpaprop = lpaprti.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc left join
    pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H'
)
