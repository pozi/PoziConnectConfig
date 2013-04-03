Select
    P.ASSESSMENT_ID AS "propnum",
    CAST ( L.PARCEL_ID AS INTEGER) AS "crefno",
	L.[FORMER_TITLE] AS "Parcel_status",
 	P.PROPERTY_TYPE AS "Property_status",		

    IFNULL ( UPPER ( L.PART_PARCEL) , '' ) AS "part",

    CASE
        WHEN SUBSTR ( TRIM ( L.[PLAN_REF] ) , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN TRIM ( L.[PLAN_TYPE_CODE] ) || L.[PLAN_REF]
        ELSE TRIM ( L.[PLAN_TYPE_CODE]) || SUBSTR ( TRIM ( L.[PLAN_TYPE_CODE] ) , 1 , LENGTH ( TRIM ( L.[PLAN_REF] ) ) - 1 )
    END AS "plan_number",

    IFNULL ( L.[PARCEL_REF] , '' ) AS "lot_number",
	IFNULL (L.[ALLOTMENT_REF],'') AS "Allotment",
    IFNULL ( L.[SECTION_REF] , '' ) AS "section",
    IFNULL ( L.[PARCEL_REF] , '' ) ||
    CASE
        WHEN [SECTION_REF] <> '' AND SUBSTR (L.[PLAN_REF] , 2 ) NOT IN ( 'PC' , 'PS' , 'TP' ) THEN '~' || IFNULL ( CAST(L.[PARISH_CODE] AS INTEGER) , '' )
        ELSE ''
    END ||
    CASE
        WHEN L.[PARCEL_REF] <> '' THEN '\'
        ELSE ''
    END ||
    CASE
        WHEN SUBSTR ( TRIM ( L.[PLAN_REF] ) , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN TRIM ( L.[PLAN_TYPE_CODE] ) || TRIM ( L.[PLAN_REF] )
        ELSE TRIM ( L.[PLAN_TYPE_CODE] ) || SUBSTR ( TRIM ( L.[PLAN_REF]) , 1 , LENGTH ( TRIM ( L.[PLAN_REF] ) ) - 1 )
    END AS "spi"
FROM
    Fujitsu_PR_Parcel L
	JOIN FUJITSU_pr_parcel_xref A on L.PARCEL_ID = A.PARCEL_ID
	JOIN FUJITSU_PR_Assessment P on A.ASS_INTERNAL_ID = P.ASS_INTERNAL_ID 
	
	
	
	
	
	
	
WHERE
    
    TRIM(L.PLAN_TYPE_CODE IN ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP','CG' ))  AND (IFNULL(L.FORMER_TITLE,'')) <> 'Y' AND P.RATING_ZONE in ('1','4','5','9')
   