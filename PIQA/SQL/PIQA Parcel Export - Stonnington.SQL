SELECT
	CAST ( A.key1 AS varchar(20) ) AS "propnum",
	CAST ( L.land_no AS varchar(10) ) AS "crefno",
	IFNULL ( UPPER ( part_lot ) , '' ) AS "part",
	CASE
		WHEN SUBSTR ( TRIM ( L.plan_no ) , -1 ) IN ( '1','2','3','4','5','6','7','8','9','0' ) THEN TRIM ( L.plan_desc ) || L.plan_no
		ELSE TRIM ( L.plan_desc ) || SUBSTR ( TRIM ( L.plan_no ) , 1 , LENGTH ( TRIM ( L.plan_no ) ) - 1 )
	END AS "plan_number",
	TRIM ( IFNULL ( lot , '' ) ) AS "lot_number",
	IFNULL ( section_for_lot , '' ) AS "section",
	TRIM ( IFNULL ( lot , '' ) ) ||
	CASE
		WHEN section_for_lot <> '' AND SUBSTR ( plan_no , 2 ) NOT IN ( 'PC' , 'PS' , 'TP' ) THEN '~' || IFNULL ( section_for_lot , '' )
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
FROM
	Proclaim_nucLand L
	join Proclaim_nucAssociation A on L.land_no = A.key2 AND L.status IN ( 'C' , 'F' , 'c' , 'f' )
WHERE
	A.association_type = 'PropLand' AND
	( A.date_ended = '' OR A.date_ended IS NULL )