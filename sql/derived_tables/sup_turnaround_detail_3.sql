DROP TABLE IF EXISTS reshare_derived.stat_fill;

CREATE TABLE reshare_derived.stat_fill AS
SELECT
    pra."__origin" AS stf_supplier,
    pra.pra_date_created AS stf_date_created,
    pra.pra_patron_request_fk AS stf_req_id,
    s.st_code AS stf_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'RES_AWAIT_SHIP'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.stat_fill (stf_supplier);

CREATE INDEX ON reshare_derived.stat_fill (stf_date_created);

CREATE INDEX ON reshare_derived.stat_fill (stf_req_id);

CREATE INDEX ON reshare_derived.stat_fill (stf_status);

