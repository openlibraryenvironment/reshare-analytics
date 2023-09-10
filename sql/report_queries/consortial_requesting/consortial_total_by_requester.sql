WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    cv_requester_nice_name AS requester,
    count(*) AS count_of_requests
FROM
    report.consortial_view() AS cv
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
    cv.cv_requester_nice_name
ORDER BY
    cv.cv_requester_nice_name;

