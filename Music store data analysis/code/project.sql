create database music_store;
use music_store;
-- drop database  music_store;

-- 1. Genre and MediaType
CREATE TABLE Genre (
	genre_id INT PRIMARY KEY,
	name VARCHAR(120)
);

CREATE TABLE MediaType (
	media_type_id INT PRIMARY KEY,
	name VARCHAR(120)
);

-- 2. Employee
CREATE TABLE Employee (
	employee_id INT PRIMARY KEY,
	last_name VARCHAR(120),
	first_name VARCHAR(120),
	title VARCHAR(120),
	reports_to INT,
  levels VARCHAR(255),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100)
);

-- 3. Customer
CREATE TABLE Customer (
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(120),
	last_name VARCHAR(120),
	company VARCHAR(120),
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100),
	support_rep_id INT,
	FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
);

-- 4. Artist
CREATE TABLE Artist (
	artist_id INT PRIMARY KEY,
	name VARCHAR(120)
);

-- 5. Album
CREATE TABLE Album (
	album_id INT PRIMARY KEY,
	title VARCHAR(160),
	artist_id INT,
	FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

-- 6. Track
CREATE TABLE Track (
	track_id INT PRIMARY KEY,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id) REFERENCES Album(album_id),
	FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id),
	FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);

-- 7. Invoice
CREATE TABLE Invoice (
	invoice_id INT PRIMARY KEY,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(255),
	billing_city VARCHAR(100),
	billing_state VARCHAR(100),
	billing_country VARCHAR(100),
	billing_postal_code VARCHAR(20),
	total DECIMAL(10,2),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
	invoice_line_id INT PRIMARY KEY,
	invoice_id INT,
	track_id INT,
	unit_price DECIMAL(10,2),
	quantity INT,
	FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);

-- 9. Playlist
CREATE TABLE Playlist (
 	playlist_id INT PRIMARY KEY,
	name VARCHAR(255)
);

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
	playlist_id INT,
	track_id INT,
	PRIMARY KEY (playlist_id, track_id),
	FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);

select * from track;
select * from album;
select * from artist;
select * from customer;
select * from employee;
select * from genre;
select * from invoice;
select * from invoiceline;
select * from mediatype;
select * from playlist;
select * from playlisttrack;





LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv'
INTO TABLE track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);

SHOW VARIABLES LIKE 'local_infile';





-- ============================================================================================================================================
-- 1. Who is the senior most employee based on job title? 

select first_name,last_name,title,levels
from employee
where substring(levels,2)
limit 1;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 2 Which countries have the most Invoices?
select billing_country,count(invoice_id) as invoice_count
from invoice
group by billing_country
order by invoice_count desc
limit 3;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 3 What are the top 3 values of total invoice?
select * from invoice
order by total desc
limit 3;
-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city,sum(total) as sum_of_invoices
from invoice
group by billing_city
order by sum_of_invoices desc
limit 1;

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Who is the best customer? - The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money

select c.customer_id,c.first_name,c.last_name,sum(i.total) as spent
from invoice i
join customer as c
on c.customer_id=i.customer_id
group by customer_id
order by spent desc
limit 1;


-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
--  Return your list ordered alphabetically by email starting with A

select c.email,c.first_name,c.last_name,g.name as genre
from customer c
join invoice i
on c.customer_id=i.customer_id
join invoiceline il
on i.invoice_id=il.invoice_id
join track t
on il.track_id=t.track_id
join genre g
on t.genre_id=g.genre_id
where g.name="rock"
order by c.email ;


-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Let's invite the artists who have written the most rock music in our dataset.
-- Write a query that returns the Artist name and total track count of the top 10 rock bands 

select a.name,count(*) as tracks
from artist a
join album am
on a.artist_id=am.artist_id
join track t
on am.album_id=t.album_id
join genre g
on t.genre_id=g.genre_id
where g.name="rock"
group by a.name
order by tracks desc
limit 10;

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 8. Return all the track names that have a song length longer than the average song length.- Return the Name and Milliseconds for each track.
-- Order by the song length, with the longest songs listed first

select name,milliseconds
from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent 

