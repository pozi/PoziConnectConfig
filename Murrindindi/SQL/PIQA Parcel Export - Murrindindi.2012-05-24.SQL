SELECT
    CAST ( auprparc.ass_num as varchar(10) ) AS propnum,
	 CAST ( auprparc.pcl_num as varchar(10) ) AS crefno,
    CASE
        WHEN auprparc.ttl_cde = '6' OR auprparc.ttl_no2 IN ( 'P' , 'PT' ) THEN 'P'
        ELSE ''
    END AS part,
    CASE
        WHEN auprparc.ttl_cde = '1' THEN 'LP' || auprparc.ttl_no5
        WHEN auprparc.ttl_cde = '2' THEN 'PC' || auprparc.ttl_no5
        WHEN auprparc.ttl_cde = '5' THEN 'SP' || auprparc.ttl_no5
        WHEN auprparc.ttl_cde = '7' THEN 'RP' || auprparc.ttl_no5
        WHEN auprparc.ttl_cde = '12' THEN 'TP' || auprparc.ttl_no5
        ELSE ''
    END AS plan_number,
    CASE
        WHEN auprparc.ttl_cde IN ('1','2','5','7','12') THEN IFNULL ( auprparc.ttl_no1 , '' )
        ELSE ''
    END AS lot_number,
    CASE
        WHEN auprparc.ttl_cde IN ( '3' , '6' ) THEN TRIM ( auprparc.ttl_no5 ) || IFNULL ( auprparc.ttl_no6 , '' )
        ELSE ''
    END AS allotment,
    CASE
        WHEN auprparc.ttl_cde = '3' THEN auprparc.ttl_no4
        WHEN auprparc.ttl_cde = '6' THEN auprparc.ttl_no3
        ELSE ''
    END AS section,
    CASE
        WHEN auprparc.ttl_cde IN ( '3' , '6' ) THEN aualrefn.dsc_no1
        ELSE ''
    END AS parish,
    IFNULL ( auprparc.ttl_no1 || '\' , '' ) || auprparc.ttl_no5 AS simple_spi,
	
	(CASE 
	when ttl_cde=1 or ttl_cde=5 or ttl_cde=7 or ttl_cde=12 or ttl_cde=13 then
		case (IFNULL(ltrim(rtrim(ttl_no1)),'')||Ifnull(ltrim(rtrim(ttl_no2)),''))
			when '' then null
			else (Ifnull(ltrim(rtrim(ttl_no1)),'')||ifnull(ltrim(rtrim(ttl_no2)),''))||'\'
		end
	else ''
end
||
case ttl_cde
	when 1 then 'LP'
	when 13 then 'PS'
	when 7 then 'RP'
	when 5 then 'SP'
	when 12 then 'TP'
	when 2 then 'PC'
end
||
ltrim(rtrim(ttl_in5))  


		) AS "SPI",
		
    fmt_ttl AS title_description	
	
FROM
    AUTHORITY_auprparc auprparc,
    AUTHORITY_auprstad auprstad,
    AUTHORITY_ausrsubr ausrsubr,
    AUTHORITY_aualrefn aualrefn
WHERE
    ( auprparc.pcl_num = auprstad.pcl_num ) AND
    ( auprstad.sbr_nme = ausrsubr.sbr_nme ) AND
    auprparc.pcl_flg = 'R' AND
    auprparc.ass_num IS NOT NULL AND
    auprparc.udn_cd1 = aualrefn.ref_val AND
    aualrefn.ref_typ = 'udn_cd1'