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
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select
    case
        when ttl_no1 like 'CM%' then 'NCPR'
        else cast ( auprparc.ass_num as varchar(10) )
    end as propnum,
    '' as status,
    case
        when ttl_no1 like 'CM%' then ''
        else cast ( auprparc.pcl_num as varchar(10) )
    end as crefno,
    case
        when auprparc.ttl_no2 in ( 'P' , 'PT' ) then 'P'
        else ''
    end as part,
    substr ( case
        when auprparc.ttl_cde = 1 then 'LP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 2 then 'CP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 5 then 'SP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 7 then 'RP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 12 then 'TP' || auprparc.ttl_no5
        when auprparc.ttl_cde = 13 then 'PS' || auprparc.ttl_no5
        when auprparc.ttl_cde = 14 then 'PC' || auprparc.ttl_no5
        else ''
    end , 1 , 8 ) as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'CP'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 12 then 'TP'
        when auprparc.ttl_cde = 13 then 'PS'
        when auprparc.ttl_cde = 14 then 'PC'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 5 , 7 , 12 , 13 , 14 ) then ifnull ( substr ( auprparc.ttl_no5 , 1 , 6 ) , '' )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 5 , 7 , 12 , 13 , 14 ) then replace ( upper ( ifnull ( auprparc.ttl_no1 , '' ) ) , ' ' , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 3 , 6 ) then ifnull ( trim ( auprparc.ttl_no5 ) , '' ) || ifnull ( auprparc.ttl_no6 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 3 , 7 , 8 , 12 ) then ifnull ( auprparc.ttl_no4 , '' )
        when auprparc.ttl_cde = 6 then ifnull ( auprparc.ttl_no3 , '' )
        else ''
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when auprparc.ttl_cde in ( 3 , 6 ) then
            case upper ( aualrefn.dsc_no1 )
                when 'ACHERON' then '2001'
                when 'ALEXANDRA' then '2009'
                when 'BANYARMBITE' then '2064'
                when 'BILLIAN' then '2144'
                when 'BRANKEET' then '2221'
                when 'BUXTON' then '2312'
                when 'DARLINGFORD' then '2491'
                when 'DERRIL' then '2515'
                when 'DROPMORE' then '2546'
                when 'EILDON' then '2580'
                when 'ENOCHS POINT' then '2593'
                when 'FLOWERDALE' then '2614'
                when 'GARRATANBUNELL' then '2635'
                when 'GHIN GHIN' then '2651'
                when 'GLENDALE' then '2670'
                when 'GLENWATTS' then '2686'
                when 'GOBUR' then '2693'
                when 'GOULBURN' then '2713'
                when 'GRANTON' then '2719'
                when 'HOWQUA WEST' then '2769'
                when 'KERRISDALE' then '2866'
                when 'KILLINGWORTH' then '2877'
                when 'KINGLAKE' then '2881'
                when 'KNOCKWOOD' then '2891'
                when 'KOBYBOYN' then '2894'
                when 'LAURAVILLE' then '2978'
                when 'LINTON' then '3000'
                when 'LODGE PARK' then '3008'
                when 'MAINTONGOON' then '3038'
                when 'MANANGO' then '3050'
                when 'MERTON' then '3098'
                when 'MOHICAN' then '3137'
                when 'MOLESWORTH' then '3142'
                when 'MONDA' then '3147'
                when 'MURRINDINDI' then '3237'
                when 'NARBETHONG' then '3263'
                when 'NIAGAROON' then '3308'
                when 'RUFFY' then '3460'
                when 'ST. CLAIR' then '3464'
                when 'STEAVENSON' then '3500'
                when 'SWITZERLAND' then '3516'
                when 'TAGGERTY' then '3521'
                when 'TAPONGA' then '3545'
                when 'TARLDARN' then '3550'
                when 'TARRAWARRA NORTH' then '3559'
                when 'THORNTON' then '3587'
                when 'TORBRECK' then '3636'
                when 'TRAAWOOL' then '3645'
                when 'WAPPAN' then '3734'
                when 'WHANREGARWEN' then '3803'
                when 'WINDHAM' then '3834'
                when 'WOODBOURNE' then '3871'
                when 'WORROUGH' then '3903'
                when 'YARCK' then '3958'
                when 'YEA' then '3979'
                when 'YOUARRABUK' then '3997'
                else ifnull ( upper ( aualrefn.dsc_no1 ) , '' )
            end
        else ''
    end as parish_code,
    case
        when auprparc.ttl_cde in ( 3 , 6 ) and auprparc.udn_cd2 > 5000 then cast ( auprparc.udn_cd2 as varchar )
        else ''
    end as township_code,
    fmt_ttl as summary,
    '355' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc auprparc,
    authority_auprstad auprstad,
    authority_ausrsubr ausrsubr,
    authority_aualrefn aualrefn
where
    auprparc.pcl_num = auprstad.pcl_num and
    auprstad.sbr_nme = ausrsubr.sbr_nme and
    auprparc.pcl_flg = 'R' and
    auprparc.ass_num is not null and
    auprparc.udn_cd1 = aualrefn.ref_val and
    aualrefn.ref_typ = 'udn_cd1'
order by auprparc.pcl_num
)
)