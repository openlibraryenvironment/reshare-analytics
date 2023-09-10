--metadb:function req_overdue

DROP FUNCTION IF EXISTS req_overdue;

CREATE FUNCTION req_overdue()
RETURNS TABLE(
    ro_requester text,
    ro_start timestamptz,
    ro_requester_nice_name text,
    ro_hrid text,
    ro_title text,
    ro_requester_sym text,
    ro_requester_url text,
    ro_supplier_sym text,
    ro_req_state text,
    ro_due_date_rs timestamp,
    ro_return_shipped_date timestamp,
    ro_last_updated timestamp)
AS $$
SELECT DISTINCT pr.__origin AS ro_requester,
                pr.__start AS ro_start,
                de.de_name AS ro_requester_nice_name,
                pr.pr_hrid AS ro_hrid,
                pr.pr_title AS ro_title,
                pr.pr_req_inst_symbol AS ro_requester_sym,
                concat('[RESHARE URL]', '/request/requests/view/', pr.pr_id, '/flow') AS ro_requester_url,
                s.sym_symbol AS ro_supplier_sym,
                s2.st_code AS ro_req_state,
                pr.pr_due_date_rs::timestamp AS ro_due_date_rs,
                CASE WHEN s2.st_code = 'REQ_SHIPPED_TO_SUPPLIER' THEN pr.pr_last_updated
                     ELSE NULL
                END AS ro_return_shipped_date,
                pr.pr_last_updated AS ro_last_updated
    FROM reshare_rs.patron_request AS pr
        JOIN reshare_rs.symbol AS s ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s.sym_id AND pr.__origin = s.__origin
        JOIN reshare_rs.status AS s2 ON pr.pr_state_fk = s2.st_id AND pr.__origin = s2.__origin
        JOIN reshare_rs.symbol AS s3 ON pr.pr_resolved_req_inst_symbol_fk::uuid = s3.sym_id AND pr.__origin = s3.__origin
        JOIN reshare_rs.directory_entry AS de ON s3.sym_owner_fk = de.de_id AND s3.__origin = de.__origin
    WHERE pr.pr_due_date_rs::date < CURRENT_DATE AND s2.st_code LIKE 'REQ_%' AND s2.st_code NOT LIKE '%_COMPLETE'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
