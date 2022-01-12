WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    cv_directory_id_fk AS supplier,
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
    cv.cv_directory_id_fk
ORDER BY
    cv.cv_directory_id_fk;

