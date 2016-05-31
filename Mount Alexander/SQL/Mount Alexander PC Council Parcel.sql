select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select
    cast ( Assessment.Assessment_Id as varchar ) as propnum,
    '' as status,
    cast ( Title.Title_Id as varchar ) as crefno,
    Title.Title_Legal_Description as summary,
    case when Title_Is_Part_of_Lot = 1 then 'P' else '' end as part,
    ifnull ( Plan_Type.Plan_Type_Code || Title.Title_Plan_Number , '' ) as plan_number,
    ifnull ( Plan_Type.Plan_Type_Code , '' ) as plan_prefix,
    ifnull ( Title.Title_Plan_Number ,'' ) as plan_numeral,
    ifnull ( Title_Lot , '' ) as lot_number,
    ifnull ( Title.Title_Crown_Allotment , '' ) as allotment,
    case when Title.Title_Section = 'NO SEC' then '' else ifnull ( Title.Title_Section , '' ) end as sec,
    ifnull ( Title.Title_Block , '' ) as block,
    ifnull ( Title.Title_Portion , '' ) as portion,
    ifnull ( Title.Title_Subdivision , '' ) as subdivision,
    ifnull ( Parish.Parish_Code , '' ) as parish_code,
    ifnull ( Township.Township_Code , '' ) as township_code,
    '353' as lga_code,
    cast ( Assessment.Assessment_Id as varchar ) as assnum
from
    propertygov_parcel as Parcel inner join
    propertygov_parcel_title as Parcel_Title on Parcel.Parcel_Id = Parcel_Title.Parcel_Id inner join
    propertygov_title as Title on Parcel_Title.Title_Id = Title.Title_Id inner join
    propertygov_assessment_parcel as Assessment_Parcel on Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id inner join
    propertygov_assessment as Assessment on Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id left outer join
    propertygov_plan_type as Plan_Type on Title.Plan_Type = Plan_Type.Plan_Type left outer join
    propertygov_parish as Parish on Title.Parish_Id = Parish.Parish_Id left outer join
    propertygov_township as Township on Title.Township_Id = Township.Township_Id
where
    Parcel.Parcel_Status = 0 and
    Assessment.Assessment_Status <> '9' and
    Assessment.Assess_Number is not null and
    Assessment.Assessment_Id not in ( 10978 , 10986 ) and
    Assessment.Primary_Assess_Land_Use_Id <> 662 and
    Parcel.Parcel_Id <> 25284
order by propnum, crefno
)
)