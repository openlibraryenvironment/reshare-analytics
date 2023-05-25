--metadb:table stat_assi

DROP TABLE IF EXISTS stat_assi;

CREATE TABLE stat_assi AS SELECT DISTINCT
    pra.__origin AS sta_supplier,
    pra.__start AS sta_start,
    pra.pra_date_created AS sta_date_created,
    pra.pra_patron_request_fk AS sta_req_id,
    s.st_code AS sta_from_status,
    s2.st_code AS sta_to_status
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk::uuid = s.st_id
        AND pra.__origin = s.__origin
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
        AND pra.__origin = s2.__origin
WHERE
    s.st_code IS NULL
    AND s2.st_code = 'RES_IDLE';
