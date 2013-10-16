
SELECT 
	Assessment.Assess_Number AS PROPNUM,
	CASE WHEN Title_Is_Part_of_Lot = 1 THEN 'P' ELSE '' END AS PART, 
	Plan_Type.Plan_Type_Name + Title.Title_Plan_Number AS PLAN_NUMBER,
	Title_Lot AS LOT_NUMBER,
	Title.Title_Crown_Allotment AS ALLOTMENT,
	Title.Title_Section AS [SECTION], 
	Title.Title_Block AS BLOCK,
	Title.Title_Portion AS PORTION, 
	Title.Title_Subdivision AS SUBDIVISION,
	Parish.Parish_Code AS PARISH_CODE

FROM
	PROPERTYGOV_parcel AS Parcel INNER JOIN
	PROPERTYGOV_parcel_title AS Parcel_Title ON Parcel.Parcel_Id = Parcel_Title.Parcel_Id INNER JOIN
	PROPERTYGOV_title AS Title ON Parcel_Title.Title_Id = Title.Title_Id INNER JOIN
	PROPERTYGOV_assessment_parcel AS Assessment_Parcel ON Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id INNER JOIN
	PROPERTYGOV_assessment AS Assessment ON Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id LEFT OUTER JOIN
	PROPERTYGOV_plan_type AS Plan_Type ON Title.Plan_Type = Plan_Type.Plan_Type LEFT OUTER JOIN
	PROPERTYGOV_parish AS Parish ON Title.Parish_Id = Parish.Parish_Id

WHERE
	(Parcel.Parcel_Status = 0)

