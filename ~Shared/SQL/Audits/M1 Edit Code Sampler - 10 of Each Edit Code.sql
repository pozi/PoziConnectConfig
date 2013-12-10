select * from (
    select edit_code, comments
    from M1_A_Edits
    order by random() limit 10
)

union

select * from (
    select edit_code, comments
    from M1_C_Edits
    order by random() limit 10
)

union

select * from (
    select edit_code, comments
    from M1_E_Edits
    order by random() limit 10
)

union

select * from (
    select edit_code, comments
    from M1_P_Edits
    order by random() limit 10
)

union

select * from (
    select edit_code, comments
    from M1_R_Edits
    order by random() limit 10
)

union

select * from (
    select edit_code, comments
    from M1_S_Edits
    order by random() limit 10
)
