-- Question Set 3 - Advance

-- Q1. Find how much amount spent by each customer on artists? Write a query to return 
-- customer name, artist name and total spent.

WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
    SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album ON album.album_id = track.album_id
    JOIN artist ON artist.artist_id = album.artist_id
    GROUP BY artist.artist_id, artist.name
    ORDER BY total_sales DESC
    LIMIT 1
)

SELECT customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name,
SUM(invoice_line.unit_price * invoice_line.quantity) AS amount_spent  
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice_line.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_selling_artist ON best_selling_artist.artist_id = album.artist_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name
ORDER BY amount_spent DESC;

-- Q2. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres. 

WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
    ROW_NUMBER () OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre on genre.genre_id = track.genre_id
    GROUP BY customer.country, genre.name, genre.genre_id
    ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;

-- Q3. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how 
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount.

WITH customer_with_country AS (
    SELECT customer.customer_id, customer.first_name, customer.last_name, invoice.billing_country,
    SUM(total) AS total_spending,
    ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY customer.customer_id, customer.first_name, customer.last_name, invoice.billing_country
    ORDER BY invoice.billing_country ASC, total_spending DESC
)
SELECT * FROM customer_with_country WHERE RowNo <= 1;