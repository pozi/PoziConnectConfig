
SELECT

   lpaprop.tpklpaprop AS PROPNUM,
   lpaparc.parcelcode AS parcelcode,
   lpaparc.parcelnum AS parcelnum,
   lpacrwn.crownallot AS crownallot,
   lpasect.parcelsect AS parcelsect,
   lpaparc.plancode AS plancode,
   lpaparc.plannum AS plannum,
   lpadesc.tpklpadesc AS tpklpadesc

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
   lpaprop.status  = 'C' AND 
   lpaparc.status = 'C' AND
   lpatipa.status = 'C' AND
   lpaprti.status = 'C' AND
   lpatitl.status = 'C'