--metadb:function sup_stats

-- Create a derived table containing information about supplier statistics

DROP FUNCTION IF EXISTS sup_stats;

CREATE FUNCTION sup_stats()
RETURNS TABLE(
    ss_supplier text,
    ss_start timestamptz,
    ss_supplier_nice_name text,
    ss_id uuid,
    ss_req_id uuid,
    ss_date_created timestamp,
    ss_from_status text,
    ss_to_status text,
    ss_message text)
AS $$
SELECT pra.__origin AS ss_supplier,
       pra.__start AS ss_start,
       names.de_name AS ss_supplier_nice_name,
       pra.pra_id AS ss_id,
       pra.pra_patron_request_fk AS ss_req_id,
       pra.pra_date_created AS ss_date_created,
       s2.st_code AS ss_from_status,
       s.st_code AS ss_to_status,
       pra.pra_message AS ss_message
    FROM reshare_rs.patron_request_audit AS pra
        LEFT JOIN reshare_rs.status AS s ON pra.pra_to_status_fk = s.st_id AND pra.__origin = s.__origin
        LEFT JOIN reshare_rs.status AS s2 ON pra.pra_from_status_fk = s2.st_id AND pra.__origin = s2.__origin
        JOIN ( SELECT de.__origin,
                      de.de_name
                   FROM reshare_rs.directory_entry AS de
                   WHERE de.de_parent IS NULL AND de.de_status_fk IS NOT NULL
             ) AS names ON pra.__origin = names.__origin
    WHERE s.st_code LIKE 'RES_%' AND (s2.st_code LIKE 'RES_%' OR s2.st_code IS NULL)
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
