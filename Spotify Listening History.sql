Medium

Spotify
You are given a songs_history table that keeps track of users' listening history on Spotify. The songs_weekly table tracks how many times users listened to each song for all days between August 1 and August 7, 2022.

Write a query to show the user ID, song ID, and the number of times the user has played each song as of August 4, 2022. We'll refer to the number of song plays as song_plays. The rows with the most song plays should be at the top of the output.

Assumption:

The songs_history table holds data that ends on July 31, 2022. Output should include the historical data in this table.
There may be a new user in the weekly table who is not present in the history table.
A user may listen to a song for the first time, in which case no existing (user_id, song_id) user-song pair exists in the history table.
A user may listen to a specific song multiple times in the same day.
songs_history Table:
Column Name	Type
history_id	integer
user_id	integer
song_id	integer
song_plays	integer
songs_history Example Input:
history_id	user_id	song_id	song_plays
10011	777	1238	11
12452	695	4520	1
songs_weekly Table:
Column Name	Type
user_id	integer
song_id	integer
listen_time	datetime
songs_weekly Example Input:
user_id	song_id	listen_time
777	1238	08/01/2022 12:00:00
695	4520	08/04/2022 08:00:00
125	9630	08/04/2022 16:00:00
695	9852	08/07/2022 12:00:00
Example Output:
user_id	song_id	song_plays
777	1238	12
695	4520	2
125	9630	1
Up to August 4, 2022, user_id 777 has listened to the song_id 1238 12 times. user_id 695 with song_id 9852 is excluded from the output because their listening time on August 8, 2022 is not within the the question's requirement (which is up to August 4, 2022 only).

Solution
Let's break this problem into three steps.

Create a custom weekly dataset that keeps track of song plays using the songs_weekly table. Then, get all user-song pairs on or before August 4, 2022, and establish a count of song plays for each user-song pair.
Merge this custom dataset with songs_history table.
Aggregate the song plays for each user-song pair and sort in descending order.
Take note of the values in the listen_time column in the songs_weekly table. The data shows timestamps along with dates. We'll group our results based on users and songs to get the song plays for each user-song pair using the COUNT function.

The query should look something like this:

SELECT
  user_id,
  song_id,
  COUNT(song_id) AS song_plays
FROM songs_weekly
WHERE listen_time <= '08/04/2022 23:59:59'
GROUP BY user_id, song_id;
Query uutput (note that we're showing 2 random records here):

user_id	song_id	song_plays
777	1238	11
695	4520	1
It is critical to include the time 23:59:59 in addition to the deadline date (August 4, 2022) in theWHEREclause, because it tells PostgreSQL to include plays from the entire day. If we failed to include a timestamp, PostgreSQL would pull all rows until 08/04/2022 00:00:00" (midnight) and we wouldn't see any data from the day of August 4, 2022 itself.

Next, we combine this custom weekly dataset with the history table. We'll use UNION ALL to combine our results. Click here to learn more about UNION ALL.

Now, our query should look like this:

SELECT
 user_id,
 song_id,
 song_plays
FROM songs_history
UNION ALL -- Merging of history table with custom weekly dataset
SELECT
 user_id,
 song_id,
 COUNT(song_id) AS song_plays
FROM songs_weekly
WHERE listen_time <= '08/04/2022 23:59:59'
GROUP BY user_id, song_id;
First 3 rows of the output:

user_id	song_id	song_plays
777	1238	11
695	4520	1
695	4520	1
It's important that we use UNION ALL, and not UNION, to get the correct result here. When the UNION operator were applied instead of UNION ALL in the above query, we'd get this result instead:

user_id	song_id	song_plays
777	1238	11
695	4520	1
Look closely. There is a missing row for user ID 695 who listened to the song ID 4520. How did this happen?

User ID 695 has listened to the song ID 4520 once already (see the songs_history table). Based on our custom weekly dataset, this user has listened to the same song once between the period of August 1 and August 4, 2022 . UNION considers one of the instance a duplicate and removes it, whereas UNION ALL does not. That is why UNION ALL plays a key role here. Click here to learn more about the difference between UNION and UNION ALL.

Both the history and custom weekly tallies are now available for us in a single query. We will wrap this code into a subquery to use the output later for more operations. You can also use a Common Table Expression (CTE).

Now, all that's left to do is use the SUM function to aggregate the number of song plays for each user-song pair.

SELECT
  user_id,
  song_id,
  SUM(song_plays) AS song_plays
FROM (
-- Enter previous query using UNION ALL here
) AS history
GROUP BY user_id, song_id
ORDER BY song_plays DESC;
2 rows from the output:

user_id	song_id	song_plays
777	1238	12
695	4520	2
Great job on this!

Solution #1 Using Subquery

SELECT
  user_id,
  song_id,
  SUM(song_plays) AS song_plays
FROM (
SELECT
  user_id,
  song_id,
  song_plays
FROM songs_history
UNION ALL
SELECT
  user_id,
  song_id,
  COUNT(song_id) AS song_plays
FROM songs_weekly
WHERE listen_time <= '08/04/2022 23:59:59'
GROUP BY user_id, song_id) AS report
GROUP BY user_id, song_id
ORDER BY song_plays DESC;
Solution #2 Using CTE

WITH report
AS (SELECT
  user_id,
  song_id,
  song_plays
FROM songs_history
UNION ALL
SELECT
  user_id,
  song_id,
  COUNT(song_id) AS song_plays
FROM songs_weekly
WHERE listen_time <= '08/04/2022 23:59:59'
GROUP BY user_id, song_id)

SELECT
  user_id,
  song_id,
  SUM(song_plays) AS song_plays
FROM report
GROUP BY user_id, song_id
ORDER BY song_plays DESC;
