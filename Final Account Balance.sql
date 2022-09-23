Easy

Paypal
Given a table of bank deposits and withdrawals, return the final balance for each account.

Assumption:

All the transactions performed for each account are present in the table; no transactions are missing.
transactions Table:
Column Name	Type
transaction_id	integer
account_id	integer
transaction_type	varchar
amount	decimal
transactions Example Input:
transaction_id	account_id	transaction_type	amount
123	101	Deposit	10.00
124	101	Deposit	20.00
125	101	Withdrawal	5.00
126	201	Deposit	20.00
128	201	Withdrawal	10.00
Example Output:
account_id	final_balance
101	25.00
201	10.00
Explanation:
In total, $30.00 were deposited to account 101, and $5.00 were withdrawn. Therefore, the final balance will be $30.00-$5.00 = $25.00

--- My Solution ------
-- No missing values
-- only two types deposit and withdrawals
WITH intermediate AS 
  (
    SELECT
      transactions.account_id,
      transactions.transaction_type,
      SUM(transactions.amount) AS amt
    FROM
      transactions
    GROUP BY
      1,2
    ORDER BY
      1,2
  )
SELECT 
  int_1.account_id,
  (int_1.amt-int_2.amt) AS final_balance
FROM
  (
    SELECT 
      intermediate.account_id,
      intermediate.amt
    FROM
      intermediate 
    WHERE
      intermediate.transaction_type = 'Deposit'
  ) AS int_1 
JOIN  
    (
    SELECT 
      intermediate.account_id,
      intermediate.amt
    FROM
      intermediate 
    WHERE
      intermediate.transaction_type = 'Withdrawal'
  ) AS int_2
ON  int_1.account_id = int_2.account_id

Solution
This problem is all about knowing how to manipulate the relevant fields. The amount column will help us determine the final balances of each account. But we can't simply use the SUM function here; the tricky part is telling SQL when to subtract the withdrawals.

We can accomplish this by negating the amount of each withdrawal based on the transaction_type column value using a conditional CASE WHEN statement. For deposits, we'll output the amount itself, and for withdrawals, we'll output the negated amount (-1 * amount).

The query will look something like this:

SELECT
  account_id,
  transaction_type,
  CASE
    WHEN transaction_type = 'Deposit' THEN amount
    ELSE -amount END AS balance_amount
FROM transactions;
Showing 3 random output records for account 101:

account_id	transaction_type	balance_amount
101	Deposit	10.00
101	Deposit	20.00
101	Withdrawal	-5.00
Now that the withdrawals with be subtracted, we can aggregate the final balances using the SUM function. We'll GROUP BY the account_id so that the sums (which represent the final balances) will be calculated for each account separately.

These aggregation steps look like this:

SELECT
  account_id,
  SUM(<above CASE Statement>) AS final_balance
FROM transactions
GROUP BY account_id;
Output:

account_id	final_balance
101	25.00
Full Solution:

SELECT
  account_id,
  SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE -amount END) AS final_balance
FROM transactions
GROUP BY account_id;