select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
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
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select distinct
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    '' as status,
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
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
    ifnull ( replace ( lpasect.parcelsect , 'NO' , '' ) , '' ) as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case lpadesc.descr
        when 'Axedale' then '2034'
        when 'Bagshot' then '2039'
        when 'Costerfield' then '2458'
        when 'Crosbie' then '2467'
        when 'Dargile' then '2488'
        when 'Diggorra' then '2523'
        when 'Egerton' then '2578'
        when 'Ellesmere' then '2585'
        when 'Elmore' then '2588'
        when 'Eppalock' then '2596'
        when 'Goornong' then '2706'
        when 'Heathcote' then '2750'
        when 'Huntly' then '2770'
        when 'Kamarooka' then '2825'
        when 'Kimbolton' then '2879'
        when 'Knowsley' then '2892'
        when 'Knowsley East' then '2893'
        when 'Langwornor' then '2973'
        when 'Leichardt' then '2986'
        when 'Lockwood' then '3006'
        when 'Lyell' then '3023'
        when 'Mandurang' then '3051'
        when 'Marong' then '3068'
        when 'Minto' then '3116'
        when 'Moormbool West' then '3171'
        when 'Neilborough' then '3294'
        when 'Nerring' then '3301'
        when 'Nolan' then '3316'
        when 'Ravenswood' then '3442'
        when 'Redcastle' then '3445'
        when 'Redesdale' then '3446'
        when 'Sandhurst' then '3473'
        when 'Sedgwick' then '3480'
        when 'Shelbourne' then '3483'
        when 'Spring Plains' then '3496'
        when 'Strathfieldsaye' then '3506'
        when 'Tooborac' then '3611'
        when 'Warragamba' then '3747'
        when 'Wellsford' then '3789'
        when 'Weston' then '3801'
        when 'Whirrakee' then '3806'
        when 'Woodstock' then '3875'
        when 'Yallook' then '3936'
        when 'Yarraberb' then '3961'
        else ''
    end as parish_code,
    case lpadesc.descr
        when 'Ascot Township' then '5020'
        when 'Axedale Township' then '5024'
        when 'Costerfield Township' then '5201'
        when 'Eaglehawk Township' then '3473B'
        when 'Elmore Township' then '5277'
        when 'Epsom Township' then '5284'
        when 'Fosterville Township' then '5297'
        when 'Goornong Township' then '5335'
        when 'Heathcote Township' then '5373'
        when 'Huntly Township' then '5389'
        when 'Kangaroo Flat Tship' then '5403'
        when 'Lockwood Township' then '5473'
        when 'Mandurang Township' then '5497'
        when 'Marong Township' then '5505'
        when 'Mia Mia Township' then '5527'
        when 'Neilborough Township' then '5583'
        when 'Ravenswood Township' then '5665'
        when 'Raywood Township' then '5667'
        when 'Redcastle Township' then '5669'
        when 'Redesdale Township' then '5670'
        when 'Sebastian Township' then '5706'
        when 'Strath Township' then '5740'
        when 'White Hills Township' then '5854'
        when 'at Bendigo' then '3473A'
        when 'at Eaglehawk' then '3473B'
        else ''
    end as township_code,
    '325' as lga_code
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