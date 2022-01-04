# Core Requesting Statistics

## Report details

**Brief description**: This report provides counts of total requests placed and total request outcomes: cancelled, unfilled, or received. Note that requests that are still in progress do not yet have an outcome and are not included in this report. For that reason, the total count of outcomes will not equal the total count of requests.

This report generates data in the following format:

|requester|reqs|cancelled|unfilled|received|filled\_ratio|
|------------|--------|----------|----------|----------|------------|
|East University|253|6|63|176|0.69|
|West University|3448|20|1018|2246|0.63|

## Data dictionary
* **Requester**: The institution affiliated with the patron who placed the request.
* **Reqs**: A count of valid requests placed by the institution's patrons. Note that this count does not currently include requests that were unable to be validated, including requests with invalid patron IDs.
* **Cancelled**: A count of requests that have entered the "Cancelled" state. These requests were manually cancelled by the requesting library.
* **Unfilled**: A count of requests that have entered the "End of rota" state. These requests were unable to be be supplied by any of the candidate suppliers.
* **Received**: A count of requests that have entered the "In local circulation process" state. When evaluating requesting, the primary measure of success is that the item arrived at the requesting library and was received in the ReShare system. Successful return to the supplying library is captured in the Core Supplying Statistics report. Note that received requests may be in a variety of states at the time of reporting, including "Awaiting return shipping," "Complete," "Filled locally," "In local circulation process," "Overdue," or "Return shipped." 
