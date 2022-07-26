DROP TABLE IF EXISTS stat_reqs;

CREATE TABLE stat_reqs AS SELECT DISTINCT
    pr.__origin AS str_supplier,
    names.de_name AS str_supplier_nice_name,
    pr.pr_hrid AS str_hrid,
    pr.pr_title AS str_title,
    pr.pr_local_call_number AS str_call_number,
    pr.pr_selected_item_barcode AS str_barcode,
    pr.pr_resolved_req_inst_symbol_fk AS str_requester,
    de.de_name AS str_requester_nice_name,
    pr.pr_date_created AS str_date_created,
    pr.pr_id AS str_id
FROM
    reshare_rs.patron_request pr
    LEFT JOIN reshare_rs.patron_request_audit__ pra ON pr.pr_id = pra.pra_patron_request_fk
        AND pr.__origin = pra.__origin
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
        AND pra.__origin = s.__origin
    LEFT JOIN reshare_rs.symbol s2 ON pr.pr_resolved_req_inst_symbol_fk::uuid = s2.sym_id
        AND pr.__origin = s2.__origin
    LEFT JOIN reshare_rs.directory_entry de ON s2.sym_owner_fk = de.de_id
        AND s2.__origin = de.__origin
    JOIN (
        SELECT
            de2.__origin,
            de2.de_name
        FROM
            reshare_rs.directory_entry de2
        WHERE
            de2.de_parent IS NULL
            AND de2.de_status_fk IS NOT NULL) AS names ON pr.__origin = names.__origin
WHERE
    pr.pr_is_requester IS FALSE
    AND pr.pr_hrid IS NOT NULL
    AND pr.pr_resolved_req_inst_symbol_fk != pr.pr_resolved_sup_inst_symbol_fk;

CREATE INDEX ON stat_reqs (str_supplier);

CREATE INDEX ON stat_reqs (str_supplier_nice_name);

CREATE INDEX ON stat_reqs (str_hrid);

CREATE INDEX ON stat_reqs (str_title);

CREATE INDEX ON stat_reqs (str_call_number);

CREATE INDEX ON stat_reqs (str_barcode);

CREATE INDEX ON stat_reqs (str_requester);

CREATE INDEX ON stat_reqs (str_requester_nice_name);

CREATE INDEX ON stat_reqs (str_date_created);

CREATE INDEX ON stat_reqs (str_id);

VACUUM ANALYZE stat_reqs;

