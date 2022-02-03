DROP TABLE IF EXISTS stat_reqs;

CREATE TABLE stat_reqs AS SELECT DISTINCT
    pr."__origin" AS str_supplier,
    pr.pr_hrid AS str_hrid,
    pr.pr_title AS str_title,
    pr.pr_local_call_number AS str_call_number,
    pr.pr_selected_item_barcode AS str_barcode,
    pr.pr_resolved_req_inst_symbol_fk AS str_requester,
    pr.pr_date_created AS str_date_created,
    pr.pr_id AS str_id
FROM
    reshare_rs.patron_request pr
    LEFT JOIN reshare_rs.patron_request_audit__ pra ON pr.pr_id = pra.pra_patron_request_fk
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    pr.pr_is_requester IS FALSE
    AND pr.pr_hrid IS NOT NULL
    AND pr.pr_resolved_req_inst_symbol_fk != pr.pr_resolved_sup_inst_symbol_fk
ORDER BY
    pr.pr_date_created ASC;

CREATE INDEX ON stat_reqs (str_supplier);

CREATE INDEX ON stat_reqs (str_hrid);

CREATE INDEX ON stat_reqs (str_title);

CREATE INDEX ON stat_reqs (str_call_number);

CREATE INDEX ON stat_reqs (str_barcode);

CREATE INDEX ON stat_reqs (str_requester);

CREATE INDEX ON stat_reqs (str_date_created);

CREATE INDEX ON stat_reqs (str_id);

VACUUM ANALYZE stat_reqs;
