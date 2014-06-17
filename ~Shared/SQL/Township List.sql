select
    substr ( Township.township_name , 1 , length ( Township.township_name ) - 3 ) as TOWNSHIP_NAME,
    Township.township_code
from
    vmadmin_township_polygon Township,
    vmadmin_lga_polygon LGA
where
    st_intersects ( LGA.geometry , Township.geometry ) and
    LGA.lga_code = 338
order by
    Township.township_name