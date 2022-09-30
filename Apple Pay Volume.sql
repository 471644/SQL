Easy

Visa
Visa is trying to analyze its Apply Pay partnership. Calculate the total transaction volume for each merchant where the transaction was performed via Apple Pay.

Output the merchant ID and the total transactions by merchant. For merchants with no Apple Pay transactions, output their total transaction volume as 0.

Display the result in descending order of transaction volume.

transactions Table:
Column Name	Type
merchant_id	integer
transaction_amount	integer
payment_method	varchar
transactions Example Input:
merchant_id	transaction_amount	payment_method
1	600	Contactless Chip
1	850	Apple Pay
1	500	Apple Pay
2	560	Magstripe
2	400	Samsung Pay
4	1200	apple pay
Example Output:
merchant_id	volume
1	1350
4	1200
2	0
Explanation
Merchant 1 has made two Apple Pay purchases totalling $1,350, Merchant 4 has completed one Apple Pay transaction costing $1,200, and Merchant 2 has not completed any Apple Pay transactions.

Solution
We merely need to take into account the volume of transactions made with Apple Pay for each merchant.

Here, we have 2 conditions to satisfy:

Where the payment method is Apple Pay, then obtain the total transactions.
Where the payment method is other than Apple Pay, then the total transaction is $0.
The CASE statements is one of the preferred functions in these circumstances.

SELECT
  merchant_id,
  payment_method
  CASE WHEN payment_method = 'Apple Pay' THEN transaction_amount
    ELSE 0 END AS volume
FROM transactions;
The outcome will resemble this. (Displaying data for merchant 1 in random order):

merchant_id	payment_method	volume
1	Contactless Chip	0
1	Apple Pay	850
1	Apple Pay	500
Since transactions via the Contactless Chip should not be counted against the Apple Pay volume, they are assigned with the value of 0 to represent having a volume of 0.

To adhere to the best practices in the industry, we can further refine our query by utilizing the LOWER function. It converts the original value of the string (say, "apPle PaY" or "Apple pay") into the lower-case value of the string ("apple pay").

SELECT
  merchant_id,
  CASE WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount
    ELSE 0 END AS volume
FROM transactions;
Click here to learn more about letter case functions in PostgreSQL.

The next step is determining each merchant’s total value of transactions.

We can use the SUM function with the GROUP BY clause to aggregate the total transaction volume for each merchant.

The output will then be sorted using ORDER BY along with the DESC option to sort the transaction volumes from highest to lowest.

SELECT
  merchant_id,
  SUM(<case statements>) AS volume
FROM transactions
GROUP BY merchant_id
ORDER BY volumn DESC;
Note: Except for those mentioned in the GROUP BY clause, all other columns in the SELECT clause must be accompanied by an aggregate function (SUM).

Output:

merchant_id	volume
1	1350
Solution:

SELECT
  merchant_id,
  SUM(CASE 
    WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount
    ELSE 0 END) AS volume
FROM transactions
GROUP BY merchant_id
ORDER BY volume DESC;
