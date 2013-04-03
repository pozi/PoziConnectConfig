

Select distinct TMPCounParc.*, TMPCounProp.Address_pr AS Address_pr, cparcount.MultiAssCount AS MultiAssCount, cpropcount.MultiParcCount AS MultiParcCount
FROM Temp_PIQA_Parcel  as TMPCounParc 
 INNER JOIN 
	Council_parcel_Count AS cparcount ON TMPCounParc.SPI =  cparcount.SPI	
	INNER JOIN 
	Temp_PIQA_Address AS TMPCounProp ON TMPCounParc.crefno =  TMPCounProp.crefno
	
INNER JOIN 
	Council_Property_Count AS cpropcount ON TMPCounParc.propnum =  cpropcount.Propnum

	

