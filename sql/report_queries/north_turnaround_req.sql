SELECT
    'NORTH' AS requestor,
    avg(date_diff) / 86400 AS avg_days_to_ship,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_to_ship
FROM (
    SELECT
        nrs.rs_date_created AS t_start,
        nrs2.rs_date_created AS t_end,
        nrs.rs_req_id,
        nrs2.rs_req_id,
        nrs.rs_to_status,
        nrs2.rs_to_status,
        ((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_req_stats nrs,
        reshare_derived.north_req_stats nrs2
    WHERE
        nrs.rs_req_id = nrs2.rs_req_id
        AND (nrs.rs_to_status = 'REQ_VALIDATED'
            AND nrs2.rs_to_status = 'REQ_SHIPPED')) AS data;

SELECT
    'NORTH' AS requestor,
    avg(date_diff) / 86400 AS avg_days_to_receipt,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_to_receipt
FROM (
    SELECT
        nrs.rs_date_created AS t_start,
        nrs2.rs_date_created AS t_end,
        nrs.rs_req_id,
        nrs2.rs_req_id,
        nrs.rs_to_status,
        nrs2.rs_to_status,
        ((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_req_stats nrs,
        reshare_derived.north_req_stats nrs2
    WHERE
        nrs.rs_req_id = nrs2.rs_req_id
        AND (nrs.rs_to_status = 'REQ_SHIPPED'
            AND nrs2.rs_to_status = 'REQ_CHECKED_IN')) AS data;

SELECT
    'NORTH' AS requestor,
    avg(date_diff) / 86400 AS avg_days_total,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_total,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_req_stats nrs, reshare_derived.north_req_stats nrs2
        WHERE
            nrs.rs_req_id = nrs2.rs_req_id
            AND (nrs.rs_to_status = 'REQ_VALIDATED'
                AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
            AND (((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) / 3600) < 48), 0) AS reqs_under_48,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_req_stats nrs, reshare_derived.north_req_stats nrs2
        WHERE
            nrs.rs_req_id = nrs2.rs_req_id
            AND (nrs.rs_to_status = 'REQ_VALIDATED'
                AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
            AND (((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) / 3600) > 48
    AND (((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) / 3600) < 72), 0) AS reqs_btwn_48_72,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_req_stats nrs, reshare_derived.north_req_stats nrs2
        WHERE
            nrs.rs_req_id = nrs2.rs_req_id
            AND (nrs.rs_to_status = 'REQ_VALIDATED'
                AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
            AND (((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) / 3600) > 72), 0) AS reqs_over_72
FROM (
    SELECT
        nrs.rs_date_created AS t_start,
        nrs2.rs_date_created AS t_end,
        nrs.rs_req_id,
        nrs2.rs_req_id,
        nrs.rs_to_status,
        nrs2.rs_to_status,
        ((nrs2.rs_date_created - nrs.rs_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_req_stats nrs,
        reshare_derived.north_req_stats nrs2
    WHERE
        nrs.rs_req_id = nrs2.rs_req_id
        AND (nrs.rs_to_status = 'REQ_VALIDATED'
            AND nrs2.rs_to_status = 'REQ_CHECKED_IN')) AS data;

-- Have not found the base URL for a tenant anywhere in the database consistently across all tenants.
SELECT
    ntr.rtr_hrid AS request_id,
    concat('[RESHARE URL]', '/request/requests/view/', ntr.rtr_id, '/flow') AS request_url,
    s.sym_symbol AS supplier,
    ntr.rtr_title AS title,
    ntr.rtr_call_number AS call_number,
    ntr.rtr_barcode AS barcode,
    to_timestamp(ntr.rtr_date_created / 1000000) AS created,
    to_timestamp(nts.rts_date_created / 1000000) AS shipped,
    to_timestamp(ntr2.rtre_date_created / 1000000) AS received,
    (nts.rts_date_created - ntr.rtr_date_created) / 3600000000 AS time_to_shipment_hours,
    (ntr2.rtre_date_created - nts.rts_date_created) / 3600000000 AS time_to_received_hours,
    (ntr2.rtre_date_created - ntr.rtr_date_created) / 3600000000 AS total_time_hours
FROM
    reshare_derived.north_rtat_reqs ntr
    LEFT JOIN reshare_derived.north_rtat_ship nts ON ntr.rtr_id = nts.rts_req_id
    LEFT JOIN reshare_derived.north_rtat_rec ntr2 ON ntr.rtr_id = ntr2.rtre_req_id
    LEFT JOIN reshare_reshare_north_rs.symbol s ON s.sym_id = ntr.rtr_supplier
WHERE
    nts.rts_date_created IS NOT NULL
    AND ntr2.rtre_date_created IS NOT NULL;