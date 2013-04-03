

SELECT *,

LTRIM ( 
       IFNULL(su_no_1,'') || IFNULL(su_suff_1,'') ||
      CASE WHEN IFNULL(su_no_1,'') <> '' AND IFNULL(su_no_2,'') <> '' THEN '-' ELSE '' END ||
        IFNULL(su_no_2,'') || IFNULL(su_suff_2,'') ||
         CASE WHEN IFNULL(su_no_1,'') || su_no_1 <> ''  THEN '/' ELSE '' END ||
         IFNULL(house_number_1,'') || IFNULL(house_suffix_1,'') ||
        CASE WHEN IFNULL(house_number_2,'') <> '' THEN '-' ELSE '' END ||
        IFNULL(house_number_2,'') || IFNULL(house_suffix_2,'') ||
        RTRIM ( ' ' || IFNULL(street_name,'')) ||
        RTRIM ( ' ' || IFNULL(street_type,'' )) ||
        RTRIM (' ' || IFNULL(street_suffix,''))||
        RTRIM ( ' ' || IFNULL(locality,'')) ||
		RTRIM ( ' ' || IFNULL(Postcode,''))	) AS "address_pr"
	
  FROM ( SELECT
  
  
  
pthdbo_lraassm.assmnumber  AS PROPNUM,
CAST(pthdbo_lraassm.assmnumber as Integer)  AS PROPNUM_INT,
	
	CASE
		WHEN pthdbo_lpaaddr.prefix is not null THEN UPPER ( ltrim(rtrim(pthdbo_lpaaddr.prefix)) || ' ' || ltrim(rtrim(pthdbo_lpaaddr.lvlprefix)) )
	END AS LOC_DES,
	
	CASE

		WHEN pthdbo_lpaaddr.unitprefix = 'Apartment' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'APT'
		WHEN pthdbo_lpaaddr.unitprefix = 'Flat' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'F'
		WHEN pthdbo_lpaaddr.unitprefix = 'Suite' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'SE'
		WHEN pthdbo_lpaaddr.unitprefix = 'Unit' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'U'

		WHEN pthdbo_lpaaddr.lvlprefix = 'Hall' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'HALL'
		WHEN pthdbo_lpaaddr.lvlprefix = 'House' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'HSE'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Office' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'OFF'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Reserve' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'RESV'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shed' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'SHED'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shop' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'SHOP'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Suite' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'SE'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Tower' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'TWR'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Tower' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN 'ATM'

	END AS SU_TYPE,

	
	CASE
		WHEN pthdbo_lpaaddr.lvlprefix = 'Hall' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'House' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Office' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Reserve' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shed' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shop' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Suite' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Tower' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.lvlprefix = 'ATM' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS integer)
		WHEN pthdbo_lpaaddr.unitprefix not in ( 'Floor', 'Level' ) AND pthdbo_lpaaddr.strunitnum <> 0 then CAST (pthdbo_lpaaddr.strunitnum AS Integer)
		WHEN pthdbo_lpaaddr.strunitnum = 0 THEN null
	END AS SU_NO_1,

	CASE
		WHEN pthdbo_lpaaddr.lvlprefix = 'Hall' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'House' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Office' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Reserve' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shed' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Shop' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Suite' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Tower' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'ATM' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.unitprefix not in ( 'Floor' , 'Level' ) AND pthdbo_lpaaddr.strunitsfx is not null then CAST (pthdbo_lpaaddr.strunitsfx AS varchar)
	END AS SU_SUFF_1,

	CASE
		WHEN pthdbo_lpaaddr.endunitnum = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.endunitnum AS Integer)
	END AS SU_NO_2,

	CASE
		WHEN pthdbo_lpaaddr.endunitsfx = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.endunitsfx AS varchar)
	END AS SU_SUFF_2,

	CASE
		WHEN pthdbo_lpaaddr.unitprefix = 'Floor' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'FL'
		WHEN pthdbo_lpaaddr.unitprefix = 'Level' AND (pthdbo_lpaaddr.strunitnum <> 0 or pthdbo_lpaaddr.strunitsfx is not null) THEN 'L'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Floor' AND (pthdbo_lpaaddr.strlvlnum <> 0 or pthdbo_lpaaddr.strlvlsfx is not null) THEN 'FL'
		WHEN pthdbo_lpaaddr.lvlprefix = 'Level' AND (pthdbo_lpaaddr.strlvlnum <> 0 or pthdbo_lpaaddr.strlvlsfx is not null) THEN 'L'
	END AS FL_TYPE,

	CASE
		WHEN pthdbo_lpaaddr.lvlprefix = 'Floor' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Level' AND pthdbo_lpaaddr.strlvlnum <> 0 THEN CAST (pthdbo_lpaaddr.strlvlnum AS varchar)
		WHEN pthdbo_lpaaddr.unitprefix = 'Floor' AND pthdbo_lpaaddr.strunitnum <> 0 THEN CAST (pthdbo_lpaaddr.strunitnum AS varchar)
		WHEN pthdbo_lpaaddr.unitprefix = 'Level' AND pthdbo_lpaaddr.strunitnum <> 0 THEN CAST (pthdbo_lpaaddr.strunitnum AS varchar)
		ELSE ''
	END AS FL_NO_1,

	CASE
		WHEN pthdbo_lpaaddr.lvlprefix = 'Floor' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.lvlprefix = 'Level' AND pthdbo_lpaaddr.strlvlsfx is not null THEN CAST (pthdbo_lpaaddr.strlvlsfx AS varchar)
		WHEN pthdbo_lpaaddr.unitprefix = 'Floor' AND pthdbo_lpaaddr.strunitsfx is not null THEN CAST (pthdbo_lpaaddr.strunitsfx AS varchar)
		WHEN pthdbo_lpaaddr.unitprefix = 'Level' AND pthdbo_lpaaddr.strunitsfx is not null THEN CAST (pthdbo_lpaaddr.strunitsfx AS varchar)
		ELSE ''
	END AS FL_SUFF_1,

	CASE
		WHEN pthdbo_lpaaddr.strhousnum = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.strhousnum AS Integer)
		END AS HOUSE_NUMBER_1,

	CASE
		WHEN pthdbo_lpaaddr.strhoussfx = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.strhoussfx AS varchar)
	END AS HOUSE_SUFFIX_1,

	CASE
		WHEN pthdbo_lpaaddr.endhousnum = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.endhousnum AS Integer)
	END AS HOUSE_NUMBER_2,

	CASE
		WHEN pthdbo_lpaaddr.endhoussfx = '0'
		THEN null
		ELSE CAST (pthdbo_lpaaddr.endhoussfx AS varchar)
	END AS HOUSE_SUFFIX_2,

	UPPER ( CAST (pthdbo_cnacomp.descr AS varchar) ) AS STREET_NAME,
	UPPER ( CAST (pthdbo_cnaqual.descr AS varchar) ) AS STREET_TYPE,
	CAST (null AS varchar(2)) as STREET_SUFFIX, 
	CAST (pthdbo_lpasubr.suburbname AS varchar) AS LOCALITY, 
	CAST (pthdbo_cnacomp_1.descr AS varchar) AS POSTCODE

   
	
