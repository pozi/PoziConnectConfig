SELECT
	Property AS propnum,
	'' AS crefno,
	lot AS parcel_desc
FROM
	Lynx_Propertys Property
WHERE
	Property.Type not in ( 672 , 700 ) and
	Property <> '0'