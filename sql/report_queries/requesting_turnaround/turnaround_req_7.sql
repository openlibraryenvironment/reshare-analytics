-- Have not found the base URL for a tenant anywhere in the database consistently across all tenants.
WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    ntr.rtr_requester_nice_name AS requester,
    ntr.rtr_hrid AS request_id,
    concat('[RESHARE URL]', '/request/requests/view/', ntr.rtr_id, '/flow') AS request_url,
    ntr.rtr_supplier_nice_name AS supplier,
    ntr.rtr_title AS title,
    ntr.rtr_call_number AS call_number,
    ntr.rtr_barcode AS barcode,
    ntr.rtr_date_created AS created,
    nts.rts_date_created AS shipped,
    ntr2.rtre_date_created AS received,
    (nts.rts_date_created - ntr.rtr_date_created) AS time_to_ship,
    (ntr2.rtre_date_created - nts.rts_date_created) AS time_to_receipt,
    (ntr2.rtre_date_created - ntr.rtr_date_created) AS total_time
FROM
    report.rtat_reqs() AS ntr
    LEFT JOIN report.rtat_ship() AS nts ON ntr.rtr_id = nts.rts_req_id
    LEFT JOIN report.rtat_rec() AS ntr2 ON ntr.rtr_id = ntr2.rtre_req_id
WHERE
    nts.rts_date_created IS NOT NULL
    AND ntr2.rtre_date_created IS NOT NULL
    AND ntr.rtr_date_created >= (
        SELECT
            start_date
        FROM
            parameters)
    AND ntr.rtr_date_created < (
        SELECT
            end_date
        FROM
            parameters);

