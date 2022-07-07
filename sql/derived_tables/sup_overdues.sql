DROP TABLE IF EXISTS sup_overdue;

CREATE TABLE sup_overdue AS SELECT DISTINCT
    pr.__origin AS so_supplier,
    de.de_name AS so_supplier_nice_name,
    pr.pr_hrid AS so_hrid,
    pr.pr_title AS so_title,
    pr.pr_req_inst_symbol AS so_requester_sym,
    concat('[RESHARE URL]', '/supply/requests/view/', pr.pr_id, '/flow') AS so_supplier_url,
    s.sym_symbol AS so_supplier_sym,
    s2.st_code AS so_res_state,
    pr.pr_due_date_rs AS so_due_date_rs,
    pr.pr_local_call_number AS so_local_call_number,
    pr.pr_selected_item_barcode AS so_item_barcode,
    pr.pr_last_updated AS so_last_updated
FROM
    reshare_rs.patron_request pr
    JOIN reshare_rs.symbol s ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s.sym_id
    JOIN reshare_rs.status s2 ON pr.pr_state_fk = s2.st_id
    JOIN reshare_rs.directory_entry de ON s.sym_owner_fk = de.de_id
WHERE
    pr.pr_due_date_rs::date < CURRENT_DATE
    AND s2.st_code LIKE 'RES_%'
    AND s2.st_code NOT LIKE '%_COMPLETE';

CREATE INDEX ON sup_overdue (so_supplier);

CREATE INDEX ON sup_overdue (so_supplier_nice_name);

CREATE INDEX ON sup_overdue (so_hrid);

CREATE INDEX ON sup_overdue (so_title);

CREATE INDEX ON sup_overdue (so_requester_sym);

CREATE INDEX ON sup_overdue (so_supplier_url);

CREATE INDEX ON sup_overdue (so_supplier_sym);

CREATE INDEX ON sup_overdue (so_res_state);

CREATE INDEX ON sup_overdue (so_due_date_rs);

CREATE INDEX ON sup_overdue (so_local_call_number);

CREATE INDEX ON sup_overdue (so_item_barcode);

CREATE INDEX ON sup_overdue (so_last_updated);

VACUUM ANALYZE sup_overdue;
