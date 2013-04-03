

Select distinct TMPCounParc.*,cparcount.MultiAssCount AS MultiAssCount,cpropcount.MultiParcCount AS MultiParcCount
FROM Temp_PIQA_Parcel  as TMPCounParc 
 INNER JOIN 
	Council_parcel_Count AS cparcount ON TMPCounParc.SPI = cparcount.SPI
	 INNER JOIN 
	Council_property_Count AS cpropcount ON TMPCounParc.propnum = cpropcount.propnum