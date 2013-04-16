SELECT
    *,
    Street_Name ||
        RTRIM ( ' ' || Street_Type ) ||
        RTRIM ( ' ' || Street_Suffix ) AS roadnt_pr,
    street_name ||
        RTRIM ( ' ' || Street_Type) ||
        RTRIM ( ' ' || Street_Suffix ) || ' ' ||
        locality AS stjoin_pr,
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || Street_Type ) ||
        RTRIM ( ' ' || Street_Suffix) ||
        RTRIM ( ' ' || locality ) ) AS address_pr,
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || Street_Type ) ||
        RTRIM ( ' ' || Street_Suffix ) ||
        RTRIM ( ' ' || locality ) ||
        RTRIM ( ' ' || CAST ( propnum AS INTEGER ) ) ) AS address_propnum_pr
FROM (

SELECT DISTINCT
	Unique_Assessment.Assess_Number AS propnum,
	CAST(Unique_Assessment.Assess_Number as integer)  AS "PROPNUM_INT",
	Unique_Assessment.AddressCount AS AddressCount,
    UPPER ( IFNULL ( Address.Building_Unit_Abbreviation , '' ) ) AS su_type,
    UPPER ( IFNULL ( Address.Addr_Building_Unit_Prefix_1 , '' ) ) AS su_prefix_1,
    CAST ( IFNULL ( Address.Addr_Building_Unit_Number_1 , '' ) AS VARCHAR ) AS su_no_1,
    UPPER ( IFNULL ( Address.Addr_Building_Unit_Suffix_1 , '' ) ) AS su_suff_1,
    UPPER ( IFNULL ( Address.Addr_Building_Unit_Prefix_2 , '' ) ) AS su_prefix_2,
    CAST ( IFNULL ( Address.Addr_Building_Unit_Number_2 , '' ) AS VARCHAR ) AS su_no_2,
    UPPER ( IFNULL ( Address.Addr_Building_Unit_Suffix_2 , '' ) ) AS su_suff_2,
    UPPER ( IFNULL ( Address.Address_Floor_Type_Abbrev , '' ) ) AS fl_type,
    UPPER ( IFNULL ( Address.Addr_Floor_Prefix_1 , '' ) ) AS fl_prefix_1,
    CAST ( IFNULL ( Address.Addr_Floor_Number_1 , '' ) AS VARCHAR ) AS fl_no_1,
    UPPER ( IFNULL ( Address.Addr_Floor_Suffix_1 , '' ) )  AS fl_suff_1, 
    UPPER ( IFNULL ( Address.Addr_Floor_Prefix_2 , '' ) )  AS fl_prefix_2,
    CAST ( IFNULL ( Address.Addr_Floor_Number_2 , '' ) AS VARCHAR ) AS fl_no_2, 
    UPPER ( IFNULL ( Address.Addr_Floor_Suffix_2 , '' ) )  AS fl_suff_2,
    UPPER ( IFNULL ( Unique_Assessment.Assess_Property_Name , '' ) ) AS pr_name_1, 
    '' AS pr_name_2, 
	CASE
        WHEN UPPER ( Street.Street_Name ) LIKE 'OFF %' THEN 'OFF'
        ELSE ''
    END AS loc_des,
    UPPER ( IFNULL ( Address.Addr_House_Prefix_1 , '' ) )  AS house_prefix_1,
    CAST ( IFNULL ( Address.Addr_House_Number_1 , '' ) AS VARCHAR ) AS house_number_1, 
    UPPER ( IFNULL ( Address.Addr_House_Suffix_1 , '' ) )  AS house_suffix_1,
    UPPER ( IFNULL ( Address.Addr_House_Prefix_2 , '' ) )  AS house_prefix_2, 
    CAST ( IFNULL ( Address.Addr_House_Number_2 , '' ) AS VARCHAR ) AS house_number_2,
    UPPER ( IFNULL ( Address.Addr_House_Suffix_2 , '' ) )  AS house_suffix_2, 
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
	CASE
        WHEN UPPER ( Street.Street_Name ) LIKE 'OFF %' THEN SUBSTR ( UPPER ( Street.Street_Name ) , 5 )
        ELSE UPPER ( IFNULL ( Replace(Street.Street_Name,'`','') , '' ) )
    END AS street_name,
    UPPER ( IFNULL ( Street_Type.Street_Type_Name , '' ) )  AS street_type,
    CASE
        WHEN UPPER ( Street.Street_Suffix ) IN ( 'NORTH' , 'N' ) THEN 'N'
        WHEN UPPER ( Street.Street_Suffix ) IN ( 'SOUTH' , 'S' ) THEN 'S'
        WHEN UPPER ( Street.Street_Suffix ) IN ( 'EAST' , 'E' ) THEN 'E'
        WHEN UPPER ( Street.Street_Suffix ) IN ( 'WEST' , 'W' ) THEN 'W'
        ELSE ''
    END AS street_suffix,
    UPPER ( IFNULL ( Locality.Locality_Name , '' ) )  AS locality,
    Locality.Locality_Postcode AS postcode

      

FROM (

Select Parcel.Address_Id as Address_Id,Parcel.Parcel_Id as Parcel_Id, Assessment.Assess_Property_Name as Assess_Property_Name, Assessment.Assess_Number as Assess_Number,count(Assess_Number) as AddressCount

FROM
    PROPERTYGOV_Parcel as Parcel INNER JOIN
    PROPERTYGOV_Assessment_Parcel as Assessment_Parcel ON Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id INNER JOIN
    PROPERTYGOV_Assessment as Assessment ON Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id     

WHERE
    Parcel.Parcel_Status = 0 AND
    Assessment.Assessment_Status NOT IN ( '9' , '22' ) AND    
    Assessment.Assess_Number IS NOT NULL    

Group by Assessment.Assess_Number 

) AS Unique_Assessment INNER JOIN 


    PROPERTYGOV_Address as Address ON Unique_Assessment.Address_Id = Address.Address_Id 
INNER JOIN
    PROPERTYGOV_Street_Locality as Street_Locality ON Address.Street_Locality_Id = Street_Locality.Street_Locality_Id 
LEFT OUTER JOIN
    PROPERTYGOV_Street as Street ON Street_Locality.Street_Id = Street.Street_Id 
LEFT OUTER JOIN
    PROPERTYGOV_Locality as Locality ON Street_Locality.Locality_Id = Locality.Locality_Id 
LEFT OUTER JOIN
    PROPERTYGOV_Street_Type as Street_Type ON Street.Street_Type_Abbreviation = Street_Type.Street_Type_Abbreviation
)