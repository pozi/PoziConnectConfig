Select distinct 
c.[PROPNUM] AS PROPNUM,
C.Crefno AS Crefno,
C.[SPI] AS SPI,
c.multiasscount as multiasscount,
c.multiparccount as multiparccount,
vm.parcel_PFI as Parcel_PFI,
vm.[pc_lotno] as pc_lotno,
vm.[PC_PLANNO] as PC_PLANNO,
vm.[parcel_spi] AS Parcel_spi,
vm.LGA_code as LGA_code,
vm.pc_Status as pc_status,
vm.PR_MULTASS 
from TMP_COUNCIL_PROPERTY_PARCEL c, TMP_VM_PROPERTY_PARCEL vm 
         
where c.spi = vm.parcel_spi and vm.PR_PROPNUM is null
