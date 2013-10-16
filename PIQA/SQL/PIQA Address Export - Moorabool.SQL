SELECT
    *,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) AS roadnt_pr,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) || ' ' ||
        locality AS stjoin_pr,
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ) AS address_pr,
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ||
        RTRIM ( ' ' || propnum ) ) AS address_propnum_pr

FROM (

SELECT

    Property.Property AS propnum,
    CASE    
        WHEN UPPER ( Property.UnitNo ) like 'SHOP %' THEN 'SHOP'
        ELSE ''
    END AS su_type,
    '' AS su_prefix_1,
    CASE    
        WHEN UPPER ( Property.UnitNo ) like 'SHOP %' THEN SUBSTR ( Property.UnitNo , 6 , 10 )
        ELSE IFNULL ( Property.UnitNo , '' )
    END AS su_no_1,
    '' AS su_suff_1,
    '' AS su_prefix_2,
    '' AS su_no_2,
    '' AS su_suff_2,
    '' AS fl_type,
    '' AS fl_prefix_1,
    IFNULL ( Property.FloorNo , '' ) AS fl_no_1,
    '' AS fl_suff_1,
    '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    '' AS pr_name_1,
    '' AS pr_name_2,
    '' AS loc_des,
    '' AS house_prefix_1,

    CASE
        WHEN SUBSTR ( Property.StreetNoFrom , 1, 1 ) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        WHEN SUBSTR ( Property.StreetNoFrom , -1 , 1 ) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN Property.StreetNoFrom
        ELSE IFNULL ( SUBSTR ( Property.StreetNoFrom , 1 , LENGTH ( Property.StreetNoFrom ) - 1) , '' ) 
    END AS house_number_1,

    CASE
        WHEN SUBSTR ( Property.StreetNoFrom , 1, 1 ) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        WHEN SUBSTR ( Property.StreetNoFrom , -1 , 1 ) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        ELSE IFNULL ( UPPER ( SUBSTR ( Property.StreetNoFrom , -1 , 1 ) ) , '' )
    END AS house_suffix_1,

    '' AS house_prefix_2,

    CASE
        WHEN SUBSTR ( Property.StreetNoTo , 1, 1 ) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        WHEN SUBSTR ( Property.StreetNoTo , -1 , 1 ) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN Property.StreetNoTo 
        ELSE IFNULL ( SUBSTR ( Property.StreetNoTo , 1 , LENGTH ( Property.StreetNoTo ) - 1) , '' ) 
    END AS house_number_2,

    CASE
        WHEN SUBSTR ( Property.StreetNoTo , 1, 1 ) NOT IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        WHEN SUBSTR ( Property.StreetNoTo , -1 , 1 ) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN ''
        ELSE IFNULL ( UPPER ( SUBSTR ( Property.StreetNoTo , -1 , 1 ) ) , '' )
    END AS house_suffix_2,

    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,

    UPPER ( Street.Name ) AS street_name,

    CASE
        WHEN UPPER ( StreetType.Type ) LIKE 'AVENUE %' THEN 'AVENUE'
        WHEN UPPER ( StreetType.Type ) LIKE 'LANE %' THEN 'LANE'
        WHEN UPPER ( StreetType.Type ) LIKE 'ROAD %' THEN 'ROAD'
        WHEN UPPER ( StreetType.Type ) LIKE 'STREET %' THEN 'STREET'
        ELSE UPPER ( StreetType.Type )
    END AS street_type, 

    CASE
        WHEN UPPER ( StreetType.Type ) LIKE '% NORTH' THEN 'N'
        WHEN UPPER ( StreetType.Type ) LIKE '% SOUTH' THEN 'S'
        WHEN UPPER ( StreetType.Type ) LIKE '% EAST' THEN 'E'
        WHEN UPPER ( StreetType.Type ) LIKE '% WEST' THEN 'W'
        ELSE ''
    END AS street_suffix,

    UPPER ( Locality.Locality ) AS locality,
    Locality.Postcode as postcode

FROM
    Lynx_vwPropertyClassification Classification,
    Lynx_Propertys Property,
    Lynx_Streets Street,
    Lynx_StreetType StreetType,
    Lynx_Localities Locality

WHERE
    Classification.PropertyNumber = Property.Property AND
    Property.StreetID = Street.ID AND
    Street.Type = StreetType.ID AND
    Street.Locality = Locality.ID AND
    Property.Type not in ( 672 , 700 ) AND
    Classification.LandClassificationCode <> 010

)

