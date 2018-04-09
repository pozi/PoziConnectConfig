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
    '' as crefno,
    case
        when lpaparc.plancode = 'PTCA' then 'P'
        else ''
    end as part,
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.plannum is null then ''
        when lpaparc.plancode in ( 'CA' , 'PTCA' ) then ''
        else ifnull ( lpaparc.plancode , '' ) || ifnull ( cast ( cast ( lpaparc.plannum as integer ) as varchar ) , '' )
    end as plan_number,
    case
        when lpaparc.plancode in ( 'CA' , 'PTCA' ) then ''
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.plannum is null then ''
        when lpaparc.plancode in ( 'CA' , 'PTCA' ) then ''
        else ifnull ( cast ( cast ( lpaparc.plannum as integer ) as varchar ) , '' )
    end as plan_numeral,
    case
        when lpaparc.plannum is null then ''
        when lpaparc.plancode in ( 'CA' , 'PTCA' ) then ''
        when lpaparc.parcelnum like '%BLK%' then cast ( cast ( parcelnum as integer ) as varchar )
        when lpaparc.parcelcode in ( 'RES' , 'PLRES' ) then
            case
                when lpaparc.parcelnum like 'RES%' then lpaparc.parcelnum
                when trim ( lpaparc.parcelnum ) like 'R%' then replace ( trim ( lpaparc.parcelnum ) , 'R' , 'RES' )
                else 'RES' || ifnull ( lpaparc.parcelnum , '' )
            end
        else ifnull ( replace ( lpaparc.parcelnum , ' ' , '' ) , '' )
    end as lot_number,
    case
        when lpaparc.plancode in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when lpaparc.plancode in ( 'CA' , 'PTCA' ) then ifnull ( lpaparc.plannum , '' )
        when lpaparc.parcelcode in ( 'CA' , 'PTCA' ) then ifnull ( lpaparc.parcelnum , '' )
        else ''
    end as allotment,
    ifnull ( lpasect.parcelsect , '' ) as sec,
    case
        when lpaparc.parcelnum like '%BLK%' then replace ( replace ( replace ( substr ( lpaparc.parcelnum , 4 , 99 ) , 'B' , '' ) , 'L' , '' ) , 'K' , '' )
        else ''
    end as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.plancode in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when lpadesc.descr is not null then
            case upper ( lpadesc.descr )
                when 'BINGINWARRI' then '2149'
                when 'BOOLA BOOLA' then '2183'
                when 'BUDGEREE' then '2250'
                when 'BULGA' then '2255'
                when 'CALLIGNEE' then '2322'
                when 'GLENMAGGIE' then '2679'
                when 'GUNYAH GUNYAH' then '2736'
                when 'HAZELWOOD' then '2749'
                when 'JEERALANG' then '2786'
                when 'JUMBUK' then '2808'
                when 'LOY YANG' then '3020'
                when 'MARYVALE' then '3072'
                when 'MIRBOO' then '3119'
                when 'MIRBOO SOUTH' then '3120'
                when 'MOE' then '3135'
                when 'NARRACAN' then '3273'
                when 'NARRACAN SOUTH' then '3274'
                when 'NUMBRUK' then '3336'
                when 'ROSEDALE' then '3457'
                when 'TANJIL' then '3542'
                when 'TANJIL EAST' then '3543'
                when 'TONG BONG' then '3604'
                when 'TOONGABBIE NORTH' then '3626'
                when 'TOONGABBIE SOUTH' then '3627'
                when 'TRARALGON' then '3647'
                when 'WALHALLA EAST' then '3703'
                when 'WINNINDOO' then '3841'
                when 'WONYIP' then '3870'
                when 'YARRAGON' then '3962'
                when 'YINNAR' then '3993'
                else ''
            end
        else ''
    end as parish_code,
    case
        when lpaparc.plancode in ( 'CP' , 'CS' , 'LP' , 'PC' , 'PS' , 'RP' , 'SP' , 'TP' ) then ''
        when lpadesc.descr is not null then
            case upper ( lpadesc.descr )
                when 'BOOLARRA (TOWNSHIP)' then '5097'
                when 'CALLIGNEE (TOWNSHIP)' then '5143'
                when 'COALVILLE (TOWNSHIP)' then '5179'
                when 'DARLIMURLA (TOWNSHIP)' then '5224'
                when 'FLYNN (TOWNSHIP)' then '5293'
                when 'FLYNNS CREEK UPPER (TOWNSHIP)' then '5294'
                when 'JEERALANG JUNCTION (TOWNSHIP)' then '5398'
                when 'MOE (TOWNSHIP)' then '5542'
                when 'MORWELL (TOWNSHIP)' then '5554'
                when 'TOONGABBIE (TOWNSHIP)' then '5795'
                when 'TRARALGON (TOWNSHIP)' then '5801'
                when 'TYERS (TOWNSHIP)' then '5808'
                when 'WESTBURY (TOWNSHIP)' then '5850'
                else ''
            end
        else ''
    end as township_code,
    '337' as lga_code,
    cast ( cast ( lraassm.assmnumber as integer ) as varchar ) as assnum
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
    lraassm.status <> 'H' and
    lpaprop.status <> 'H' and
    lpaparc.status <> 'H' and
    lpatipa.status <> 'H' and
    lpaprti.status <> 'H' and
    lpatitl.status <> 'H' and
    ifnull ( lpadesc.tfklpadetp , '' ) <> 20
)
)
