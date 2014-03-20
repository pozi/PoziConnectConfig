CREATE VIEW pthdbo.CommonGround_Address AS

SELECT

   CAST (lpaprop.tpklpaprop AS varchar(20)) AS PROPNUM,

--   CASE
--      WHEN lpapnam.propname is null THEN ''
--      ELSE UPPER ( CAST (lpapnam.propname AS varchar(50)) )
--   END AS PR_NAME,

   CASE
      WHEN rtrim(lpaaddr.prefix) = 'ATM' THEN 'ATM'
      WHEN rtrim(lpaaddr.prefix) = 'CAR PARK' THEN 'CP'
      WHEN rtrim(lpaaddr.prefix) = 'FACTORY' THEN 'FY'
      WHEN rtrim(lpaaddr.prefix) = 'KIOSK' THEN 'KSK'
      WHEN rtrim(lpaaddr.prefix) = 'OFFICE' THEN 'OFF'
      WHEN rtrim(lpaaddr.prefix) = 'SHOP' THEN 'SHOP'
      WHEN rtrim(lpaaddr.prefix) = 'SUITE' THEN 'SE'
      WHEN rtrim(lpaaddr.prefix) = 'UNIT' THEN 'U'
      WHEN rtrim(lpaaddr.prefix) = 'L' THEN 'LOT'
      WHEN rtrim(lpaaddr.prefix) = 'ROOM' THEN 'ROOM'
      ELSE ''
   END AS SU_TYPE,   
 
   CASE
      WHEN rtrim(lpaaddr.prefix) = 'REAR' THEN 'REAR'
      WHEN rtrim(lpaaddr.prefix) = 'REAR OF' THEN 'REAR'
      WHEN rtrim(lpaaddr.lvlprefix) = 'UPSTAIRS' THEN 'UPSTAIRS'
      ELSE ''
   END AS LOC_DES,

   CASE
      WHEN lpaaddr.strunitnum = '0' or lpaaddr.strunitnum is null THEN ''
      ELSE CAST (lpaaddr.strunitnum AS varchar(5))
   END AS SU_NO_1,

   CASE
      WHEN lpaaddr.strunitsfx = '0' or lpaaddr.strunitsfx is null THEN ''
      ELSE CAST (lpaaddr.strunitsfx AS varchar(2))
   END AS SU_SUFF_1,

   CASE
      WHEN lpaaddr.endunitnum = '0' or lpaaddr.endunitnum is null THEN ''
      ELSE CAST (lpaaddr.endunitnum AS varchar(5))
   END AS SU_NO_2,

   CASE
      WHEN lpaaddr.endunitsfx = '0' or lpaaddr.endunitsfx is null THEN ''
      ELSE CAST (lpaaddr.endunitsfx AS varchar(2))
   END AS SU_SUFF_2,

   CASE
      WHEN lpaaddr.strhousnum = '0' or lpaaddr.strhousnum is null THEN ''
      ELSE CAST (lpaaddr.strhousnum AS varchar(6))
   END AS HOUSE_NUMBER_1,

   CASE
      WHEN lpaaddr.strhoussfx = '0' or lpaaddr.strhoussfx is null THEN ''
      ELSE CAST (lpaaddr.strhoussfx AS varchar(2))
   END AS HOUSE_SUFFIX_1,

   CASE
      WHEN lpaaddr.endhousnum = '0' or lpaaddr.endhousnum is null THEN ''
      ELSE CAST (lpaaddr.endhousnum AS varchar(6))
   END AS HOUSE_NUMBER_2,

   CASE
      WHEN lpaaddr.endhoussfx = '0' or lpaaddr.endhoussfx is null THEN ''
      ELSE CAST (lpaaddr.endhoussfx AS varchar(2))
   END AS HOUSE_SUFFIX_2,

   CASE
      WHEN lpaaddr.lvlprefix = 'LEVEL' THEN 'L'
      WHEN lpaaddr.lvlprefix = 'FLOOR' THEN 'FL'
      ELSE ''
   END AS FL_TYPE,

   CASE
      WHEN lpaaddr.strlvlnum = '0' THEN ''
      ELSE CAST (lpaaddr.strlvlnum AS varchar(5))
   END AS FL_NO_1,

  CASE
      WHEN lpaaddr.endlvlnum = '0' THEN ''
      ELSE CAST (lpaaddr.endlvlnum AS varchar(5))
   END AS FL_NO_2,

   CAST (UPPER(cnacomp.descr) AS varchar(45)) AS STREET_NAME, 

   CASE
      WHEN cnaqual.descr like '% NORTH' or
         cnaqual.descr like '% SOUTH' or
         cnaqual.descr like '% EAST' or
         cnaqual.descr like '% WEST' THEN UPPER ( LEFT ( cnaqual.descr , PATINDEX (  '% %' , cnaqual.descr ) - 1 ) )
      ELSE UPPER ( cnaqual.descr )
   END AS STREET_TYPE,

   CASE
      WHEN cnaqual.descr like '% NORTH' THEN 'N'
      WHEN cnaqual.descr like '% SOUTH' THEN 'S'
      WHEN cnaqual.descr like '% EAST' THEN 'E'
      WHEN cnaqual.descr like '% WEST' THEN 'W'
      ELSE ''
   END as STREET_SUFFIX, 

   CAST (UPPER(lpasubr.suburbname) AS varchar(46)) AS LOCALITY, 
   CAST (lpaprtp.abbrev AS varchar(15)) AS Property_Type, 
   CAST (lpaprop.tfklpaprop AS varchar(20)) AS Parent_Propnum,
   lpaprop.tpklpaprop AS MI_PRINX

FROM
   ((((((((pthprod.pthdbo.lpaprop AS lpaprop LEFT JOIN 
   pthprod.pthdbo.lpaadpr AS lpaadpr ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop)
LEFT JOIN 
   pthprod.pthdbo.lpaaddr AS lpaaddr ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr)
LEFT JOIN 
   pthprod.pthdbo.lpastrt AS lpastrt ON lpaaddr.tfklpastrt = lpastrt.tpklpastrt) 
LEFT JOIN 
   pthprod.pthdbo.cnacomp AS cnacomp ON lpastrt.tfkcnacomp = cnacomp.tpkcnacomp) 
LEFT JOIN 
   pthprod.pthdbo.cnaqual AS cnaqual ON cnacomp.tfkcnaqual = cnaqual.tpkcnaqual) 
LEFT JOIN 
   pthprod.pthdbo.lpaprtp AS lpaprtp ON lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp) 
LEFT JOIN 
   pthprod.pthdbo.lpasubr AS lpasubr ON lpaaddr.tfklpasubr = lpasubr.tpklpasubr)
LEFT JOIN
   pthprod.pthdbo.lpapnam AS lpapnam ON lpaprop.tpklpaprop = lpapnam.tfklpaprop) 

WHERE
   lpaprop.status <> 'H' AND 
   lpaprop.tfklpacncl = 12 AND
   lpaaddr.addrtype = 'P' AND
   lpaprtp.abbrev <> 'OTH'
