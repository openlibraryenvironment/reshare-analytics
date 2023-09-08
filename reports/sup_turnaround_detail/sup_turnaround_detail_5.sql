--metadb:function stat_rec

DROP FUNCTION IF EXISTS stat_rec;

CREATE FUNCTION stat_rec()
RETURNS TABLE(
    stre_supplier text,
    stre_start timestamptz,
    stre_date_created timestamp,
    stre_req_id uuid,
    stre_from_status text,
    stre_to_status text)
AS $$
SELECT DISTINCT pra.__origin AS stre_supplier,
                pra.__start AS stre_start,
                (array_agg(pra.pra_date_created ORDER BY pra.pra_date_created ASC))[1] AS stre_date_created,
                pra.pra_patron_request_fk AS stre_req_id,
                s.st_code AS stre_from_status,
                s2.st_code AS stre_to_status
    FROM reshare_rs.patron_request_audit AS pra
        LEFT JOIN reshare_rs.status AS s ON pra.pra_from_status_fk::uuid = s.st_id AND pra.__origin = s.__origin
        LEFT JOIN reshare_rs.status AS s2 ON pra.pra_to_status_fk = s2.st_id AND pra.__origin = s2.__origin
    WHERE s.st_code = 'RES_ITEM_SHIPPED' AND s2.st_code = 'RES_ITEM_SHIPPED'
    GROUP BY pra.pra_patron_request_fk, s.st_code, s2.st_code, pra.__origin, pra.__start
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
