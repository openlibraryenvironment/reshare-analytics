--metadb:function sup_overdue

DROP FUNCTION IF EXISTS sup_overdue;

CREATE FUNCTION sup_overdue()
RETURNS TABLE(
    so_supplier text,
    so_start timestamptz,
    so_supplier_nice_name text,
    so_hrid text,
    so_title text,
    so_requester_sym text,
    so_supplier_url text,
    so_supplier_sym text,
    so_res_state text,
    so_due_date_rs timestamp,
    so_local_call_number text,
    so_item_barcode text,
    so_last_updated timestamp)
AS $$
SELECT DISTINCT pr.__origin AS so_supplier,
                pr.__start AS so_start,
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
    FROM reshare_rs.patron_request AS pr
        JOIN reshare_rs.symbol AS s ON pr.pr_resolved_sup_inst_symbol_fk::uuid = s.sym_id AND pr.__origin = s.__origin
        JOIN reshare_rs.status AS s2 ON pr.pr_state_fk = s2.st_id AND pr.__origin = s2.__origin
        JOIN reshare_rs.directory_entry AS de ON s.sym_owner_fk = de.de_id AND s.__origin = de.__origin
    WHERE pr.pr_due_date_rs::date < CURRENT_DATE AND s2.st_code LIKE 'RES_%' AND s2.st_code NOT LIKE '%_COMPLETE'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
