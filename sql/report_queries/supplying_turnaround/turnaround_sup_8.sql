-- Have not found the base URL for a tenant anywhere in the database consistently across all tenants.
WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    nstr.str_supplier AS supplier,
    nstr.str_hrid AS request_id,
    concat('[RESHARE URL]', '/request/requests/view/', nstr.str_id, '/flow') AS request_url,
    s.sym_symbol AS requester,
    nstr.str_title AS title,
    nstr.str_call_number AS call_number,
    nstr.str_barcode AS barcode,
    nsta.sta_date_created AS assigned,
    nstf.stf_date_created AS filled,
    nsts.sts_date_created AS shipped,
    nstre.stre_date_created AS received,
    (nstf.stf_date_created - nsta.sta_date_created) AS time_to_fill,
    (nsts.sts_date_created - nsta.sta_date_created) AS time_to_ship,
    (nstre.stre_date_created - nsta.sta_date_created) AS time_to_receipt,
    (nstre.stre_date_created - nsta.sta_date_created) AS total_time
FROM
    reshare_derived.stat_reqs nstr
    LEFT JOIN reshare_derived.stat_assi nsta ON nstr.str_id = nsta.sta_req_id
    LEFT JOIN reshare_derived.stat_fill nstf ON nstr.str_id = nstf.stf_req_id
    LEFT JOIN reshare_derived.stat_ship nsts ON nstr.str_id = nsts.sts_req_id
    LEFT JOIN reshare_derived.stat_rec nstre ON nstr.str_id = nstre.stre_req_id
    LEFT JOIN reshare_rs.symbol s ON s.sym_id = nstr.str_requester
WHERE
    nsts.sts_date_created IS NOT NULL
    AND nstre.stre_date_created IS NOT NULL
    AND nsta.sta_date_created >= (
        SELECT
            start_date
        FROM
            parameters)
    AND nsta.sta_date_created < (
        SELECT
            end_date
        FROM
            parameters);

