DROP TABLE IF EXISTS reshare_derived.rtat_ship;

CREATE TABLE reshare_derived.rtat_ship AS SELECT DISTINCT
    pra."__origin" AS rts_requester,
    pra.pra_date_created AS rts_date_created,
    pra.pra_patron_request_fk AS rts_req_id,
    s.st_code AS rts_from_status,
    s2.st_code AS rts_to_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE (s.st_code = 'REQ_EXPECTS_TO_SUPPLY'
    OR s.st_code = 'REQ_CONDITIONAL_ANSWER_RECEIVED')
AND s2.st_code = 'REQ_SHIPPED'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.rtat_ship (rts_requester);

CREATE INDEX ON reshare_derived.rtat_ship (rts_date_created);

CREATE INDEX ON reshare_derived.rtat_ship (rts_req_id);

CREATE INDEX ON reshare_derived.rtat_ship (rts_from_status);

CREATE INDEX ON reshare_derived.rtat_ship (rts_to_status);

