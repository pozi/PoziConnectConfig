select
    propnum as council_propnum,
    status as council_status,
    ifnull ( ( select edit_code from M1 where m1.propnum = cpa.propnum limit 1 ) , '' ) as current_m1
from PC_Council_Property_Address cpa
order by propnum
