select crefno, spi, propnum from PC_Vicmap_Parcel where crefno in
(
select crefno from
(
select crefno, count(*) as num_crefno_occurrences from PC_Vicmap_Parcel where multi_assessment = 'N' and crefno <> '' and spi in ( select spi from PC_Vicmap_Parcel_Property_Count where num_props = 1 ) and spi <> '' group by crefno
)
where num_crefno_occurrences > 1
)
order by crefno