FROM
	PATHWAY_lpaprop as pthdbo_lpaprop LEFT JOIN
	PATHWAY_lpaadpr as pthdbo_lpaadpr ON pthdbo_lpaprop.tpklpaprop = pthdbo_lpaadpr.tfklpaprop LEFT JOIN 
	PATHWAY_lpaaddr as pthdbo_lpaaddr ON pthdbo_lpaadpr.tfklpaaddr = pthdbo_lpaaddr.tpklpaaddr LEFT JOIN 
	PATHWAY_lpastrt as pthdbo_lpastrt ON pthdbo_lpaaddr.tfklpastrt = pthdbo_lpastrt.tpklpastrt LEFT JOIN 
	PATHWAY_cnacomp as pthdbo_cnacomp ON pthdbo_lpastrt.tfkcnacomp = pthdbo_cnacomp.tpkcnacomp LEFT JOIN 
	PATHWAY_cnacomp as pthdbo_cnacomp_1 ON pthdbo_lpaaddr.tfkcnacomp = pthdbo_cnacomp_1.tpkcnacomp LEFT JOIN 
	PATHWAY_cnaqual as pthdbo_cnaqual ON pthdbo_cnacomp.tfkcnaqual = pthdbo_cnaqual.tpkcnaqual LEFT JOIN 
	PATHWAY_lpaprtp as pthdbo_lpaprtp ON pthdbo_lpaprop.tfklpaprtp = pthdbo_lpaprtp.tpklpaprtp LEFT JOIN 
	PATHWAY_lpasubr as pthdbo_lpasubr ON pthdbo_lpaaddr.tfklpasubr = pthdbo_lpasubr.tpklpasubr LEFT JOIN
   PATHWAY_lparole_filtered as pthdbo_lparole_filt ON pthdbo_lpaprop.tpklpaprop = pthdbo_lparole_filt.tfklocl LEFT OUTER JOIN
   PATHWAY_lraassm as pthdbo_lraassm ON pthdbo_lparole_filt.tfkappl = pthdbo_lraassm.tpklraassm 
											
   WHERE
	(pthdbo_lpaprop.status = 'C' or pthdbo_lpaprop.status ='A' ) AND 
	   pthdbo_lraassm.applicatn = 'R' and
	pthdbo_lpaaddr.addrtype='P' and 
	pthdbo_lpaprop.tfklpacncl=13      )


