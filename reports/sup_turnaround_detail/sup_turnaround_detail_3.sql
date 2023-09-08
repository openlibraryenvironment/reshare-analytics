--metadb:function stat_fill

DROP FUNCTION IF EXISTS stat_fill;

CREATE FUNCTION stat_fill()
RETURNS TABLE(
    stf_supplier text,
    stf_start timestamptz,
    stf_date_created timestamp,
    stf_req_id uuid,
    stf_from_status text,
    stf_to_status text)
AS $$
SELECT DISTINCT pra.__origin AS stf_supplier,
                pra.__start AS stf_start,
                pra.pra_date_created AS stf_date_created,
                pra.pra_patron_request_fk AS stf_req_id,
                s.st_code AS stf_from_status,
                s2.st_code AS stf_to_status
    FROM reshare_rs.patron_request_audit AS pra
        LEFT JOIN reshare_rs.status AS s ON pra.pra_from_status_fk::uuid = s.st_id AND pra.__origin = s.__origin
        LEFT JOIN reshare_rs.status AS s2 ON pra.pra_to_status_fk = s2.st_id AND pra.__origin = s2.__origin
    WHERE s.st_code = 'RES_AWAIT_PICKING' AND s2.st_code IN ('RES_AWAIT_SHIP', 'RES_ITEM_SHIPPED')
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
