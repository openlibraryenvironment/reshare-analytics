DROP TABLE IF EXISTS sup_tat_stats;

CREATE TABLE sup_tat_stats AS SELECT DISTINCT
    ss_supplier_nice_name AS stst_supplier,
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
    stst_supplier;

CREATE INDEX ON sup_tat_stats (stst_supplier);

CREATE INDEX ON sup_tat_stats (stst_date_created);

CREATE INDEX ON sup_tat_stats (stst_req_id);

CREATE INDEX ON sup_tat_stats (stst_from_status);

CREATE INDEX ON sup_tat_stats (stst_to_status);

CREATE INDEX ON sup_tat_stats (stst_message);

VACUUM ANALYZE sup_tat_stats;
