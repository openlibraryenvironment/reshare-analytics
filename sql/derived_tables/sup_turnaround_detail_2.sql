DROP TABLE IF EXISTS stat_assi;

CREATE TABLE stat_assi AS SELECT DISTINCT
    pra."__origin" AS sta_supplier,
    pra.pra_date_created AS sta_date_created,
    pra.pra_patron_request_fk AS sta_req_id,
    s.st_code AS sta_from_status,
    s2.st_code AS sta_to_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE
    s.st_code IS NULL
    AND s2.st_code = 'RES_IDLE'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON stat_assi (sta_supplier);

CREATE INDEX ON stat_assi (sta_date_created);

CREATE INDEX ON stat_assi (sta_req_id);

CREATE INDEX ON stat_assi (sta_from_status);

CREATE INDEX ON stat_assi (sta_to_status);

