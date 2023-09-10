--metadb:function stat_reqs

DROP FUNCTION IF EXISTS stat_reqs;

CREATE FUNCTION stat_reqs()
RETURNS TABLE(
    str_supplier text,
    str_start timestamptz,
    str_supplier_nice_name text,
    str_hrid text,
    str_title text,
    str_call_number text,
    str_barcode text,
    str_requester uuid,
    str_requester_nice_name text,
    str_date_created timestamp,
    str_id uuid)
AS $$
SELECT DISTINCT pr.__origin AS str_supplier,
                pr.__start AS str_start,
                names.de_name AS str_supplier_nice_name,
                pr.pr_hrid AS str_hrid,
                pr.pr_title AS str_title,
                pr.pr_local_call_number AS str_call_number,
                pr.pr_selected_item_barcode AS str_barcode,
                pr.pr_resolved_req_inst_symbol_fk::uuid AS str_requester,
                de.de_name AS str_requester_nice_name,
                pr.pr_date_created AS str_date_created,
                pr.pr_id AS str_id
    FROM reshare_rs.patron_request AS pr
        LEFT JOIN reshare_rs.symbol AS s ON pr.pr_resolved_req_inst_symbol_fk::uuid = s.sym_id AND pr.__origin = s.__origin
        LEFT JOIN reshare_rs.directory_entry AS de ON s.sym_owner_fk = de.de_id AND s.__origin = de.__origin
        JOIN (SELECT de2.__origin,
                     de2.de_name
                  FROM reshare_rs.directory_entry AS de2
                  WHERE de2.de_parent IS NULL AND de2.de_status_fk IS NOT NULL
             ) AS names ON pr.__origin = names.__origin
    WHERE pr.pr_is_requester IS FALSE AND pr.pr_hrid IS NOT NULL AND
        pr.pr_resolved_req_inst_symbol_fk != pr.pr_resolved_sup_inst_symbol_fk
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
