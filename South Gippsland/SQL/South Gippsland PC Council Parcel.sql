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
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    case lpaparc.status
        when 'C' then 'A'
        when 'A' then 'P'
    end as status,
    '' as crefno,
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
        when lpaparc.parcelcode in ( 'CA' , 'PTCA' , 'PORT' , 'PTPORT' ) then ''
        when lpaparc.parcelcode = 'RES' then 'RES' || ifnull ( lpaparc.parcelnum , '' )
        else ifnull ( lpaparc.parcelnum , '' )
    end as lot_number,
    case
        when lpaparc.parcelcode = 'CA' and lpaparc.fmtparcel like 'CA%' then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'CA' , '' ) , 1, 10 ) )
        when lpaparc.parcelcode = 'PTCA' and lpaparc.fmtparcel like 'PTCA%' then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'PTCA' , '' ) , 1, 10 ) )
        when lpaparc.parcelcode = 'PORT' and lpaparc.fmtparcel like 'CP%' and substr ( lpaparc.fmtparcel , 4 , 1 ) not in ( 'P' , 'S' ) then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'CP' , '' ) , 1, 10 ) )
        when lpaparc.parcelcode = 'PTPORT' and lpaparc.fmtparcel like 'PTCP%' then trim ( substr ( replace ( replace ( lpaparc.fmtparcel , ' ' , '     ' ) , 'PTCP' , '' ) , 1, 10 ) )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.parcelcode not in ( 'CA' , 'PTCA' , 'PORT' , 'PTPORT' ) then ''
        when lpaparc.fmtparcel like '%P/BAYNTON%' then '2094'
        when lpaparc.fmtparcel like '%P/BLACKWOOD%' then '2160'
        when lpaparc.fmtparcel like '%P/BULLENGAROOK%' then '2265'
        when lpaparc.fmtparcel like '%P/BURKE%' then '2293'
        when lpaparc.fmtparcel like '%P/BYLANDS%' then '2318'
        when lpaparc.fmtparcel like '%P/CARLSRUHE%' then '2348'
        when lpaparc.fmtparcel like '%P/CHINTIN%' then '2385'
        when lpaparc.fmtparcel like '%P/COBAW%' then '2392'
        when lpaparc.fmtparcel like '%P/COLIBAN%' then '2409'
        when lpaparc.fmtparcel like '%P/COORNMILL%' then '2444'
        when lpaparc.fmtparcel like '%P/DARRAWEIT GUIM%' then '2496'
        when lpaparc.fmtparcel like '%P/EDGECOMBE%' then '2576'
        when lpaparc.fmtparcel like '%P/GISBORNE%' then '2662'
        when lpaparc.fmtparcel like '%P/GLENHOPE%' then '2675'
        when lpaparc.fmtparcel like '%P/GOLDIE%' then '2694'
        when lpaparc.fmtparcel like '%P/HAVELOCK%' then '2746'
        when lpaparc.fmtparcel like '%P/KERRIE%' then '2865'
        when lpaparc.fmtparcel like '%P/LANCEFIELD%' then '2962'
        when lpaparc.fmtparcel like '%P/LANGLEY%' then '2970'
        when lpaparc.fmtparcel like '%P/LAURISTON%' then '2979'
        when lpaparc.fmtparcel like '%P/MACEDON%' then '3027'
        when lpaparc.fmtparcel like '%P/MONEGEETTA%' then '3150'
        when lpaparc.fmtparcel like '%P/NEWHAM%' then '3304'
        when lpaparc.fmtparcel like '%P/ROCHFORD%' then '3455'
        when lpaparc.fmtparcel like '%P/SPRINGFIELD%' then '3494'
        when lpaparc.fmtparcel like '%P/TRENTHAM%' then '3649'
        when lpaparc.fmtparcel like '%P/TYLDEN%' then '3673'
        when lpaparc.fmtparcel like '%P/WOODEND%' then '3872'
        else ''
    end as parish_code,
    case
        when lpaparc.parcelcode not in ( 'CA' , 'PTCA' , 'PORT' , 'PTPORT' ) then ''
        when lpaparc.fmtparcel like '%T/BARRINGO%' then '5049'
        when lpaparc.fmtparcel like '%T/CARLSRUHE%' then '5155'
        when lpaparc.fmtparcel like '%T/CHEROKEE%' then '5169'
        when lpaparc.fmtparcel like '%T/DARRAWEIT GUIM%' then '5228'
        when lpaparc.fmtparcel like '%T/GISBORNE%' then '5320'
        when lpaparc.fmtparcel like '%T/KYNETON%' then '5439'
        when lpaparc.fmtparcel like '%T/LANCEFIELD%' then '5450'
        when lpaparc.fmtparcel like '%T/LAURISTON%' then '5454'
        when lpaparc.fmtparcel like '%T/MACEDON%' then '5487'
        when lpaparc.fmtparcel like '%T/MALMSBURY%' then '5495'
        when lpaparc.fmtparcel like '%T/RIDDELL%' then '5675'
        when lpaparc.fmtparcel like '%T/ROMSEY%' then '5681'
        when lpaparc.fmtparcel like '%T/SPRING HILL%' then '5726'
        when lpaparc.fmtparcel like '%T/TYLDEN%' then '5809'
        when lpaparc.fmtparcel like '%T/WOODEND%' then '5874'
        else ''
    end as township_code,
    '361' as lga_code
from
    pathway_lpaprop as lpaprop left join
    pathway_lpaadpr as lpaadpr on lpaprop.tpklpaprop = lpaadpr.tfklpaprop left join
    pathway_lpaaddr as lpaaddr on lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr left join
    pathway_cnacomp as cnacomp on lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp left join
    pathway_lpaprti_mod as lpaprti_mod on lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop left join
    pathway_lpatitl as lpatitl on lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl left join
    pathway_lpatipa as lpatipa on lpatitl.tpklpatitl = lpatipa.tfklpatitl left join
    pathway_lpaparc as lpaparc on lpatipa.tfklpaparc = lpaparc.tpklpaparc left join
    pathway_lpacrwn as lpacrwn on lpaparc.tpklpaparc = lpacrwn.tfklpaparc left join
    pathway_lpasect as lpasect on lpaparc.tpklpaparc = lpasect.tfklpaparc left join
    pathway_lpadepa as lpadepa on lpaparc.tpklpaparc = lpadepa.tfklpaparc
where
   lpaprop.status = 'C' and
   lpaparc.status = 'C' and
   lpatipa.status = 'C' and
   lpaprti_mod.status = 'C' and
   lpatitl.status = 'C' and
   lpaparc.fmtparcel not like 'U/R Licence%'
)