                            /* MUSIC STORE ANALYSIS */

/* 1.1.Who is the senior most employee based on job title? */

select title,first_name,last_name,levels from employee where rownum=1 order by levels desc

/* 1.2. Which countries have the most Invoices? */

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC

/* 1.3. What are top 3 values of total invoice? */

select total from invoice where rownum between 1 and 3 order by total desc

/* 1.4.Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice */

select billing_city,ht from
(select billing_city,sum(total) ht from invoice  group by billing_city
order by ht desc) where rownum =1

/* 1.5 Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money */

select c1.customer_id,c.first_name,c.last_name 
from (select customer_id,sum(total) ht from invoice  group by customer_id
order by ht desc)  c1  
left join customer c 
on c1.customer_id= c.customer_id 
where rownum =1

/* 2.1 Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A */

select distinct c.email,c.first_name,c.last_name,g.Name
from customer c 
left join invoice i
on c.customer_id=i.customer_id
left join invoice_line il
on i.invoice_id = il.invoice_id
left join Track t
on il.track_id = t.track_id
left join Genre g
on t.genre_id = g.genre_id
where g.Name = 'Rock'
order by c.email

/* 2.2 Count the number of tracks in each playlist. */

select distinct p.name,pt.playlist_id,count(Track_id) cnt 
from Playlist_track pt
left join playlist p
on pt.playlist_id=p.playlist_id
group by pt.playlist_id,p.name
order by 1

/* 2.3 Display customer id along with city and postal code who have total invoices 
greater than the average invoice. */

select distinct c.customer_id,c.city,c.postal_code from customer c
left join invoice i
on c.customer_id = i.customer_id
group by c.customer_id,c.city,c.postal_code
having sum(i.total) > (select avg(total) from invoice)
order by 1

/* 2.4 Display the top 5 genres with the highest average track unit price */

select * from (
select g.name,t.genre_Id, avg(Unit_Price) from Track t
left join Genre g 
on t.genre_Id = g.genre_Id
group by g.name,t.genre_Id
order by g.name,t.genre_Id desc)
where rownum between 1 and 5

/* 2.5 List the tracks with a length greater than 5 minutes. */
select distinct track_id,name from track
where (milliseconds/60000)>5

/* 2.6 Find the top 5 cities from which lowest of all purchases have been made. */
select * from (
select c.city,sum(total) tot from invoice i
left join customer c 
on i.customer_id = c.customer_id
group by c.city
order by tot)
where rownum between 1 and 5

/* 2.7 Display the top 3 artists who have the most tracks in the 'Pop' genre. */
select * from (
select at.name,count(t.track_id) cnt from track t
left join genre g
on t.genre_id = g.genre_id
left join album a
on t.album_id = a.album_id
left join artist at
on a.artist_id = at.artist_id
where upper(g.name)='POP'
group by at.name 
order by cnt desc)
where rownum between 1 and 3

/* 2.8 Identify the tracks that are not present in any playlist. */

select  pt.playlist_id,t.track_name from track t
left join playlist_track pt
on t.track_id = pt.track_id
where pt.playlist_id is null

/* 2.9 Retrieve all employee who have joined the store in their birth month. */

select first_name,last_name from employee
where to_char(hire_date,'mon') = to_char(to_date(substr(birthdate,1,10),'dd-mm-yyyy'),'mon')
