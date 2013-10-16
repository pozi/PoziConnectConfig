SELECT
    ass_num AS propnum,
    TRIM ( fmt_ttl ) AS title_desc

FROM
    AUTHORITY_auprparc AS auprparc

WHERE
    auprparc.pcl_flg IN ( 'R' , 'P' , 'U' ) AND
    auprparc.ass_num NOT IN ( '' , '0' )

ORDER BY
    ass_num