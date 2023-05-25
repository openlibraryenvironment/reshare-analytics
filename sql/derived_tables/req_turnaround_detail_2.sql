--metadb:table rtat_ship

DROP TABLE IF EXISTS rtat_ship;

CREATE TABLE rtat_ship AS SELECT DISTINCT
    pra.__origin AS rts_requester,
    pra.__start AS rts_start,
    pra.pra_date_created AS rts_date_created,
    pra.pra_patron_request_fk AS rts_req_id,
    s.st_code AS rts_from_status,
    s2.st_code AS rts_to_status
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_from_status_fk::uuid = s.st_id
        AND pra.__origin = s.__origin
    LEFT JOIN reshare_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
        AND pra.__origin = s2.__origin
WHERE (s.st_code = 'REQ_EXPECTS_TO_SUPPLY'
    OR s.st_code = 'REQ_CONDITIONAL_ANSWER_RECEIVED')
AND s2.st_code = 'REQ_SHIPPED';
