DROP TABLE IF EXISTS reshare_derived.stat_assi;

CREATE TABLE reshare_derived.stat_assi AS
SELECT
    pra."__origin" AS sta_supplier,
    pra.pra_date_created AS sta_date_created,
    pra.pra_patron_request_fk AS sta_req_id,
    s.st_code AS sta_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'RES_IDLE'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.stat_assi (sta_supplier);

CREATE INDEX ON reshare_derived.stat_assi (sta_date_created);

CREATE INDEX ON reshare_derived.stat_assi (sta_req_id);

CREATE INDEX ON reshare_derived.stat_assi (sta_status);

