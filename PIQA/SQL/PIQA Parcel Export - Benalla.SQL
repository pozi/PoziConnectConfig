SELECT 
    "ASSESS", "DOLA_pin", "Type", "PT_LOT/CA", "LOT/CA_NO", "PLAN_NUMBER", "SECTION", "PARISH"
FROM
    SynergySoft
WHERE 
    CURR_ASSESS NOT IN ( 'X' ) AND
    Type NOT IN ( 'Z' )

