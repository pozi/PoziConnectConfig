SELECT 
    *
FROM
    SynergySoft_Parcel_Extract
WHERE 
    code NOT IN ( 'X' ) AND
    type NOT IN ( 'Z' )

