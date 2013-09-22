select
  Parcel.PropertyNumber as propnum,
  Parcel.LandParcelNumber as crefno,  
  '' as status,
  '' as part,
  case Parcel.Type  
    when 'Lodged Plan' then 'LP' || Parcel.PlanNo
    when 'Title Plan' then 'TP' || Parcel.PlanNo
    when 'Plan of Subdivision' then 'PS' || Parcel.PlanNo
    when 'Consolidation Plan' then 'PC' || Parcel.PlanNo
    when 'Stratum Plan' then 'SP' || Parcel.PlanNo
    else ''
  end as plan_number,
  case Parcel.Type  
    when 'Lodged Plan' then 'LP'
    when 'Title Plan' then 'TP'
    when 'Plan of Subdivision' then 'PS'
    when 'Consolidation Plan' then 'PC'
    when 'Stratum Plan' then 'SP'
    else ''
  end as plan_prefix,
  Parcel.PlanNo as plan_numeral,
  Parcel.Lot as lot_number,
  Parcel.CrownAllotment as allotment,
  Parcel.Section as sec,
  Parcel.Parish asparish_code,
  Parcel.Township as township_code,
  '367' as lga_code
from
  Lynx_vwLandParcel Parcel
where
  Parcel.Status = 'Active' and
  Parcel.Ended is null
