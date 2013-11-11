SELECT DISTINCT

   CAST(CAST(pthdbo_lraassm.assmnumber AS integer) AS Varchar) AS PROPNUM,
   CAST (pthdbo_lpaparc.tpklpaparc AS varchar) AS CREFNO,

   CASE
      WHEN pthdbo_lpaparc.plancode IS NOT NULL
      THEN CAST (pthdbo_lpaparc.parcelnum AS varchar)
      ELSE CAST (NULL AS varchar)
   END AS LOT_NUMBER,



   CASE
      WHEN pthdbo_lpaparc.plannum Is Null
      THEN CAST (Null AS varchar)
      ELSE        
         CAST (Trim(pthdbo_lpaparc.plancode)||
         CASE
            WHEN Substr(Trim(pthdbo_lpaparc.plannum),-1) > '9' AND Substr(Trim(pthdbo_lpaparc.plannum),1) <> '0' THEN Substr(pthdbo_lpaparc.plannum,1,(LENGTH (Trim(plannum))-1))
           
           WHEN Substr(Trim(pthdbo_lpaparc.plannum),2) = '00'  THEN Substr(pthdbo_lpaparc.plannum,3,99)
            WHEN Substr(Trim(pthdbo_lpaparc.plannum),1) = '0'  THEN Substr(pthdbo_lpaparc.plannum,2,99)
            ELSE Trim(pthdbo_lpaparc.plannum)
         END
         AS varchar)
   END AS PLAN_NUMBER, 

   CASE
      WHEN pthdbo_lpasect.parcelsect IS NOT NULL
      THEN CAST (pthdbo_lpaparc.parcelnum AS varchar)
      ELSE CAST (NULL AS varchar)
   END AS ALLOTMENT,

   CAST (pthdbo_lpasect.parcelsect AS varchar) AS [SECTION], 

   CASE
      WHEN pthdbo_lpaparc.parcelcode Is Null
      THEN CAST ('N' AS varchar)
      ELSE
          CASE
            WHEN Substr(RTrim(pthdbo_lpaparc.parcelcode),2)='PT'
            THEN CAST ('P' AS varchar)
            ELSE CAST ('N' AS varchar)
          END
   END AS PART,

   CAST (NULL as varchar) AS PARISH_CODE, 
   CAST (NULL as varchar) AS TOWNSHIP_CODE,   



	CASE
		WHEN pthdbo_lpaparc.parcelnum is not null THEN RTrim(pthdbo_lpaparc.parcelnum) || '\'
	END ||
	CASE
		WHEN pthdbo_lpaparc.plannum Is Null THEN pthdbo_lpaparc.plancode=''
		ELSE CAST (RTrim(pthdbo_lpaparc.plancode) ||
			CASE
            WHEN Substr(Trim(pthdbo_lpaparc.plannum),-1) > '9' AND Substr(Trim(pthdbo_lpaparc.plannum),1) <> '0' THEN Substr(pthdbo_lpaparc.plannum,1,(LENGTH (Trim(plannum))-1))
           WHEN Substr(Trim(pthdbo_lpaparc.plannum),2) = '00' THEN Substr(pthdbo_lpaparc.plannum,3,99)
            WHEN Substr(Trim(pthdbo_lpaparc.plannum),1) = '0' THEN Substr(pthdbo_lpaparc.plannum,2,99)
            ELSE Trim(pthdbo_lpaparc.plannum)
			END
			AS varchar)
   END AS SPI,
   
   pthdbo_lpaparc.status AS PARCEL_STATUS
   


FROM
   PATHWAY_lpaprop AS pthdbo_lpaprop LEFT OUTER JOIN
   PATHWAY_lpaprti AS pthdbo_lpaprti  ON pthdbo_lpaprop.tpklpaprop = pthdbo_lpaprti.tfklpaprop LEFT OUTER JOIN
   PATHWAY_lpatipa AS pthdbo_lpatipa  ON pthdbo_lpaprti.tfklpatitl = pthdbo_lpatipa.tfklpatitl LEFT OUTER JOIN
   PATHWAY_lpaparc AS pthdbo_lpaparc  ON pthdbo_lpatipa.tfklpaparc = pthdbo_lpaparc.tpklpaparc LEFT OUTER JOIN
   PATHWAY_lpasect AS pthdbo_lpasect ON pthdbo_lpaparc.tpklpaparc = pthdbo_lpasect.tfklpaparc LEFT OUTER JOIN
   PATHWAY_lparole_filtered AS pthdbo_lparole_filt ON pthdbo_lpaprop.tpklpaprop = pthdbo_lparole_filt.tfklocl LEFT OUTER JOIN
   PATHWAY_lraassm AS pthdbo_lraassm ON pthdbo_lparole_filt.tfkappl = pthdbo_lraassm.tpklraassm  

WHERE
   pthdbo_lpaparc.status <> 'H' AND   
   pthdbo_lraassm.applicatn = 'R' AND
   pthdbo_lpaprop.tfklpacncl = 13