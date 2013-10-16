SELECT
    Property AS "propnum",
    CombinedParcelDetails AS "CombinedParcelDetails"
FROM
    Lynx_Propertys Property
WHERE
    Property.Type not in ( 672 , 700 ) and
    Property <> '0'