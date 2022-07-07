DROP TABLE IF EXISTS rtat_reqs;

CREATE TABLE rtat_reqs AS SELECT DISTINCT
    pr.__origin AS rtr_requester,
    de.de_name AS rtr_requester_nice_name,
    pr.pr_hrid AS rtr_hrid,
    pr.pr_title AS rtr_title,
    pr.pr_local_call_number AS rtr_call_number,
    pr.pr_selected_item_barcode AS rtr_barcode,
    pr.pr_resolved_sup_inst_symbol_fk AS rtr_supplier,
    de2.de_name AS rtr_supplier_nice_name,
    pr.pr_date_created AS rtr_date_created,
    pr.pr_id AS rtr_id
FROM
    reshare_rs.patron_request pr
    LEFT JOIN reshare_rs.patron_request_audit__ pra ON pr.pr_id = pra.pra_patron_request_fk
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
    LEFT JOIN reshare_rs.symbol s2 ON pr.pr_resolved_req_inst_symbol_fk::uuid = s2.sym_id
    LEFT JOIN reshare_rs.symbol s3 ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s3.sym_id
    LEFT JOIN reshare_rs.directory_entry de ON s2.sym_owner_fk = de.de_id
    LEFT JOIN reshare_rs.directory_entry de2 ON s3.sym_owner_fk = de2.de_id
WHERE
    pr.pr_is_requester IS TRUE
    AND pr.pr_hrid IS NOT NULL;

CREATE INDEX ON rtat_reqs (rtr_requester);

CREATE INDEX ON rtat_reqs (rtr_requester_nice_name);

CREATE INDEX ON rtat_reqs (rtr_hrid);

CREATE INDEX ON rtat_reqs (rtr_title);

CREATE INDEX ON rtat_reqs (rtr_call_number);

CREATE INDEX ON rtat_reqs (rtr_barcode);

CREATE INDEX ON rtat_reqs (rtr_supplier);

CREATE INDEX ON rtat_reqs (rtr_supplier_nice_name);

CREATE INDEX ON rtat_reqs (rtr_date_created);

CREATE INDEX ON rtat_reqs (rtr_id);

VACUUM ANALYZE rtat_reqs;

