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
    ifnull ( lpaparc.plancode || ': ' , '' ) || ifnull ( trim ( lpaparc.fmtparcel ) , '' ) as summary,
    case
        when lpaparc.plannum is null then ''
        else ifnull ( lpaparc.plancode , '' ) || ifnull ( cast ( cast ( lpaparc.plannum as integer ) as varchar ) , '' )
    end as plan_number,
    case
        when lpaparc.plannum is null then ''
        else ifnull ( lpaparc.plancode , '' )
    end as plan_prefix,
    case
        when lpaparc.plannum is null then ''
        else ifnull ( cast ( cast ( lpaparc.plannum as integer ) as varchar ) , '' )
    end as plan_numeral,
    case
        when lpaparc.plannum is null then ''
        else
            case
                when lpaparc.parcelcode = 'R' and lpaparc.parcelnum is not null then 'RES'
                when lpaparc.parcelcode = 'R' and lpaparc.parcelnum is null then 'RES1'
                else ''
            end ||
            case
                when lpaparc.parcelnum in ( 'PT' , 'PART' ) then ''
                else ifnull ( replace ( lpaparc.parcelnum , ' ' , '' ) , '' )
            end
    end as lot_number,
    case
        when lpaparc.plannum is null and lpacrwn.crownallotr is not null then ifnull ( trim ( replace ( replace ( lpacrwn.crownallotr , 'CA' , '' ) , 'PT' , '' ) ) , '' )
        when lpaparc.plannum is null and lpaparc.parcelnum is not null then lpaparc.parcelnum
        else ''
    end as allotment,
    case
        when lpaparc.plancode || lpaparc.plannum in ( 'LP1534','LP4348','LP4942','LP5022','LP6771','LP9422' ) then ifnull ( lpasect.parcelsect , '' )
        when lpaparc.plannum is not null then ''
        else ifnull ( replace ( lpasect.parcelsect , 'PT' , '' ) , '' )
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when lpaparc.plannum is null then
            case upper ( lpadesc.descr )
                when 'BEENAK' then '2101'
                when 'BRIMBONGA' then '2229'
                when 'BULLUNG' then '2268'
                when 'BURGOYNE' then '2292'
                when 'COORNBURT' then '2443'
                when 'ELLINGING' then '2587'
                when 'GEMBROOK' then '2645'
                when 'GLENWATTS' then '2686'
                when 'GOULBURN' then '2713'
                when 'GRACEDALE' then '2717'
                when 'GRANTON' then '2719'
                when 'GRUYERE' then '2729'
                when 'KINGLAKE' then '2881'
                when 'LAURAVILLE' then '2978'
                when 'MANANGO' then '3050'
                when 'MATLOCK' then '3073'
                when 'MONBULK' then '3146'
                when 'MONDA' then '3147'
                when 'MOOLPAH' then '3156'
                when 'MOOROOLBARK' then '3176'
                when 'NANGANA' then '3255'
                when 'NARBETHONG' then '3263'
                when 'NARREE WORRAN' then '3279'
                when 'NAYOOK WEST' then '3290'
                when 'NOOJEE' then '3317'
                when 'NOOJEE EAST' then '3318'
                when 'QUEENSTOWN' then '3437'
                when 'ST CLAIR' then '3464'
                when 'SCORESBY' then '3478'
                when 'STEAVENSON' then '3500'
                when 'SUTTON' then '3513'
                when 'TAPONGA' then '3545'
                when 'TARLDARN' then '3550'
                when 'TARRAWARRA' then '3558'
                when 'TARRAWARRA NORTH' then '3559'
                when 'TONIMBUK EAST' then '3609'
                when 'TARRANGO' then '3632'
                when 'TOORONGO' then '3632'
                when 'WANDIN YALLOCK' then '3721'
                when 'WARBURTON' then '3738'
                when 'WARRANDYTE' then '3753'
                when 'WOORI YALLOCK' then '3888'
                when 'YERING' then '3988'
                when 'YOUARRABUK' then '3997'
                when 'YOURRABUK' then '3997'
                when 'YUONGA' then '4003'
                else
                    case
                        when lpaparc.fmtparcel like '%MONBULK%' then '3146'
                        when lpaparc.fmtparcel like '%MOOROOLBARK%' then '3176'
                        when lpaparc.fmtparcel like '%NARREE WORRAN%' then '3279'
                        when lpaparc.fmtparcel like '%SCORESBY%' then '3478'
                        when lpaparc.fmtparcel like '%ST CLAIR%' then '3464'
                        when lpaparc.fmtparcel like '%WANDIN YALLOCK%' then '3721'
                        else ''
                    end
            end
        else ''
    end as parish_code,
    case
        when lpaparc.plannum is null then
            case upper ( lpadesc.descr )
                when 'TOWNSHIP BEENAK' then '5062'
                when 'BRITANNIA CREEK' then '5112'
                when 'HEALESVILLE' then '5372'
                when 'LAUNCHING PLACE' then '5453'
                when 'LILYDALE' then '5465'
                when 'MONBULK' then '5546'
                when 'OLINDA' then '5616'
                when 'POWELLTOWN' then '5653'
                when 'ST CLAIR' then '5693'
                when 'SEVILLE' then '5710'
                when 'TOWNSHIP HEALESVILLE' then '5372'
                when 'TOWNSHIP POWELLTOWN' then '5653'
                when 'WANDIN YALLOCK' then '5827'
                when 'WARBURTON' then '5831'
                when 'WESBURN' then '5849'
                when 'YARRA JUNCTION' then '5899'
                when 'YELLINGBO' then '5905'
                else ''
            end
        else ''
    end as township_code,
    '377' as lga_code,
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
    lpatitl.status <> 'H' and
    upper ( ifnull ( lpadesc.descr , '' ) ) not in ( 'CF' , 'EVELYN' ) and
    not ( lpadesc.descr is null and plancode is null )
)
)
