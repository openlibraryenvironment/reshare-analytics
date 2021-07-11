SELECT
    cv_directory_id_fk AS supplier,
    count(*) as count_of_requests
FROM
    reshare_derived.consortial_view cv
GROUP BY
    cv.cv_directory_id_fk
ORDER BY
    cv.cv_directory_id_fk;