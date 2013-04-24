SELECT [Temp_PIQA_Parcel].Propnum,
[Temp_PIQA_Parcel].Crefno,
[Temp_PIQA_Parcel].[SPI],
  [Council_Property_Count].[MultiParcCount],
  [Council_Parcel_Count].[MultiAssCount]
FROM [Council_Parcel_Count]
  LEFT JOIN [Temp_PIQA_Parcel]
    ON [Temp_PIQA_Parcel].[SPI] = [Council_Parcel_Count].[SPI]
  LEFT JOIN [Council_Property_Count] ON [Temp_PIQA_Parcel].[Propnum]
    = [Council_Property_Count].[Propnum]