select c.customer_id,c.first_name as customer_name,a.name,sum(il.unit_price*il.quantity)
from customer c
join invoice i
on c.customer_id=i.customer_id
join invoiceline il
on i.invoice_id=il.invoice_id
join track t
on il.track_id=t.track_id
join album am
on t.album_id=am.album_id
join artist a
on am.artist_id=a.artist_id
group by c.customer_id,customer_name,a.name;


-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries
-- where the maximum number of purchases is shared, return all Genres

select i.billing_country as country,g.name as genre
from invoice i
join invoiceline il
on i.invoice_id =il.invoice_id
join track t
on il.track_id=t.track_id
join genre g
on t.genre_id=g.genre_id
group by i.billing_country,g.name;


SELECT country, genre, purchase_count
FROM (
  SELECT 
    i.billing_country AS country,
    g.name AS genre,
    COUNT(*) AS purchase_count,
    RANK() OVER (PARTITION BY i.billing_country ORDER BY COUNT(*) DESC) AS genre_rank
  FROM invoice i
  JOIN invoiceline il ON i.invoice_id = il.invoice_id
  JOIN track t ON il.track_id = t.track_id
  JOIN genre g ON t.genre_id = g.genre_id
  GROUP BY i.billing_country, g.name
) ranked_genres
WHERE genre_rank = 1;


with genre_sales as (
   select i.billing_country,g.name as genre_name,count(il.invoice_line_id) as purchase_count from invoice as i
   join invoiceline as il on il.invoice_id = i.invoice_id
   join track as t on t.track_id = il.track_id
   join genre as g on g.genre_id = t.genre_id
   group by i.billing_country,g.genre_id),
max_genre_sales as (
   select billing_country , max(purchase_count) as max_purchases from genre_sales
   group by billing_country)
select gs.billing_country , gs.genre_name , gs.purchase_count
from genre_sales as gs
join max_genre_sales as mgs on mgs.billing_country = gs.billing_country
and gs.purchase_count = mgs.max_purchases  -- to ensure that we only get top genre in the respective country 
order by gs.billing_country;

-- --------------------------------------------------------------------------------------------------------------------------------------------
-- 11. Write a query that determines the customer that has spent the most on music for each country. Write a query 
-- that returns the country along with the top customer and how much they spent. For countries where the top amount spent 
-- is shared, provide all customers who spent this amount


select c.first_name,i.billing_country
from customer c
join invoice i
on c.customer_id=i.customer_id
join invoiceline il
on i.invoice_id=il.invoice_id
group by c.first_name,i.billing_country
where (select sum(i.total)
from invoice

);


SELECT 
  billing_country AS country,
  customer_name,
  total_spent
FROM (
  SELECT 
    i.billing_country,
    c.first_name AS customer_name,
    SUM(il.unit_price * il.quantity) AS total_spent,
    RANK() OVER (
      PARTITION BY i.billing_country
      ORDER BY SUM(il.unit_price * il.quantity) DESC
    ) AS spending_rank
  FROM customer c
  JOIN invoice i ON c.customer_id = i.customer_id
  JOIN invoiceline il ON i.invoice_id = il.invoice_id
  GROUP BY i.billing_country, c.customer_id, customer_name
) ranked_customers
WHERE spending_rank = 1;


SELECT SUM(il.unit_price * il.quantity) AS total_spent,
RANK() OVER (PARTITION BY i.billing_country ORDER BY SUM(il.unit_price * il.quantity) DESC) AS spending_rank
from invoice i
JOIN invoiceline il ON i.invoice_id = il.invoice_id;

with customer_spending as (
   select c.customer_id ,c.first_name,c.last_name,i.billing_country,sum(i.total) as total_spent
   from customer as c
   join invoice as i on i.customer_id = c.customer_id
   group by c.customer_id,c.first_name,c.last_name,i.billing_country
   ),
max_spending as (
   select billing_country , max(total_spent) as max_spent
   from customer_spending
   group by billing_country)
select cs.billing_country , cs.first_name,cs.last_name,cs.total_spent from customer_spending as cs
join max_spending as ms on ms.billing_country = cs.billing_country
and cs.total_spent = ms.max_spent    -- for getting the top spending customer only country wise 
order by cs.billing_country;


