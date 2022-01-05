# Requesting Ratio Statistics

## Report Details

Brief description: This report provides a count of total requests placed, total requests supplied, and calculates the lending-to-borrowing ratio.  ReShare compares this actual lending-to-borrowing ratio to the library's goal ratio when buliding the rota for a request.

This report generates data in the following format:

|institution|lending\_requests|borrowing\_requests|lending\_to\_borrowing\_request\_ratio|
|------------|----------|----------|----------|
|East University| 348 | 256 | 1.36 |
|West University| 2793 | 3492 | 0.80 |

## Data Dictionary
- **Institution**: Name of Institution.
- **Lending Requests**: Total count of lending requests assigned.

QUESTION:  Is that true?  Lending requests actually sent to that supplier? Including those the autoresponder says cannot supply? Or some other subset of that total, i.e. only the requests actually filled/shipped?
- **Borrowing Requests**: Total count of borrowing requests created.
- **Lending to Borrowing Request Ratio**:  Lending Requests divided by Borrowing Requests 
