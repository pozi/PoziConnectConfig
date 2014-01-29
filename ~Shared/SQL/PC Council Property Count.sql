select
    propnum,
    count(*) as num_records
from pc_council_property_address
group by propnum
order by num_records desc