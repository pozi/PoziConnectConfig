SELECT 
	Assessment.Assess_Number AS propnum,
    Title.Title_Id AS crefno,
    Title.Title_Legal_Description AS Parcel_Description,
    CASE WHEN Title_Is_Part_of_Lot = 1 THEN 'P' ELSE '' END AS part, 
	IFNULL ( Plan_Type.Plan_Type_Name || Title.Title_Plan_Number ,'' ) AS plan_number,
	IFNULL ( Title_Lot , '' ) AS lot_number,
	IFNULL ( Title.Title_Crown_Allotment , '' ) AS allotment,
	IFNULL ( Title.Title_Section , '' ) AS [section], 
	IFNULL ( Title.Title_Block , '' ) AS block,
	IFNULL ( Title.Title_Portion , '' ) AS portion, 
	IFNULL ( Title.Title_Subdivision , '' ) AS subdivision,
	IFNULL ( Parish.Parish_Code , '' ) AS parish_code,
	IFNULL ( Township.Township_Code , '' ) AS township_code

FROM
	PROPERTYGOV_parcel AS Parcel INNER JOIN
	PROPERTYGOV_parcel_title AS Parcel_Title ON Parcel.Parcel_Id = Parcel_Title.Parcel_Id INNER JOIN
	PROPERTYGOV_title AS Title ON Parcel_Title.Title_Id = Title.Title_Id INNER JOIN
	PROPERTYGOV_assessment_parcel AS Assessment_Parcel ON Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id INNER JOIN
	PROPERTYGOV_assessment AS Assessment ON Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id LEFT OUTER JOIN
	PROPERTYGOV_plan_type AS Plan_Type ON Title.Plan_Type = Plan_Type.Plan_Type LEFT OUTER JOIN
	PROPERTYGOV_parish AS Parish ON Title.Parish_Id = Parish.Parish_Id LEFT OUTER JOIN
    PROPERTYGOV_Township AS Township ON Title.Township_Id = Township.Township_Id

WHERE
	Parcel.Parcel_Status = 0 AND
    Assessment.Assessment_Status NOT IN ( '9' , '22' ) AND    
    Assessment.Assess_Number IS NOT NULL