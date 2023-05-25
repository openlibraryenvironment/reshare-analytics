--metadb:table stat_ship

DROP TABLE IF EXISTS stat_ship;

CREATE TABLE stat_ship AS SELECT DISTINCT
    pra.__origin AS sts_supplier,
    pra.__start AS sts_start,
    pra.pra_date_created AS sts_date_created,
    pra.pra_patron_request_fk AS sts_req_id,
    s.st_code AS sts_from_status,
    s2.st_code AS sts_to_status
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk::uuid = s.st_id
        AND pra.__origin = s.__origin
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
        AND pra.__origin = s2.__origin
WHERE (s.st_code = 'RES_AWAIT_PICKING'
    OR s.st_code = 'RES_AWAIT_SHIP')
AND s2.st_code = 'RES_ITEM_SHIPPED';
