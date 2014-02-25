select * from m1_r_edits
union
select * from m1_c_edits
union
select * from m1_p_edits
union
select * from m1_a_edits
union
select * from m1_e_edits
union
select * from m1_s_edits

order by edit_code