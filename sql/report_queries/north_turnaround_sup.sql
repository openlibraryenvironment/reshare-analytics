SELECT
    'NORTH' AS supplier,
    avg(date_diff) / 86400 AS avg_days_to_fill,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_to_fill
FROM (
    SELECT
        nss.ss_date_created AS t_start,
        nss2.ss_date_created AS t_end,
        nss.ss_req_id,
        nss2.ss_req_id,
        nss.ss_from_status AS one_from,
        nss.ss_to_status AS one_to,
        nss2.ss_from_status AS two_from,
        nss2.ss_to_status AS two_to,
        nss.ss_message AS one_message,
        nss2.ss_message AS two_message,
        ((nss2.ss_date_created - nss.ss_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_sup_stats nss,
        reshare_derived.north_sup_stats nss2
    WHERE
        nss.ss_req_id = nss2.ss_req_id
        AND (nss.ss_from_status IS NULL
            AND nss.ss_to_status = 'RES_IDLE'
            AND nss2.ss_from_status = 'RES_AWAIT_PICKING'
            AND nss2.ss_to_status = 'RES_AWAIT_SHIP')) AS data;

SELECT
    'NORTH' AS supplier,
    avg(date_diff) / 86400 AS avg_days_to_ship,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_to_ship
FROM (
    SELECT
        nss.ss_date_created AS t_start,
        nss2.ss_date_created AS t_end,
        nss.ss_req_id,
        nss2.ss_req_id,
        nss.ss_from_status AS one_from,
        nss.ss_to_status AS one_to,
        nss2.ss_from_status AS two_from,
        nss2.ss_to_status AS two_to,
        nss.ss_message AS one_message,
        nss2.ss_message AS two_message,
        ((nss2.ss_date_created - nss.ss_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_sup_stats nss,
        reshare_derived.north_sup_stats nss2
    WHERE
        nss.ss_req_id = nss2.ss_req_id
        AND (nss.ss_from_status = 'RES_AWAIT_PICKING'
            AND nss.ss_to_status = 'RES_AWAIT_SHIP'
            AND nss2.ss_from_status = 'RES_AWAIT_SHIP'
            AND nss2.ss_to_status = 'RES_ITEM_SHIPPED')) AS data;

SELECT
    'NORTH' AS supplier,
    avg(date_diff) / 86400 AS avg_days_to_receipt,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_to_receipt
FROM (
    SELECT
        nsts.stst_date_created AS t_start,
        nsts2.stst_date_created AS t_end,
        nsts.stst_req_id,
        nsts2.stst_req_id,
        nsts.stst_from_status AS one_from,
        nsts.stst_to_status AS one_to,
        nsts2.stst_from_status AS two_from,
        nsts2.stst_to_status AS two_to,
        nsts.stst_message AS one_message,
        nsts2.stst_message AS two_message,
        ((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_sup_tat_stats nsts,
        reshare_derived.north_sup_tat_stats nsts2
    WHERE
        nsts.stst_req_id = nsts2.stst_req_id
        AND (nsts.stst_from_status = 'RES_AWAIT_SHIP'
            AND nsts.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_message = 'Shipment received by requester')) AS data;

SELECT
    'NORTH' AS supplier,
    avg(date_diff) / 86400 AS avg_days_total,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) / 86400 AS med_days_total,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_sup_tat_stats nsts, reshare_derived.north_sup_tat_stats nsts2
        WHERE
            nsts.stst_req_id = nsts2.stst_req_id
            AND (nsts.stst_from_status IS NULL
                AND nsts.stst_to_status = 'RES_IDLE'
                AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_message = 'Shipment received by requester')
            AND (((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) / 3600) < 48), 0) AS reqs_under_48,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_sup_tat_stats nsts, reshare_derived.north_sup_tat_stats nsts2
        WHERE
            nsts.stst_req_id = nsts2.stst_req_id
            AND (nsts.stst_from_status IS NULL
                AND nsts.stst_to_status = 'RES_IDLE'
                AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_message = 'Shipment received by requester')
            AND (((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) / 3600) > 48
    AND (((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) / 3600) < 72), 0) AS reqs_btwn_48_72,
    coalesce((
        SELECT
            count(*)
        FROM reshare_derived.north_sup_tat_stats nsts, reshare_derived.north_sup_tat_stats nsts2
        WHERE
            nsts.stst_req_id = nsts2.stst_req_id
            AND (nsts.stst_from_status IS NULL
                AND nsts.stst_to_status = 'RES_IDLE'
                AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
                AND nsts2.stst_message = 'Shipment received by requester')
            AND (((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) / 3600) > 72), 0) AS reqs_over_72
FROM (
    SELECT
        nsts.stst_date_created AS t_start,
        nsts2.stst_date_created AS t_end,
        nsts.stst_req_id,
        nsts2.stst_req_id,
        nsts.stst_from_status AS one_from,
        nsts.stst_to_status AS one_to,
        nsts2.stst_from_status AS two_from,
        nsts2.stst_to_status AS two_to,
        nsts.stst_message AS one_message,
        nsts2.stst_message AS two_message,
        ((nsts2.stst_date_created - nsts.stst_date_created) / 1000000) AS date_diff
    FROM
        reshare_derived.north_sup_tat_stats nsts,
        reshare_derived.north_sup_tat_stats nsts2
    WHERE
        nsts.stst_req_id = nsts2.stst_req_id
        AND (nsts.stst_from_status IS NULL
            AND nsts.stst_to_status = 'RES_IDLE'
            AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_message = 'Shipment received by requester')) AS data;

-- Have not found the base URL for a tenant anywhere in the database consistently across all tenants.
SELECT
    nstr.str_hrid AS request_id,
    concat('[RESHARE URL]', '/request/requests/view/', nstr.str_id, '/flow') AS request_url,
    s.sym_symbol AS requester,
    nstr.str_title AS title,
    nstr.str_call_number AS call_number,
    nstr.str_barcode AS barcode,
    to_timestamp(nsta.sta_date_created / 1000000) AS assigned,
    to_timestamp(nstf.stf_date_created / 1000000) AS filled,
    to_timestamp(nsts.sts_date_created / 1000000) AS shipped,
    to_timestamp(nstre.stre_date_created / 1000000) AS received,
    (nstf.stf_date_created - nsta.sta_date_created) / 3600000000 AS time_to_filled_hours,
    (nsts.sts_date_created - nsta.sta_date_created) / 3600000000 AS time_to_shipped_hours,
    (nstre.stre_date_created - nsta.sta_date_created) / 3600000000 AS time_to_received_hours,
    (nstre.stre_date_created - nsta.sta_date_created) / 3600000000 AS total_time_hours
FROM
    reshare_derived.north_stat_reqs nstr
    LEFT JOIN reshare_derived.north_stat_assi nsta ON nstr.str_id = nsta.sta_req_id
    LEFT JOIN reshare_derived.north_stat_fill nstf ON nstr.str_id = nstf.stf_req_id
    LEFT JOIN reshare_derived.north_stat_ship nsts ON nstr.str_id = nsts.sts_req_id
    LEFT JOIN reshare_derived.north_stat_rec nstre ON nstr.str_id = nstre.stre_req_id
    LEFT JOIN reshare_reshare_north_rs.symbol s ON s.sym_id = nstr.str_requester
WHERE
    nsts.sts_date_created IS NOT NULL
    AND nstre.stre_date_created IS NOT NULL;