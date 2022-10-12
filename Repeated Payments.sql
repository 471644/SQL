Hard

Stripe
Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.

Assumptions:

The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.
transactions Table:
Column Name	Type
transaction_id	integer
merchant_id	integer
credit_card_id	integer
amount	integer
transaction_timestamp	datetime
transactions Example Input:
transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp
1	101	1	100	09/25/2022 12:00:00
2	101	1	100	09/25/2022 12:08:00
3	101	1	100	09/25/2022 12:28:00
4	102	2	300	09/25/2022 12:00:00
6	102	2	400	09/25/2022 14:00:00
Example Output:
payment_count
1
Explanation
Within 10 minutes after Transaction 1, Transaction 2 is conducted at Merchant 1 using the same credit card for the same amount. This is the only instance of repeated payment in the given sample data.

Since Transaction 3 is completed after Transactions 2 and 1, each of which occurs after 20 and 28 minutes, respectively hence it does not meet the repeated payments' conditions. Whereas, Transactions 4 and 6 have different amounts.

Solution
Here are the steps to solve this question:

Bring together the transactions that are a part of the same group.
Work out the time difference between the groups' successive transactions.
Identify the identical transactions that took place within ten minutes of one another.
Step 1

For each transaction present in the transactions table, we will obtain the time of the most recent identical transaction. With the LAG window function, it is feasible. This function accesses the specified field’s values from the previous rows.

Run this query and we will explain more below.

SELECT 
  transaction_id
  merchant_id, 
  credit_card_id, 
  amount, 
  transaction_timestamp,
  LAG(transaction_timestamp) OVER (
    PARTITION BY merchant_id, credit_card_id, amount 
    ORDER BY transaction_timestamp
  ) AS previous_transaction 
FROM transactions;
Let's interpret the LAG function:

PARTITION BY clause separates the result’s rows by the unique merchant ID, credit card and payment.
Each partition is applied with a separate application of the LAG function, and the computation is restarted for each partition (merchant ID, credit card and payment).
Rows in each partition are sorted based on transaction_timestamp in the ORDER BY clause.
Showing 4 transactions worth $100 performed at Merchant ID 101 with credit card ID 1:

transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp	previous_transaction
1	101	1	100	09/25/2022 12:00:00	
2	101	1	100	09/25/2022 12:08:00	09/25/2022 12:00:00
3	101	1	100	09/25/2022 12:17:00	09/25/2022 12:28:00
5	101	1	100	09/25/2022 12:27:00	09/25/2022 13:17:00
Transaction ID 1 was the first of the series of payments, therefore it doesn't have a previous_transaction value from earlier transactions.
Transaction ID 2 has a previous_transaction of 09/25/2022 12:00:00 which is pulled from the transaction in transaction ID 1.
Can you follow the pattern of the records in the previous_transaction?

Step 2

Next, we should evaluate the difference in time between two consecutive identical transactions. We can simply subtract the previous_transaction values from the transaction_timestamp values as we now have the previous transaction time for each completed payment.

The following statement can be easily incorporated into the SELECT clause of the previous query.

transaction_timestamp - previous_transaction -- (Obtained from the LAG function)
AS time_difference
transaction_id	merchant_id	credit_card_id	amount	transaction_timestamp	previous_transaction	time_difference
1	101	1	100	09/25/2022 12:00:00		
2	101	1	100	09/25/2022 12:08:00	09/25/2022 12:00:00	"minutes":8
3	101	1	100	09/25/2022 12:28:00	09/25/2022 12:08:00	"minutes":20
5	101	1	100	09/25/2022 13:37:00	09/25/2022 12:28:00	"hours":1,"minutes":9
The time_difference field makes it clear that there is an 8-minute lag between the first and second transactions. We will now convert this field into minutes format so that we can easily filter them.

One of the best methods to achieve that is to use the EXTRACT function.

SELECT 
  merchant_id, 
  credit_card_id, 
  amount,
  transaction_timestamp,
  EXTRACT(EPOCH FROM transaction_timestamp - 
    LAG(transaction_timestamp) OVER(
      PARTITION BY merchant_id, credit_card_id, amount 
      ORDER BY transaction_timestamp)
  )/60 AS minute_difference 
FROM transactions;
EPOCH calculates the total number of seconds in a given interval.
To calculate the difference in minutes, we divide these seconds by 60 (1 minute = 60 seconds). For example, the time interval for transaction id 5 is 1 hour and 9 minutes. EPOCH calculates its value as 4140 seconds. By dividing it by 60, we arrive at 69 minutes.
This is how the outcome looks:

merchant_id	credit_card_id	amount	transaction_timestamp	minute_difference
101	1	100	09/25/2022 12:00:00	
101	1	100	09/25/2022 12:08:00	8
101	1	100	09/25/2022 12:28:00	20
101	1	100	09/25/2022 13:37:00	69
Step 3

The last thing we need to do is to gather all the identical transactions which occurred within a 10-minute window.

To do that, we must first convert the query into a common table expression (CTE). Then, we will filter the records using the WHERE clause for transactions a 10-minute or lesser window.

Additionally, the COUNT function allows us to count the filtered records.

WITH payments AS (
  -- enter the previous query here
) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10;
Output for merchant ID 1:

payment_count
1
Now, we will eliminate the unnecessary columns from the SELECT clause since they were only there for exploration purposes.

That's it! We have our final query :)

Solution:

WITH payments AS (
  SELECT 
    merchant_id, 
    EXTRACT(EPOCH FROM transaction_timestamp - 
      LAG(transaction_timestamp) OVER(
        PARTITION BY merchant_id, credit_card_id, amount 
        ORDER BY transaction_timestamp)
    )/60 AS minute_difference 
  FROM transactions) 

SELECT COUNT(merchant_id) AS payment_count
FROM payments 
WHERE minute_difference <= 10;
