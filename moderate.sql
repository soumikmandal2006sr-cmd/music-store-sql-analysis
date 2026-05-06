-- Question Set 2 - Moderate

-- Q1. Write query to return the email, first name, last name and Genre of all Rock Music listeners.
-- Return your list ordered alphabetically by email starting with A.

SELECT DISTINCT customer.email, customer.first_name, customer.last_name, genre.name AS genre
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
ORDER BY email;

-- Q2. Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock bands. 

SELECT artist.artist_id, artist.name AS artist_name, COUNT(track_id) AS total_rock_tracks
FROM artist
JOIN album ON artist.artist_id = album.artist_id
JOIN track ON album.album_id = track.album_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY total_rock_tracks DESC
LIMIT 10;

-- Q3. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first.

SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) AS avg_track_length
    FROM track
)
ORDER BY milliseconds DESC;