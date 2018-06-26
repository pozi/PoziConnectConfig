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
    case
        when Title.Title_Lot like 'CM%' then 'NCPR'
        when cast ( Assessment.Assess_Number as varchar ) glob '*.?' then cast ( Assessment.Assess_Number as varchar ) || '000'
        when cast ( Assessment.Assess_Number as varchar ) glob '*.??' then cast ( Assessment.Assess_Number as varchar ) || '00'
        when cast ( Assessment.Assess_Number as varchar ) glob '*.???' then cast ( Assessment.Assess_Number as varchar ) || '0'
        when cast ( Assessment.Assess_Number as varchar ) glob '*.????' then cast ( Assessment.Assess_Number as varchar )
    end as propnum,
    case Assessment.Assessment_Status
        when '25' then 'P'
        else ''
    end as status,
    cast ( Title.Title_Id as varchar ) as crefno,
    Title.Title_Legal_Description as summary,
    case when Title_Is_Part_of_Lot = 1 or Title.Title_Crown_Allotment like '% PT' then 'P' else '' end as part,
    case    
        when Plan_Type.Plan_Type_Code = 'CA' then ''
        else ifnull ( Plan_Type.Plan_Type_Code || Title.Title_Plan_Number , '' )
    end as plan_number,
    case
        when Plan_Type.Plan_Type_Code = 'CA' then ''
        else ifnull ( Plan_Type.Plan_Type_Code , '' )
    end as plan_prefix,
    ifnull ( Title.Title_Plan_Number ,'' ) as plan_numeral,
    ifnull ( upper ( replace ( Title_Lot , ' ' , '' ) ) , '' ) as lot_number,
    case
        when Title.Title_Crown_Allotment like '% PT' then substr ( Title.Title_Crown_Allotment , 1 , length ( Title.Title_Crown_Allotment ) - 3 )
        else ifnull ( Title.Title_Crown_Allotment , '' )
    end as allotment,
    ifnull ( Title.Title_Section , '' ) as sec,
    ifnull ( Title.Title_Block , '' ) as block,
    ifnull ( Title.Title_Portion , '' ) as portion,
    ifnull ( Title.Title_Subdivision , '' ) as subdivision,
    ifnull ( Parish.Parish_Code , '' ) as parish_code,
    case Township.Township_Code    
        when 'BTO' then '5053'
        when 'COTO' then '5198'
        when 'CTO' then '5204'
        when 'CTA' then '3389A'
        when 'GTO' then '5348'
        when 'ITO' then '5393'
        when 'JJTO' then '5396'
        when 'KTO' then '5418'
        when 'NTO' then '5590'
        when 'RTO' then '5674'
        when 'SRTO' then '5699'
        when 'VTO' then '5814'
        when 'WTO' then '5871'
        when 'WOTO' then '5880'
        else ''
    end as township_code,
    '304' as lga_code,
    cast ( Assessment.Assess_Number as varchar ) as assnum
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
    Assessment.Assess_Number < 999999999999 and
    ifnull ( Title.Title_Plan_Number , '' ) <> 'zz--Obsolete/History'
order by propnum, crefno
)
)