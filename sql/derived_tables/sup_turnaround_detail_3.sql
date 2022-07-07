DROP TABLE IF EXISTS stat_fill;

CREATE TABLE stat_fill AS SELECT DISTINCT
    pra.__origin AS stf_supplier,
    pra.pra_date_created AS stf_date_created,
    pra.pra_patron_request_fk AS stf_req_id,
    s.st_code AS stf_from_status,
    s2.st_code AS stf_to_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE
    s.st_code = 'RES_AWAIT_PICKING'
    AND s2.st_code = 'RES_AWAIT_SHIP';

CREATE INDEX ON stat_fill (stf_supplier);

CREATE INDEX ON stat_fill (stf_date_created);

CREATE INDEX ON stat_fill (stf_req_id);

CREATE INDEX ON stat_fill (stf_from_status);

CREATE INDEX ON stat_fill (stf_to_status);

VACUUM ANALYZE stat_fill;
