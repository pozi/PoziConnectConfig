Select distinct 
c.PROPNUM AS PROPNUM,
vm.LGA_code as LGA_code,
c.address_pr,
vm.EZI_ADD 
from Temp_PIQA_address c inner join TMP_VM_PROPERTY_ADDRESS vm on c.PROPNUM = vm.PROPNUM 
where replace (c.[address_pr],"'","") <> vm.ezi_add
