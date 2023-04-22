select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when constructed_spi <> '' then constructed_spi
        when internal_spi <> '' then internal_spi
        else ''
    end as spi,
    case
        when constructed_spi <> '' then 'council_attributes'
        when internal_spi <> '' then 'council_spi'
        else ''
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
select distinct
    cast ( cast ( lpaprop.tpklpaprop as integer ) as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as crefno,
    ifnull ( lpaparc.spi , '' ) as internal_spi,
    case
        when lpaparc.parcelcode like 'PT%' then 'P'
        else ''
    end as part,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.parcelcode = 'CA' then ''
        when lpaparc.plancode in ( '1PS' , 'PS' , 'SUBDV' ) then 'PS'
        when lpaparc.plancode in ( '2TP' , 'TP' , 'TITLE' ) then 'TP'
        when lpaparc.plancode in ( '3LP' , 'LP' , 'LODGED' ) then 'LP'
        when lpaparc.plancode in ( '4PC' , 'PC' , 'CONSOL' ) then 'PC'
        when lpaparc.plancode in ( '5RP' , 'RP' , 'REGIST' ) then 'RP'
        when lpaparc.plancode in ( '6SP' , 'SP' , 'STRAT1' , 'STRATA' ) then 'SP'
        when lpaparc.plancode in ( '7CP' , 'CP' ) then 'CP'
        else ifnull ( lpaparc.plancode , '' )
    end ||
        case
            when lpaparc.parcelcode = 'CA' then ''
            when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( lpaparc.plannum as integer ) as varchar )
            when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 ) as integer ) as varchar )
        else ifnull ( lpaparc.plannum , '' )
        end as plan_number,
    case
        when lpaparc.parcelcode = 'CA' then ''
        when lpaparc.plancode in ( '1PS' , 'PS' , 'SUBDV' ) then 'PS'
        when lpaparc.plancode in ( '2TP' , 'TP' , 'TITLE' ) then 'TP'
        when lpaparc.plancode in ( '3LP' , 'LP' , 'LODGED' ) then 'LP'
        when lpaparc.plancode in ( '4PC' , 'PC' , 'CONSOL' ) then 'PC'
        when lpaparc.plancode in ( '5RP' , 'RP' , 'REGIST' ) then 'RP'
        when lpaparc.plancode in ( '6SP' , 'SP' , 'STRAT1' , 'STRATA' ) then 'SP'
        when lpaparc.plancode in ( '7CP' , 'CP' ) then 'CP'
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.parcelcode = 'CA' then ''
        when substr ( lpaparc.plannum , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( lpaparc.plannum as integer ) as varchar )
        when substr ( lpaparc.plannum , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then cast ( cast ( substr ( lpaparc.plannum , 1 , length ( lpaparc.plannum ) - 1 ) as integer ) as varchar )
        else ifnull ( lpaparc.plannum , '' )
    end as plan_numeral,
    case
        when lpaparc.parcelcode = 'CA' then ''
        when lpaparc.parcelcode = 'RES NO' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    case
        when lpaparc.parcelcode = 'CA' then ifnull ( lpaparc.parcelnum , '' )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.parcelcode = 'CA' and substr ( lpaparc.plannum , 1 , 1 ) in ( '2' , '3' ) then ifnull ( lpaparc.plannum , '' )
        else ''
    end as parish_code,
    case
        when lpaparc.parcelcode = 'CA' and substr ( lpaparc.plannum , 1 , 1 ) in ( '5' ) then ifnull ( lpaparc.plannum , '' )
        else ''
    end as township_code,
    '316' as lga_code,
    ifnull ( cast ( cast ( lraassm.assmnumber as integer ) as varchar ) , '' ) as assnum
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
    pathway_lpadesc as lpadesc on lpadepa.tfklpadesc = lpadesc.tpklpadesc left join
    pathway_lparole as lparole on lpaprop.tpklpaprop = lparole.tfklocl left join
    pathway_lraassm as lraassm on lparole.tfkappl = lraassm.tpklraassm
where
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H'
)
)
)
