Hard

Amazon
Amazon Web Services (AWS) is powered by fleets of servers. Senior management has requested data-driven solutions to optimize server usage.

Write a query that calculates the total time that the fleet of servers was running. The output should be in units of full days.

Assumptions:

Each server might start and stop several times.
The total time in which the server fleet is running can be calculated as the sum of each server's uptime.
server_utilization Table:
Column Name	Type
server_id	integer
status_time	timestamp
session_status	string
server_utilization Example Input:
server_id	status_time	session_status
1	08/02/2022 10:00:00	start
1	08/04/2022 10:00:00	stop
2	08/17/2022 10:00:00	start
2	08/24/2022 10:00:00	stop
Example Output:
total_uptime_days
21
Explanation
In the example output, the combined uptime of all the servers (from each start time to stop time) totals 21 full days.

Solution
This is a tough task. Let's zoom out and work backwards to structure our approach.

Breakdown

Calculate total uptime for the fleet of servers as a sum of individual server uptimes.
Calculate individual server uptimes as a pre-requisite for the previous step.
In order to calculate individual server uptimes, we need the start time and stop time to be in different columns. That way, we can perform row-wise subtractions of stop_time - start_time.
Ensure that our results are output in integer units of full days.
The solution below is broken down into smaller steps.

Step 1: Start and Stop times Starting from the end, the first thing we should do is obtain the start and stop times in different columns.

We'll alias status_time as start_time, and then use the window function LEAD to find the stop times, which correspond to the timestamps for each successive status after the current one. We'll make sure to partition this LEAD for each individual server and order our results by the status_time.

The full query should look like this:

SELECT
  server_id,
  session_status,
  status_time AS start_time,
  LEAD(status_time) OVER (
    PARTITION BY server_id
    ORDER BY status_time) AS stop_time
FROM server_utilization;
Click here to learn more about the LEAD function.

Let's take a step back to make sure we understand the output of this query. The output rows should look like this:

server_id	session_status	start_time	stop_time
1	start	08/02/2022 10:00:00	08/04/2022 10:00:00
1	start	08/13/2022 10:00:00	08/13/2022 19:00:00
We have the server IDs along with their stop and start times! That means we're ready to move on.

Step 2: Individual Uptimes Now, let's wrap the above query in a Common Table Expression (CTE) so we can reuse the results later. Click here to learn more about CTEs.

We are close to finishing this – all we have to do is assemble our main SELECT statement. First, we need to simply calculate the individual uptimes by subtracting start_time from stop_time. Then, we'll SUM the individual server times, and convert the result to days.

Step 3: Converting to full days By summing up the uptimes as an interval type, we could obtain multiple date parts in our results. For example, the output could be: "days":2, "hours":30. In this case, if we extracted just the days, we would obtain 2 as a result (instead of 3).

To combat this issue, we'll use the function JUSTIFY_HOURS to convert any value above 24 hours into units of full days. You can learn more about JUSTIFY_HOURS here.

Now, we can extract the number of full days by using DATE_PART function. We should arrive at the following code:

SELECT
  DATE_PART('days', JUSTIFY_HOURS(SUM(stop_time - start_time))) AS total_uptime_days
FROM running_time;
Finally, we want to make sure that we only look at the uptimes for rows that start server sessions, and that we exclude rows where the stop time is a NULL value.

The query looks like this:

SELECT
  DATE_PART('days', JUSTIFY_HOURS(SUM(stop_time - start_time))) AS total_uptime_days
FROM running_time
WHERE session_status = 'start'
  AND stop_time IS NOT NULL;
Congratulations, you did it!

Solution

WITH running_time 
AS (
  SELECT
    server_id,
    session_status,
    status_time AS start_time,
    LEAD(status_time) OVER (
      PARTITION BY server_id
      ORDER BY status_time) AS stop_time
  FROM server_utilization
)

SELECT
  DATE_PART('days', JUSTIFY_HOURS(SUM(stop_time - start_time))) AS total_uptime_days
FROM running_time
WHERE session_status = 'start'
  AND stop_time IS NOT NULL;
