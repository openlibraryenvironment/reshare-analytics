SELECT
    cv_requester AS requester,
    count(*) as count_of_requests
FROM
    reshare_derived.consortial_view cv
GROUP BY
    cv.cv_requester
ORDER BY
    cv.cv_requester;