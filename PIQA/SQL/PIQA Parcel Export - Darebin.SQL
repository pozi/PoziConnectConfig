SELECT
    IFNULL ( lpaprop.tpklpaprop , '' ) AS PROPNUM,
    IFNULL ( lpaparc.fmtparcel , '' ) AS CREFNO,
    IFNULL ( lpaparc.parcelcode , '' ) AS parcelcode,
    IFNULL ( lpaparc.parcelnum , '' ) AS parcelnum,
    IFNULL ( lpaparc.plancode , '' ) AS plancode,
	CASE
		WHEN SUBSTR ( lpaparc.plannum , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN lpaparc.plannum
		ELSE SUBSTR ( TRIM ( lpaparc.plannum ) , 1 , LENGTH ( lpaparc.plannum ) - 1 )
	END AS plannum,
    IFNULL ( lpacrwn.crownallot , '' ) AS crownallot,
    IFNULL ( lpasect.parcelsect , '' ) AS parcelsect
FROM
    ((((((PATHWAY_lpaprop AS lpaprop LEFT JOIN 
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
WHERE
    lpaprop.status = 'C' AND 
    lpaparc.status = 'C' AND
    lpatipa.status = 'C' AND
    lpaprti.status = 'C' AND
    lpatitl.status = 'C'
