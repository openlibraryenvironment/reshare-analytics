--metadb:table sup_tat_stats

DROP TABLE IF EXISTS sup_tat_stats;

CREATE TABLE sup_tat_stats AS SELECT DISTINCT
    ss_supplier_nice_name AS stst_supplier,
    ss_start AS stst_start,
    (array_agg(ss_date_created ORDER BY ss_date_created ASC))[1] AS stst_date_created,
    ss_req_id AS stst_req_id,
    ss_from_status AS stst_from_status,
    ss_to_status AS stst_to_status,
    ss_message AS stst_message
FROM
    sup_stats
GROUP BY
    stst_req_id,
    stst_from_status,
    stst_to_status,
    stst_message,
    stst_supplier,
    stst_start;
