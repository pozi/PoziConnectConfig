select edit_code, count(*) as count
from M1_A_Edits
group by edit_code

union
select edit_code, count(*) as count
from M1_C_Edits
group by edit_code

union
select edit_code, count(*) as count
from M1_E_Edits
group by edit_code

union
select edit_code, count(*) as count
from M1_P_Edits
group by edit_code

union

select edit_code, count(*) as count
from M1_R_Edits
group by edit_code

union

select edit_code, count(*) as count
from M1_S_Edits
group by edit_code
