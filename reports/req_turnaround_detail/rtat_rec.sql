--metadb:function rtat_rec

DROP FUNCTION IF EXISTS rtat_rec;

CREATE FUNCTION rtat_rec()
RETURNS TABLE(
    rtre_requester text,
    rtre_start timestamptz,
    rtre_date_created timestamp,
    rtre_req_id uuid,
    rtre_status text)
AS $$
SELECT DISTINCT pra.__origin AS rtre_requester,
                pra.__start AS rtre_start,
                pra.pra_date_created AS rtre_date_created,
                pra.pra_patron_request_fk AS rtre_req_id,
                s.st_code AS rtre_status
    FROM reshare_rs.patron_request_audit AS pra
        LEFT JOIN reshare_rs.status AS s ON pra.pra_to_status_fk = s.st_id AND pra.__origin = s.__origin
    WHERE s.st_code = 'REQ_CHECKED_IN'
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
