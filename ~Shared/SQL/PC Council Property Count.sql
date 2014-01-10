select
    propnum,
    count(*) as num_records
from PC_Council_Property_Address
group by propnum
order by num_records desc