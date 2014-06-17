select
    Parish.parish_name,
    Parish.parish_code
from
    vmadmin_parish_polygon Parish,
    vmadmin_lga_polygon LGA
where
    st_intersects ( LGA.geometry , Parish.geometry ) and
    LGA.lga_code = 338
order by
    Parish.parish_name