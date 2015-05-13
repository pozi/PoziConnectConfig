select distinct
    cast ( lpaparc.tpklpaparc as varchar ) as crefno,
    ifnull ( lpaparc.fmtparcel , '' ) as summary,
    lpatitl.*
from
    pathway_lpatitl as lpatitl
    left join
    pathway_lpaparc as lpaparc on lpatitl.tpklpatitl = lpaparc.tpklpaparc
where
    lpaparc.tpklpaparc is not null