SELECT
    *,    
    parcelnum ||
    CASE WHEN parcelnum <> '' AND parcelsect <> '' THEN '~' || parcelsect ELSE '' END ||
    CASE WHEN parcelnum <> '' THEN '\' ELSE '' END ||
    plancode || plannum AS SPI    
FROM (

SELECT

    IFNULL ( lpaprop.tpklpaprop , '' ) AS PROPNUM,
    IFNULL ( lpaparc.tpklpaparc , '' ) AS CREFNO,
    IFNULL ( lpaparc.parcelcode , '' ) AS parcelcode,
    IFNULL ( lpaparc.parcelnum , '' ) AS parcelnum,
    IFNULL ( lpaparc.plancode , '' ) AS plancode,
    REPLACE ( LTRIM ( REPLACE (
    	CASE
    		WHEN SUBSTR ( lpaparc.plannum , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN lpaparc.plannum
    		ELSE SUBSTR ( TRIM ( lpaparc.plannum ) , 1 , LENGTH ( lpaparc.plannum ) - 1 )
    	END, '0', ' ')), ' ', '0') as plannum,
    IFNULL ( lpacrwn.crownallot , '' ) AS crownallot,
    IFNULL ( lpasect.parcelsect , '' ) AS parcelsect,
    IFNULL ( lpadesc.descr , '' ) AS descr,
    IFNULL ( lpadesc.tpklpadesc , '' ) AS tpklpadesc

FROM
    ((((((((PATHWAY_lpaprop AS lpaprop LEFT JOIN 
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
    PATHWAY_lpasect AS lpasect ON lpaparc.tpklpaparc = lpasect.tfklpaparc) 
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