SELECT
    *,    
    parcelnum ||
    CASE WHEN parcelnum <> '' THEN '\' ELSE '' END ||
    plancode || plannum AS SPI    
FROM (

SELECT

   (SELECT assmnumber
        FROM temp_PATHWAY_assmnumber_LUT
        WHERE lpaprop.tpklpaprop = tfklocl) AS PROPNUM,
   IFNULL ( lpaparc.parcelcode , '' ) AS parcelcode,
   IFNULL ( lpaparc.parcelnum , '' ) AS parcelnum,
   IFNULL ( lpaparc.plancode , '' ) AS plancode,
   IFNULL ( lpaparc.plannum , '' ) AS plannum,
   IFNULL ( lpacrwn.crownallot , '' ) AS crownallot,
   IFNULL ( lpadesc.descr , '' ) AS descr,
   IFNULL ( lpadesc.tpklpadesc , '' ) AS tpklpadesc

FROM
   (((((((PATHWAY_lpaprop AS lpaprop LEFT JOIN 
   PATHWAY_lpaprti AS lpaprti ON lpaprop.tpklpaprop = lpaprti.tfklpaprop)
LEFT JOIN 
   PATHWAY_lpatitl AS lpatitl ON lpaprti.tfklpatitl = lpatitl.tpklpatitl)
LEFT JOIN 
   PATHWAY_lpatipa AS lpatipa ON lpatitl.tpklpatitl = lpatipa.tfklpatitl) 
LEFT JOIN 
   PATHWAY_lpaparc AS lpaparc ON lpatipa.tfklpaparc = lpaparc.tpklpaparc) 
LEFT JOIN 
   PATHWAY_lpacrwn AS lpacrwn ON lpaparc.tpklpaparc = lpacrwn.tfklpaparc) 
LEFT JOIN 
   PATHWAY_lpadepa AS lpadepa ON lpaparc.tpklpaparc = lpadepa.tfklpaparc) 
LEFT JOIN
   PATHWAY_lpadesc AS lpadesc ON lpadepa.tfklpadesc = lpadesc.tpklpadesc) 

WHERE
   lpaprop.status = 'C' AND 
   lpaparc.status = 'C' AND
   lpatipa.status = 'C' AND
   lpaprti.status = 'C' AND
   lpatitl.status = 'C'   

)