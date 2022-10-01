Medium

Spotify
Assume there are three Spotify tables containing information about the artists, songs, and music charts. Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. From now on, we'll refer to this ranking number as "song appearances".

Output the top 5 artist names in ascending order along with their song appearances ranking (not the number of song appearances, but the rank of who has the most appearances). The order of the rank should take precedence.

For example, Ed Sheeran's songs appeared 5 times in Top 10 list of the global song rank table; this is the highest number of appearances, so he is ranked 1st. Bad Bunny's songs appeared in the list 4, so he comes in at a close 2nd.

Assumptions:

If two artists' songs have the same number of appearances, the artists should have the same rank.
The rank number should be continuous (1, 2, 2, 3, 4, 5) and not skipped (1, 2, 2, 4, 5).
artists Table:
Column Name	Type
artist_id	integer
artist_name	varchar
artists Example Input:
artist_id	artist_name
101	Ed Sheeran
120	Drake
songs Table:
Column Name	Type
song_id	integer
artist_id	integer
songs Example Input:
song_id	artist_id
45202	101
19960	120
global_song_rank Table:
Column Name	Type
day	integer (1-52)
song_id	integer
rank	integer (1-1,000,000)
global_song_rank Example Input:
day	song_id	rank
1	45202	5
3	45202	2
1	19960	3
9	19960	15
Example Output:
artist_name	artist_rank
Ed Sheeran	1
Drake	2
Explanation
Ed Sheeran's song appeared twice in the Top 10 list of global song rank while Drake's song is only listed once. Therefore, Ed is ranked #1 and Drake is ranked #2.

Solution
Let's break this question down into 3 steps:

Find the top 10 artists by rank along with the largest number of song appearances in the Top 10 of the global_song_rank table.
Rank the artists according to their number of song appearances in the previous step
Limit your results to the top 5 artists by their rank in the previous step
Step 1

First, join the songs and global_song_rank tables to get a table with artist and their song rankings. This link has more information about using INNER JOINS.

Count [1] the number of times an artist's song/s appear in the table and group by the artist [2].

Don't forget to do the most crucial step: filtering for top 10 ranks. Let's call this output the Top 10 Chart. The query should look something like this:

SELECT 
  songs.artist_id,
  COUNT(songs.song_id) AS song_count
FROM songs
INNER JOIN global_song_rank AS ranking
  ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY songs.artist_id;
The first 5 rows of the output should look like this:

artist_id	song_count
101	5
200	4
125	6
240	3
120	2
To interpret the output, we can say that the songs of artist id 101 have appeared in the Top 10 of the global song rank chart 5 times.

Step 2

Next, we rank the artists based on the number of times their songs appeared in the Top 10 Chart.

We can accomplish this by using the above as a subquery [3], and implementing a DENSE_RANK [4] window function. DENSE_RANK will help us create a ranking based on the number of times the artists' songs appear in descending order.

DENSE_RANK() OVER (ORDER BY song_count DESC)
Do you know why we use DENSE_RANK and not RANK?

Both the DENSE_RANK and RANK functions assign the same rank to duplicates. However, RANK skips the next number in the ranking (see the last row in the output below), which is not what we want. For this question, we will use DENSE_RANK, which doesn't skip any rank numbers.

Check out the difference between DENSE_RANK and RANK here:

artist_id	song_count	dense_rank_num	rank_num
125	6	1	1
101	5	2	2
145	4	3	3
200	4	3	3
240	3	4	5
Notice the difference between the dense_rank_num and rank_num columns? Artist 145 and 200 have the same song_count of 4, so both are ranked 3rd. Using DENSE_RANK, the immediate next artist 240 is correctly ranked as 4th, but RANK skips the 4th rank and labels artist 240 as the 5th rank.

Note that we want the ranking to be continuous (1, 2, 2, 3, 4, 5) and not skipped (1, 2, 2, 4, 5). Did you get the difference? ;)

Once we implement DENSE_RANK, our query looks like this:

SELECT 
  artist_id,
  DENSE_RANK() OVER (
    ORDER BY song_count DESC) AS artist_rank
FROM ( 
  SELECT 
    songs.artist_id,
    COUNT(songs.song_id) AS song_count
  FROM songs
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
  GROUP BY songs.artist_id
)  AS top_songs;
Let's convert this query to a Common Table Expression (CTE) called top_artists so we can reuse it in the final step.

Again, we're only showing the first 5 rows of output:

artist_id	artist_rank
125	1
101	2
145	3
200	3
240	4
Here, artist 101 is ranked 2nd, which means that the songs of artist id 125 appeared in the Top 10 Chart more often than those of artist 101!

Step 3

For the final step, we'll use a CTE to find the top 5 artists, then JOIN it with the artists table to get their names.

A Common Table Expression (CTE) is a temporary data set that exists during the entire query session. Click here to learn more about CTEs.

Our full solution looks like this:

WITH top_artists
AS ( 
-- Insert the query in step 2
) 

SELECT 
  artists.artist_name,
  top_artists.artist_rank
FROM top_artists
INNER JOIN artists
  ON top_artists.artist_id = artists.artist_id
WHERE top_artists.artist_rank <= 5
ORDER BY top_artists.artist_rank, artists.artist_name;
Results:

artist_name	artist_rank
Bad Bunny	1
Ed Sheeran	2
Adele	3
Lady Gaga	3
Katy Perry	4
Drake	5
Full Solution:

WITH top_artists
AS (
  SELECT 
    artist_id,
    DENSE_RANK() OVER (
      ORDER BY song_count DESC) AS artist_rank
  FROM (    
    SELECT songs.artist_id, COUNT(songs.song_id) AS song_count
    FROM songs
    INNER JOIN global_song_rank AS ranking
      ON songs.song_id = ranking.song_id
    WHERE ranking.rank <= 10
    GROUP BY songs.artist_id) 
AS top_songs)

SELECT 
  artists.artist_name, top_artists.artist_rank
FROM top_artists
INNER JOIN artists
  ON top_artists.artist_id = artists.artist_id
WHERE top_artists.artist_rank <= 5
ORDER BY top_artists.artist_rank, artists.artist_name;
