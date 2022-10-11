Hard

Visa
Say you have access to all the transactions for a given merchant account. Write a query to print the cumulative balance of the merchant account at the end of each day, with the total balance reset back to zero at the end of the month. Output the transaction date and cumulative balance.

transactions Table:
Column Name	Type
transaction_id	integer
type	string ('deposit', 'withdrawal')
amount	decimal
transaction_date	timestamp
transactions Example Input:
transaction_id	type	amount	transaction_date
19153	deposit	65.90	07/10/2022 10:00:00
53151	deposit	178.55	07/08/2022 10:00:00
29776	withdrawal	25.90	07/08/2022 10:00:00
16461	withdrawal	45.99	07/08/2022 10:00:00
77134	deposit	32.60	07/10/2022 10:00:00
Example Output:
transaction_date	balance
07/08/2022 12:00:00	106.66
07/10/2022 12:00:00	205.16
To get cumulative balance of 106.66 on 07/08/2022 12:00:00, we take the deposit of 178.55 and minus against two withdrawals 25.90 and 45.99.

Solution
To start off, it is much easier if we start to solve the problem from the end - i.e. we want to have daily cumulative balances that reset every month. Thus, to obtain two different granularities of transaction_date column we can utilize DATE_TRUNC function.

In order to obtain balances instead of solely transaction values, we can use CASE to assign positive sign to deposit and negative to withdrawals, and then just sum and group the values on a daily level (there might be multiple transactions during the day).

As the next step, we utilize SUM with a window function and calculate the sum partitioning by month - this makes sure that the cumulative sum is set to zero each month.

WITH daily_balances AS (
  SELECT
    DATE_TRUNC('day', transaction_date) AS transaction_day,
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    SUM(CASE WHEN type = 'deposit' THEN amount
      WHEN type = 'withdrawal' THEN -amount END) AS balance
  FROM transactions
  GROUP BY 
    DATE_TRUNC('day', transaction_date),
    DATE_TRUNC('month', transaction_date))

SELECT
  transaction_day,
  SUM(balance) OVER (
    PARTITION BY transaction_month
    ORDER BY transaction_day) AS balance
FROM daily_balances
ORDER BY transaction_day;
