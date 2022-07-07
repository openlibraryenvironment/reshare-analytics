DROP TABLE IF EXISTS stat_ship;

CREATE TABLE stat_ship AS SELECT DISTINCT
    pra.__origin AS sts_supplier,
    pra.pra_date_created AS sts_date_created,
    pra.pra_patron_request_fk AS sts_req_id,
    s.st_code AS sts_from_status,
    s2.st_code AS sts_to_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE
    s.st_code = 'RES_AWAIT_SHIP'
    AND s2.st_code = 'RES_ITEM_SHIPPED';

CREATE INDEX ON stat_ship (sts_supplier);

CREATE INDEX ON stat_ship (sts_date_created);

CREATE INDEX ON stat_ship (sts_req_id);

CREATE INDEX ON stat_ship (sts_from_status);

CREATE INDEX ON stat_ship (sts_to_status);

VACUUM ANALYZE stat_ship;
