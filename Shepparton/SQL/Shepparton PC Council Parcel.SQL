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
select distinct
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
    '' as internal_spi,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    ifnull ( lpaparc.plancode , '' ) ||
        case
            when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
            when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 )
            else ''
        end as plan_number,
    ifnull ( lpaparc.plancode , '' ) as plan_prefix,
    case
        when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then lpaparc.plannum
        when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 )
        else ''
    end as plan_numeral,
    case
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    ifnull ( lpaparc.parcelnum , '' ) as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.fmtparcel like '%Parish of Arcadia' then '2022'
        when lpaparc.fmtparcel like '%Parish of Caniambo' then '2328'
        when lpaparc.fmtparcel like '%Parish of Congupna' then '2423'
        when lpaparc.fmtparcel like '%Parish of Coomboona' then '2434'
        when lpaparc.fmtparcel like '%Parish of Currawa' then '2475'
        when lpaparc.fmtparcel like '%Parish of Dookie' then '2535'
        when lpaparc.fmtparcel like '%Parish of Dargalong' then '2487'
        when lpaparc.fmtparcel like '%Parish of Gowangardie' then '2714'
        when lpaparc.fmtparcel like '%Parish of Girgarre East' then '2661'
        when lpaparc.fmtparcel like '%Parish of Karramomus' then '2845'
        when lpaparc.fmtparcel like '%Parish of Katandra' then '2850'
        when lpaparc.fmtparcel like '%Parish of Kialla' then '2872'
        when lpaparc.fmtparcel like '%Parish of Kyabram East' then '2949'
        when lpaparc.fmtparcel like '%Parish of Molka' then '3144'
        when lpaparc.fmtparcel like '%Parish of Mooroopna' then '3177'
        when lpaparc.fmtparcel like '%Parish of Mooroopna West' then '3178'
        when lpaparc.fmtparcel like '%Parish of Murchison' then '3222'
        when lpaparc.fmtparcel like '%Parish of Murchison N%th' then '3223'
        when lpaparc.fmtparcel like '%Parish of Noorilim' then '3320'
        when lpaparc.fmtparcel like '%Parish of Pine Lodge' then '3396'
        when lpaparc.fmtparcel like '%Parish of Shepparton' then '3486'
        when lpaparc.fmtparcel like '%Parish of Tallygaroopna' then '3533'
        when lpaparc.fmtparcel like '%Parish of Tamleugh' then '3538'
        when lpaparc.fmtparcel like '%Parish of Toolamba' then '3612'
        when lpaparc.fmtparcel like '%Parish of Toolamba West' then '3613'
        when lpaparc.fmtparcel like '%Parish of Undera' then '3681'
        else ''
    end as parish_code,
    case
        when lpaparc.fmtparcel like '%Town of Murchison' then '5561'
        else ''
    end as township_code,
    '328' as lga_code,
    cast ( lpaprop.tpklpaprop as varchar ) as assnum
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
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
    lpaprop.status = 'C' and
    lpaparc.status = 'C' and
    lpatipa.status = 'C' and
    lpaprti.status = 'C' and
    lpatitl.status = 'C'
)
)