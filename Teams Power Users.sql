Easy

Microsoft
Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending count of the messages.

Assumption:

No two users has sent the same number of messages in August 2022.
messages Table:
Column Name	Type
message_id	integer
sender_id	integer
receiver_id	integer
content	varchar
sent_date	datetime
messages Example Input:
message_id	sender_id	receiver_id	content	sent_date
901	3601	4500	You up?	08/03/2022 00:00:00
902	4500	3601	Only if you're buying	08/03/2022 00:00:00
743	3601	8752	Let's take this offline	06/14/2022 00:00:00
922	3601	4500	Get on the call	08/10/2022 00:00:00
Example Output:
sender_id	message_count
3601	2
4500	1

Solution
Before we can find the top 2 Microsoft Teams power users, we need to know how many messages were sent by each Microsoft Teams user in August 2022. We will refer to these users as "senders".

First, we extract the month and year from the sent_date field. Then, we count the messages for each sender and group them based on the sender_id:

SELECT 
  sender_id,
  COUNT(message_id) AS count_messages
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
  AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id;
Here over here to learn more about the EXTRACT function, and here to learn about the GROUP BY clause.

The output from the above query should look something like this:

sender_id	count_messages
2520	3
3601	4
4500	1
Because we're operating under the assumption that no two users can send the same number of messages in August 2022, we know that each number in the count_messages column will only appear once. That means that a simple ORDER BY clause in descending order will give us the result we need. We then use a LIMIT clause to pull only the top 2 results, and we're done!

Solution:

SELECT 
  sender_id,
  COUNT(message_id) AS count_messages
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
  AND EXTRACT(YEAR FROM sent_date) = '2022'
GROUP BY sender_id
ORDER BY count_messages DESC
LIMIT 2; 