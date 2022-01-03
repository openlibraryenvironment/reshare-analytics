# Core Requesting Statistics

## Report Details

Brief description: This report provides base numbers of received, cancelled, filled along with fill rates for materials requested.

This report generates data in the following format:

|requester|reqs|cancelled|unfilled|received|filled\_ratio|
|------------|--------|----------|----------|----------|------------|
|reshare_east|80|12|27|12|0.15|
|reshare_west|5|0|1|0|0|

These terms are defined as follows:
* **Requester**: The institution affiliated with the patron who placed the request.
* **Reqs**: The total number of valid requests placed by the institution's patrons. Note that this count does not currently include requests that were unable to be validated, including requests with invalid patron IDs.
* **Cancelled**: Requests that have entered the "Cancelled" state. These requests were manually cancelled by the requesting library.
* **Unfilled**: Requests that have entered the "End of rota" state. These requests were unable to be be supplied by any of the candidate suppliers.
* **Received**: Requests where the item was received by the requesting library. Note that received requests may be in a variety of states, including "Awaiting return shipping," "Complete," "Filled locally," "In local circulation process," "Overdue," or "Return shipped." When calcuating received requests, the primary measure of success is that the item arrived at the requesting library and was received in the ReShare system. Successful return to the supplying library is captured in the Core Supplying Statistics report.
