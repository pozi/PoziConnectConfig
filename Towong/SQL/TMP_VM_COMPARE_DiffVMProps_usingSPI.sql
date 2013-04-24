Select distinct 
c.[PROPNUM] AS PROPNUM, 
c.[crefno] AS Crefno, 
vm.[parcel_pfi] AS Parcel_pfi,  
C.[SPI] AS SPI,
c.multiasscount as multiasscount,
c.multiparccount as multiparccount,
[pc_lotno] as pc_lotno,
[PC_PLANNO] as PC_PLANNO, 
vm.[parcel_spi] AS Parcel_spi, 
vm.LGA_code AS LGA_code, 
vm.pc_status AS pc_status 
from TMP_COUNCIL_PROPERTY_PARCEL c , TMP_VM_PROPERTY_PARCEL vm 
where c.spi = vm.parcel_spi and vm.PR_PROPNUM is not null and c.PROPNUM not in (select vm2.PR_PROPNUM from TMP_VM_PROPERTY_PARCEL vm2 where vm2.[parcel_spi]=c.spi)
