select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
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
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            allotment ||
            case when sec <> '' then '~' || sec else '' end ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
        else ''
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case
        when auprparc.ttl_cde = 6 OR auprparc.ttl_no2 in ( 'P' , 'PT' ) then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 12 then 'TP'
        when auprparc.ttl_cde = 13 then 'PS'
        else ''
    end ||
        case
            when null then ''
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then trim ( auprparc.ttl_no5 )
            when substr ( trim ( auprparc.ttl_no5 ) , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then substr ( trim ( auprparc.ttl_no5 ) , 1 , length ( trim ( auprparc.ttl_no5 ) ) - 1 )        
            else ''
        end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'LP'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 5 then 'SP'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 12 then 'TP'
        when auprparc.ttl_cde = 13 then 'PS'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 5 , 7 , 12 , 13 ) then ifnull ( auprparc.ttl_no5 , '' )
        else ''
    end as plan_numeral,
    case
        when auprparc.ttl_cde in ( 1 , 2 , 5 , 7 , 12 , 13 ) then ifnull ( auprparc.ttl_no1 , '' )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde in ( 3 , 6 ) then trim ( auprparc.ttl_no5 ) || ifnull ( auprparc.ttl_no6 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde = 3 then ifnull ( auprparc.ttl_no4 , '' )
        when auprparc.ttl_cde = 6 then ifnull ( auprparc.ttl_no3 , '' )
        else ''
    end as sec,
    case
        when auprparc.ttl_cde in ( 3 , 6 ) then
            case upper ( aualrefn.dsc_no1 )
                when 'TYNTYNDER WEST' then '3676'
                else ''
            end
        else ''
    end as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '366' as lga_code
from
    AUTHORITY_auprparc auprparc,
--    AUTHORITY_auprstad auprstad,
--    AUTHORITY_ausrsubr ausrsubr,
    AUTHORITY_aualrefn aualrefn
where
--    auprparc.pcl_num = auprstad.pcl_num and
--    auprstad.sbr_nme = ausrsubr.sbr_nme and
    auprparc.pcl_flg in ( 'R' , 'P' ) and
    auprparc.ass_num is not null and
    auprparc.udn_cd1 = aualrefn.ref_val and
    aualrefn.ref_typ = 'udn_cd1' and
    ttl_no1 not like 'CM%'
order by
    ass_num
)