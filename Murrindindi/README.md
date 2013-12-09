# Murrindindi

## Parcel Query

## Property Address Query

### Primary Address

Brian Hall from Civica says:

> The str_seq ‘0’ would only be used to override an address for an assessment. By default the lowest registered parcel number is used on an assessment but if the site wants to use a different parcel’s address they use the ‘Make Primary Parcel’ button to set the sequence zero on that higher numbered parcel.
 
> So in the majority of cases where the site is happy with the primary parcel being the one with the lowest parcel number (generally first one created) the sequence numbers are all null and so you need to take that into account.

#### Logic

When the parcel number is the one within the property that has the lowest value when ordered by `str_seq` and `pcl_num`, flag it as the primary address.

Note, within our subquery, if the `str_seq` value is null, then it is assigned a value of 1 so that it is ordered after the ones that have been given a value of 0.

#### SQL

```sql
case
    when auprparc.pcl_num = ( select t.pcl_num from Authority_auprparc t where t.ass_num = auprparc.ass_num and t.pcl_flg in ( 'R' , 'P' ) order by ifnull ( t.str_seq , 1 ), t.pcl_num limit 1 ) then 'Y'
    else 'N'
end as is_primary,

```
