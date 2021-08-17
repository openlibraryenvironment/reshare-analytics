-- Have not found the base URL for a tenant anywhere in the database consistently across all tenants.
SELECT
    ntr.rtr_hrid AS request_id,
    concat('[RESHARE URL]', '/request/requests/view/', ntr.rtr_id, '/flow') AS request_url,
    s.sym_symbol AS supplier,
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
    reshare_derived.rtat_reqs ntr
    LEFT JOIN reshare_derived.rtat_ship nts ON ntr.rtr_id = nts.rts_req_id
    LEFT JOIN reshare_derived.rtat_rec ntr2 ON ntr.rtr_id = ntr2.rtre_req_id
    LEFT JOIN reshare_rs.symbol s ON s.sym_id = ntr.rtr_supplier
WHERE
    nts.rts_date_created IS NOT NULL
    AND ntr2.rtre_date_created IS NOT NULL;

