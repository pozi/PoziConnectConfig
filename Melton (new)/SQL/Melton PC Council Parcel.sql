select
    *,
    case
        when plan_prefix in ( 'CP' , 'PC' ) then plan_number
        else lot_number || '\' || plan_number
    end as spi,
    case
        when plan_prefix in ( 'CP' , 'PC' ) then plan_numeral
        else lot_number || '\' || plan_numeral
    end as simple_spi
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
        when auprparc.ttl_cde = '1' then 'LP' || auprparc.ttl_no5
        when auprparc.ttl_cde = '2' then 'PC' || auprparc.ttl_no5
        when auprparc.ttl_cde = '5' then 'SP' || auprparc.ttl_no5
        when auprparc.ttl_cde = '7' then 'RP' || auprparc.ttl_no5
        when auprparc.ttl_cde = '12' then 'TP' || auprparc.ttl_no5
        when auprparc.ttl_cde = '13' then 'PS' || auprparc.ttl_no5
        else ''
    end , 1 , 8 ) as plan_number,
     case
        when auprparc.ttl_cde = '1' then 'LP'
        when auprparc.ttl_cde = '2' then 'PC'
        when auprparc.ttl_cde = '5' then 'SP'
        when auprparc.ttl_cde = '7' then 'RP'
        when auprparc.ttl_cde = '12' then 'TP'
        when auprparc.ttl_cde = '13' then 'PS'
        else ''
    end as plan_prefix,
    substr ( auprparc.ttl_no5 , 1 , 6 ) as plan_numeral,
    case
        when auprparc.ttl_cde in ('1','2','5','7','12',13) then upper ( ifnull ( auprparc.ttl_no1 , '' ) )
        else ''
    end as lot_number,
    case
        when auprparc.ttl_cde in ( '3' , '6' ) then trim ( auprparc.ttl_no5 ) || ifnull ( auprparc.ttl_no6 , '' )
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde = '3' then auprparc.ttl_no4
        when auprparc.ttl_cde = '6' then auprparc.ttl_no3
        else ''
    end as section,
    case
        when auprparc.ttl_cde in ( '3' , '6' ) then aualrefn.dsc_no1
        else ''
    end as parish,
    fmt_ttl as summary	
FROM
    AUTHORITY_auprparc auprparc,
    AUTHORITY_auprstad auprstad,
    AUTHORITY_ausrsubr ausrsubr,
    AUTHORITY_aualrefn aualrefn
WHERE
    ( auprparc.pcl_num = auprstad.pcl_num ) and
    ( auprstad.sbr_nme = ausrsubr.sbr_nme ) and
    auprparc.pcl_flg = 'R' and
    auprparc.ass_num is not null and
    auprparc.udn_cd1 = aualrefn.ref_val and
    aualrefn.ref_typ = 'udn_cd1'
)