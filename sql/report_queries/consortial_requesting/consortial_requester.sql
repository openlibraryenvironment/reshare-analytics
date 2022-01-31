WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    cv_nice_requester AS requester,
    cv_supplier AS supplier,
    count(*) AS count_of_requests
FROM
    reshare_derived.consortial_view cv
WHERE
    cv.cv_date_created >= (
        SELECT
            start_date
        FROM
            parameters)
    AND cv.cv_date_created < (
        SELECT
            end_date
        FROM
            parameters)
GROUP BY
    cv.cv_nice_requester,
    cv.cv_supplier
ORDER BY
    cv.cv_nice_requester;

