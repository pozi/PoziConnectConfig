SELECT

CAST ((CASE WHEN (A.key1 in ('14359', '15127', '14360','15893','15303'))  THEN 'NCPR'   
  	ELSE A.key1 END) AS VARCHAR) AS propnum,  

L.[TEXT2] AS Rural_addr,

    CAST ( L.land_no AS varchar(10) ) AS "crefno",
	L.Status AS "Parcel_status",			

    IFNULL ( UPPER ( part_lot ) , '' ) AS "part",

    CASE
        WHEN SUBSTR ( TRIM ( L.plan_no ) , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN TRIM ( L.plan_desc ) || L.plan_no
        ELSE TRIM ( L.plan_desc ) || SUBSTR ( TRIM ( L.plan_no ) , 1 , LENGTH ( TRIM ( L.plan_no ) ) - 1 )
    END AS "plan_number",

    IFNULL ( lot , '' ) AS "lot_number",
	
	IFNULL (L.TEXT3,'') AS "Allotment",

    IFNULL ( Parish_Section , '' ) AS "section",

    IFNULL ( lot , '' ) ||
    CASE
        WHEN Parish_Section <> '' AND SUBSTR ( plan_no , 2 ) NOT IN ( 'PC' , 'PS' , 'TP' ) THEN '~' || IFNULL ( Parish_Section , '' )
        ELSE ''
    END ||
    CASE
        WHEN lot <> '' THEN '\'
        ELSE ''
    END ||
    CASE
        WHEN SUBSTR ( TRIM ( L.plan_no ) , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN TRIM ( L.plan_desc ) || TRIM ( L.plan_no )
        ELSE TRIM ( L.plan_desc ) || SUBSTR ( TRIM ( L.plan_no ) , 1 , LENGTH ( TRIM ( L.plan_no ) ) - 1 )
    END AS "spi"

	
FROM PROCLAIM_nucLand L
   join PROCLAIM_nucAssociation A on L.land_no = A.key2 AND L.status IN ( 'C' , 'F')
   join PROCLAIM_nucProperty P on A.Key1 = P.Property_no
   left join PROCLAIM_nucAssociation T on A.Key1 = T.Key1 and A.key2 = t.key2 AND
    T.association_type = 'TransPRLD' AND    A.date_ended IS null

WHERE
    A.association_type = 'PropLand' AND
    A.date_ended IS null AND
    L.plan_desc IN ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' ,'RP','CG' )
and t.key1 is null
	
	
	
	

	
	
	
	
	