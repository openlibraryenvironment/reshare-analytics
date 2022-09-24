DROP TABLE IF EXISTS req_overdue;

CREATE TABLE req_overdue AS SELECT DISTINCT
    pr.__origin AS ro_requester,
    pr.__start AS ro_start,
    de.de_name AS ro_requester_nice_name,
    pr.pr_hrid AS ro_hrid,
    pr.pr_title AS ro_title,
    pr.pr_req_inst_symbol AS ro_requester_sym,
    concat('[RESHARE URL]', '/request/requests/view/', pr.pr_id, '/flow') AS ro_requester_url,
    s.sym_symbol AS ro_supplier_sym,
    s2.st_code AS ro_req_state,
    pr.pr_due_date_rs AS ro_due_date_rs,
    (
        CASE WHEN s2.st_code = 'REQ_SHIPPED_TO_SUPPLIER' THEN
            pr.pr_last_updated
        ELSE
            NULL
        END) AS ro_return_shipped_date,
    pr.pr_last_updated AS ro_last_updated
FROM
    reshare_rs.patron_request pr
    JOIN reshare_rs.symbol s ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s.sym_id
        AND pr.__origin = s.__origin
    JOIN reshare_rs.status s2 ON pr.pr_state_fk = s2.st_id
        AND pr.__origin = s2.__origin
    JOIN reshare_rs.symbol s3 ON pr.pr_resolved_req_inst_symbol_fk::uuid = s3.sym_id
        AND pr.__origin = s3.__origin
    JOIN reshare_rs.directory_entry de ON s3.sym_owner_fk = de.de_id
        AND s3.__origin = de.__origin
WHERE
    pr.pr_due_date_rs::date < CURRENT_DATE
    AND s2.st_code LIKE 'REQ_%'
    AND s2.st_code NOT LIKE '%_COMPLETE';

CREATE INDEX ON req_overdue (ro_requester);

CREATE INDEX ON req_overdue (ro_start);

CREATE INDEX ON req_overdue (ro_requester_nice_name);

CREATE INDEX ON req_overdue (ro_hrid);

CREATE INDEX ON req_overdue (ro_title);

CREATE INDEX ON req_overdue (ro_requester_sym);

CREATE INDEX ON req_overdue (ro_requester_url);

CREATE INDEX ON req_overdue (ro_supplier_sym);

CREATE INDEX ON req_overdue (ro_req_state);

CREATE INDEX ON req_overdue (ro_due_date_rs);

CREATE INDEX ON req_overdue (ro_return_shipped_date);

CREATE INDEX ON req_overdue (ro_last_updated);

VACUUM ANALYZE req_overdue;

