--metadb:function req_stats

-- Create a derived table containing information about requester statistics

DROP FUNCTION IF EXISTS req_stats;

CREATE FUNCTION req_stats()
RETURNS TABLE(
    rs_requester text,
    rs_start timestamptz,
    rs_requester_nice_name text,
    rs_id uuid,
    rs_req_id uuid,
    rs_date_created timestamp,
    rs_from_status text,
    rs_to_status text,
    rs_message text)
AS $$
SELECT pra.__origin AS rs_requester,
       pra.__start AS rs_start,
       names.de_name AS rs_requester_nice_name,
       pra.pra_id AS rs_id,
       pra.pra_patron_request_fk AS rs_req_id,
       pra.pra_date_created AS rs_date_created,
       s2.st_code AS rs_from_status,
       s.st_code AS rs_to_status,
       pra.pra_message AS rs_message
    FROM reshare_rs.patron_request_audit AS pra
        LEFT JOIN reshare_rs.status AS s ON pra.pra_to_status_fk = s.st_id AND pra.__origin = s.__origin
        LEFT JOIN reshare_rs.status AS s2 ON pra.pra_from_status_fk::uuid = s2.st_id AND pra.__origin = s2.__origin
        JOIN ( SELECT de.__origin,
                      de.de_name
                   FROM reshare_rs.directory_entry AS de
                   WHERE de.de_parent IS NULL AND de.de_status_fk IS NOT NULL
             ) AS names ON pra.__origin = names.__origin
    WHERE s.st_code LIKE 'REQ_%' OR s2.st_code LIKE 'REQ_%'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
