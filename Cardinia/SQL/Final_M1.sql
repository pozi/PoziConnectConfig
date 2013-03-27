select * from M1_MissingVM_Props_usingSPI

union 

Select * From M1_DifferentVM_Props_usingSPI

union 

Select * From M1_DifferentVM_Addr_usingProps

union 

Select * from(
Select * From M1_MissingCouncil_Props_usingPropNo

union 

Select * From M1_DifferentCouncil_Props_usingSPI
) group by Property_PFI, retired_propnum


order by Property_PFI, propnum




