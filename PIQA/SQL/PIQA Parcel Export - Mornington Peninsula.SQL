SELECT

	CAST ( A.key1 AS varchar(20) ) AS "propnum",
	CAST ( L.land_no AS varchar(10) ) AS "crefno",

	UPPER ( part_lot ) AS "part",

	CASE
		WHEN SUBSTR ( L.plan_no , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN RTRIM ( L.plan_desc ) || L.plan_no
		ELSE RTRIM ( L.plan_desc ) || SUBSTR ( L.plan_no , LENGTH ( RTRIM ( L.plan_no ) ) - 1 )
	END AS "plan_number",

	IFNULL ( lot , '' ) AS "lot_number",

	IFNULL ( section_for_lot , '' ) AS "section",

	IFNULL ( lot , '' ) ||
	CASE
		WHEN section_for_lot <> '' AND SUBSTR ( plan_no , 2 ) NOT IN ( 'PC' , 'PS' , 'TP' ) THEN '~' || IFNULL ( section_for_lot , '' )
		ELSE ''
	END ||
	CASE
		WHEN lot <> '' THEN '\'
		ELSE ''
	END ||
	CASE
		WHEN SUBSTR ( L.plan_no , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN RTRIM ( L.plan_desc ) || L.plan_no
		ELSE RTRIM ( L.plan_desc ) || SUBSTR ( L.plan_no , LENGTH ( RTRIM ( L.plan_no ) ) - 1 )
	END AS "spi"

FROM
	Proclaim_nucLand L
	join Proclaim_nucAssociation A on L.land_no = A.key2 AND L.status IN ( 'C' , 'F' )

WHERE
	A.association_type = 'PropLand' AND
	A.date_ended IS null AND
	L.plan_desc IN ( 'TP' , 'LP' , 'PS' , 'PC' , 'CP' , 'SP' , 'CS' , 'RP' )
