--metadb:table rtat_reqs

DROP TABLE IF EXISTS rtat_reqs;

CREATE TABLE rtat_reqs AS SELECT DISTINCT
    pr.__origin AS rtr_requester,
    pr.__start AS rtr_start,
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
    LEFT JOIN reshare_rs.symbol s ON pr.pr_resolved_req_inst_symbol_fk::uuid = s.sym_id
        AND pr.__origin = s.__origin
    LEFT JOIN reshare_rs.symbol s2 ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s2.sym_id
        AND pr.__origin = s2.__origin
    LEFT JOIN reshare_rs.directory_entry de ON s.sym_owner_fk = de.de_id
        AND s.__origin = de.__origin
    LEFT JOIN reshare_rs.directory_entry de2 ON s2.sym_owner_fk = de2.de_id
        AND s2.__origin = de2.__origin
WHERE
    pr.pr_is_requester IS TRUE
    AND pr.pr_hrid IS NOT NULL;
