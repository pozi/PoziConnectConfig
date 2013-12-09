select * from PC_Council_Parcel
where propnum not in ( select propnum from PC_Council_Property_Address )
