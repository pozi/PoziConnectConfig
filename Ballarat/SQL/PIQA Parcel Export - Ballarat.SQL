SELECT distinct

   lpaprop.tpklpaprop AS PROPNUM,
   
CASE
		WHEN lpaparc.parcelnum is not null and lpaparc.parcelcode <> 'C/A' THEN Trim(lpaparc.parcelnum) || '\'
    
    WHEN  lpaparc.parcelcode = 'C/A' and Trim (lpasect.parcelsect) is not null THEN  Trim(lpaparc.parcelnum) ||'~'|| Trim (lpasect.parcelsect)||'\' 
    
    WHEN  lpaparc.parcelcode = 'C/A' and Trim (lpasect.parcelsect) is null THEN  Trim(lpaparc.parcelnum)||'\' 
        
    ELSE ''     
	END ||
	CASE
	
    WHEN lpaparc.plannum Is not Null THEN  CAST (Trim(lpaparc.plancode) ||Trim(lpaparc.plannum) AS varchar)
   
    WHEN lpaparc.plannum Is Null and lpaparc.parcelcode = 'C/A' THEN CAST ('PP'||cnacomp.descrsrch  AS varchar )    

    ELSE ''
	
	END AS SPI, 
   
    CAST (lpaparc.tpklpaparc AS varchar) AS CREFNO,
   lpaparc.fmtparcel AS Fmtparcel,
   lpaparc.parcelcode AS parcelcode,
   lpaparc.parcelnum AS parcelnum,
   lpacrwn.crownallot AS crownallot,
   lpasect.parcelsect AS parcelsect,   
   cnacomp.descrsrch AS ParishTwnshp,
   lpaparc.plancode AS plancode,
   lpaparc.plannum AS plannum

FROM
   PATHWAY_lpaprop AS lpaprop 
LEFT JOIN
PATHWAY_lpaadpr AS lpaadpr ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop
LEFT JOIN 
    PATHWAY_lpaaddr AS lpaaddr ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr
LEFT JOIN 
    PATHWAY_cnacomp AS cnacomp ON lpaaddr.tfkcnacomp = cnacomp.tpkcnacomp
LEFT JOIN
   PATHWAY_lpaprti_mod AS lpaprti_mod ON lpaprop.tpklpaprop = lpaprti_mod.tfklpaprop
LEFT JOIN 
   PATHWAY_lpatitl AS lpatitl ON lpaprti_mod.tfklpatitl = lpatitl.tpklpatitl
LEFT JOIN 
   PATHWAY_lpatipa AS lpatipa ON lpatitl.tpklpatitl = lpatipa.tfklpatitl 
LEFT JOIN 
   PATHWAY_lpaparc AS lpaparc ON lpatipa.tfklpaparc = lpaparc.tpklpaparc 
LEFT JOIN 
   PATHWAY_lpacrwn AS lpacrwn ON lpaparc.tpklpaparc = lpacrwn.tfklpaparc 
LEFT JOIN 
   PATHWAY_lpasect AS lpasect ON lpaparc.tpklpaparc = lpasect.tfklpaparc 
LEFT JOIN 
   PATHWAY_lpadepa AS lpadepa ON lpaparc.tpklpaparc = lpadepa.tfklpaparc 


WHERE
   lpaprop.status  = 'C' AND 
   lpaparc.status = 'C' AND
   lpatipa.status = 'C' AND
   lpaprti_mod.status = 'C' AND
   lpatitl.status = 'C'