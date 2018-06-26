# Bass Coast PC Council Parcel SQL

## Logic

### Attributes

#### PropNum

Pad the property number with the appropriate number of zeros.

```sql
case
	when cast ( Assessment.Assess_Number as varchar ) glob '*.?' then cast ( Assessment.Assess_Number as varchar ) || '000'
	when cast ( Assessment.Assess_Number as varchar ) glob '*.??' then cast ( Assessment.Assess_Number as varchar ) || '00'
	when cast ( Assessment.Assess_Number as varchar ) glob '*.???' then cast ( Assessment.Assess_Number as varchar ) || '0'
	when cast ( Assessment.Assess_Number as varchar ) glob '*.????' then cast ( Assessment.Assess_Number as varchar )
end as propnum
```

#### Township Code

```sql
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
```

### Join

```sql
PropertyGov_parcel as Parcel inner join
PropertyGov_parcel_title as Parcel_Title on Parcel.Parcel_Id = Parcel_Title.Parcel_Id inner join
PropertyGov_title as Title on Parcel_Title.Title_Id = Title.Title_Id inner join
PropertyGov_assessment_parcel as Assessment_Parcel on Parcel.Parcel_Id = Assessment_Parcel.Parcel_Id inner join
PropertyGov_assessment as Assessment on Assessment_Parcel.Assessment_Id = Assessment.Assessment_Id left outer join
PropertyGov_plan_type as Plan_Type on Title.Plan_Type = Plan_Type.Plan_Type left outer join
PropertyGov_parish as Parish on Title.Parish_Id = Parish.Parish_Id left outer join    
PropertyGov_township as Township on Title.Township_Id = Township.Township_Id
```

### Filter

```sql
Parcel.Parcel_Status = 0 and
Assessment.Assessment_Status <> '9' and
Assessment.Assess_Number < 999999999999
```
