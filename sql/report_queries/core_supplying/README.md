# Core Supplying Statistics

## Report Details

Brief description: This report provides counts of total requests  received, cancelled, filled, and shipped.  In addition, fill and supply rates are calculated.  Note that requests that are still in progress at the supplier do not have an outcome and will not be included in this report. For that reason, the total count of shipped, unfilled, and cancelled will not equal the total count of requests received.

This report generates data in the following format:

|supplier|reqs|unfilled|filled|shipped|cancels|filled\_ratio|supplied\_ratio|
|------------|--------|----------|----------|----------|------------|------------|------------|
|West University|72|26|20|14|12|0.278|0.19|
|East University|2|0|2|2|0|1|1|

## Data dictionary
* **Supplier**: The institution that a request has been sent to. 
* **Reqs**: A count of valid requests sent to that institution during the time period specified. 
* **Unfilled**: A count of requests to which the supplier responded "cannot supply" (Q: does this include requests that autoresponder replied to? )  
* **Filled**: A count of requests for which the requested item was retrieved from the supplier's collection, whether or not it was actually shipped to the requesting library or patron. (Compare with "Shipped") 
* **Shipped**: A count of requests for which the requested item was shipped to the requesting library or patron. (Compare with "Filled:) 
* **Cancels**: A count of requests that entered the "Cancelled" state after being received by the supplier. These requests were manually cancelled by the requesting library.  
* **Filled Ratio**: Ratio of "Filled" requests to total "Reqs" count. 
* **Supplied Ratio**: Ratio of "Shipped" requests to total "Reqs" count.
