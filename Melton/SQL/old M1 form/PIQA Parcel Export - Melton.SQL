SELECT
    
      CASE WHEN (auprparc.ass_num in ('310227','199380','310227','594440','594457','594465','594473','594481','594499','594507','594515','594523','594531'))  THEN 'NCPR'   
  	ELSE auprparc.ass_num  END AS propnum_Int,
	
	CAST ((CASE WHEN (auprparc.ass_num in ('310227','199380','310227','594440','594457','594465','594473','594481','594499','594507','594515','594523','594531'))  THEN 'NCPR'   
  	ELSE auprparc.ass_num END) AS VARCHAR) AS propnum,
	
	CAST (auprparc.pcl_num AS VARCHAR) AS crefno,
	auprparc.pcl_flg AS prpa_status,
	
		(CASE WHEN auprparc.ttl_cde IN(3,4,6,8,16,18)  THEN 
	  	      CASE WHEN ltrim(rtrim(auprparc.ttl_no1))is null THEN '' 
		    ELSE ltrim(rtrim(auprparc.ttl_no1)) 
		 END
	        WHEN auprparc.ttl_cde IN(1,5,51)THEN 
		     CASE WHEN ltrim(rtrim(auprparc.ttl_no1)) is null THEN
     		    CASE WHEN ltrim(rtrim(auprparc.ttl_no2)) is null then ''
		    ELSE ltrim(rtrim(auprparc.ttl_no2))
		  END
		    ELSE ltrim(rtrim(auprparc.ttl_no1))
		  END 						
      ELSE '' END) AS LOT_NUMBER,	
	  
	 case auprparc.ttl_cde
	when 1 then 'PS'
	when 5 then 'LP'
	when 51 then 'PS'
	when 3 then 'RP'
	when 4 then 'SP'
	when 18 then 'TP'
	when 2 then 'PC'
	when 8 then 'CP'
	when 52 then 'PC'
end
||
ltrim(rtrim(ttl_in5)) AS PLAN_NUMBER,
	  
		
		(CASE WHEN auprparc.ttl_cde IN(9,10,11,12)THEN 
	  	CASE WHEN ltrim(rtrim(auprparc.ttl_no1))is null THEN ''
	 	     WHEN ltrim(rtrim(auprparc.ttl_no1))='9999' THEN ''	 
		ELSE
		     ltrim(rtrim(auprparc.ttl_no1))
		END	 
     ELSE '' END)	AS ALLOTMENT,
		
		
		(CASE WHEN auprparc.ttl_cde IN(9,10,11)THEN 
	  	CASE WHEN ltrim(rtrim(auprparc.ttl_no4))is null THEN ''
	 	     WHEN ltrim(rtrim(auprparc.ttl_no4))='NONE' THEN ''	 			
		ELSE
		     ltrim(rtrim(auprparc.ttl_no4))
		END	 
		ELSE '' END) AS SECTION_P,
		   
		   (CASE WHEN auprparc.ttl_cde IN(1,5,51,99) THEN
				CASE WHEN ltrim(rtrim(auprparc.ttl_no1)) is null then 
	  	    	CASE WHEN ltrim(rtrim(auprparc.ttl_no2)) is null then '' 
				ELSE 'P'	END
			ELSE '' END	
 	             WHEN auprparc.ttl_cde IN(11,12) THEN 'P' ELSE '' END) AS PART,
		
		
		
		(CASE WHEN (auprparc.ttl_cde = 16) THEN
     	ltrim(rtrim(auprparc.ttl_in5))
     ELSE '' END)as Subdivision,
     (CASE WHEN (auprparc.udn_cd5 = 1 )  THEN 2311  
	WHEN (auprparc.udn_cd5 = 2 )  THEN 2516  
	WHEN (auprparc.udn_cd5 = 3 )  THEN 2528  
	WHEN (auprparc.udn_cd5 = 4 )  THEN 2761  
	WHEN (auprparc.udn_cd5 = 5 )  THEN 2927  
	WHEN (auprparc.udn_cd5 = 6 )  THEN 3061  
	WHEN (auprparc.udn_cd5 = 7 )  THEN 3164  
	WHEN (auprparc.udn_cd5 = 8 )  THEN 3431  
	WHEN (auprparc.udn_cd5 = 9 )  THEN 3948  
	WHEN (auprparc.udn_cd5 = 10 )  THEN 3797  
	WHEN (auprparc.udn_cd5 = 12 )  THEN 2265  
	WHEN (auprparc.udn_cd5 = 13 )  THEN 2404  
	WHEN (auprparc.udn_cd5 = 14 )  THEN 3095  
	WHEN (auprparc.udn_cd5 = 15 )  THEN 3201  
	WHEN (auprparc.udn_cd5 = 16 )  THEN 3375  
	WHEN (auprparc.udn_cd5 = 17 )  THEN 3552  
	WHEN (auprparc.udn_cd5 = 18 )  THEN 3651  
      ELSE NULL  END) AS PARISH_CODE,
		
		
		(CASE WHEN (auprparc.udn_cd5 = 1 )  THEN 5781 
	WHEN (auprparc.udn_cd5 = 3 )  THEN 5515  
	WHEN (auprparc.udn_cd5 = 9 )  THEN 5791  
	ELSE NULL  END) AS TOWNSHIP_CODE,
		
  (CASE 
	when ttl_cde=1 or ttl_cde=3 or ttl_cde=4 or ttl_cde=5 or ttl_cde=18 or ttl_cde=51 then 
		case (IFNULL(ltrim(rtrim(ttl_no1)),'')||Ifnull(ltrim(rtrim(ttl_no2)),''))
			when '' then null
			else (Ifnull(ltrim(rtrim(ttl_no1)),'')||ifnull(ltrim(rtrim(ttl_no2)),''))||'\'
		end
	else ''
end
||
case ttl_cde
	when 1 then 'PS'
	when 5 then 'LP'
	when 51 then 'PS'
	when 3 then 'RP'
	when 4 then 'SP'
	when 18 then 'TP'
	when 2 then 'PC'
	when 8 then 'CP'
	when 52 then 'PC'
end
||
ltrim(rtrim(ttl_in5))  


		) AS "SPI",
		
	pcl_flg	AS Parcel_status,
		
    fmt_ttl AS title_description

FROM
    AUTHORITY_auprparc AS auprparc

WHERE
    auprparc.pcl_flg IN ('R','P') AND
    auprparc.ass_num NOT IN ( '' , '0' )

ORDER BY
    ass_num
	
	
	
	
	


	
	