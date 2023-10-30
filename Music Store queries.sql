/**/

/* Project Finds */

/*Finding  the employee with the longest job tenure based on job title.ALso identify the emplyoyee with the shortest job tenure*/

-- Longest job tenure 
Select title ,last_name , first_name 
From employee
Order BY levels DESC
LIMIT 1;

-- Shortest Job tenure 

Select title , last_name, first_name
From employee
Order By levels ASC
Limit 1;



/*Which countries have the highest and lowest number of invoices? List both the country names and corresponding invoices counts*/

--Higest number of invoices
Select Count (*) As c, billing_country
from invoice 
group by  billing_country 
order by C DESC
Limit 1;

-- Lowest number of invoices 
Select Count (*) As c, billing_country
From invoice
Group By billing_country
Order by c ASC
LIMIT 1;

/*List the top3 and bottom 3 values of total invoices .provide the coressponding total amounts*/

-- Top 3 values of total invoices
Select total
From invoice
Order by total DESC
Limit 3;
--Bottom 3 values of total invoices
select total 
from invoice
order by total asc
limit 3;



/*Identify the city with the highest and lowest total invoices sums.Provides both the city name and the corresponding sum of invoive totals*/

--City with the highest total invoice sum
Select billing_city ,
Sum(total)As Invoicetotal 
from invoice 
Group By Billing_city 
Order By InvoiceTotal Desc
Limit 1;

--City with the lowest total invoice sum 
Select billing_city, 
Sum(total) As InvoiceTotal
From invoice
Group By billing_city
Order By InvoiceTOtal Asc
Limit 10;

/*who are the top and bottom spending customers? provide the cutomers names and the corresponding total spending */

--Top spending customers
Select customer.customer_id, first_name, last_name,
Sum (total) as total_spending
from customer
Join invoice On 
		customer.customer_id = invoice.customer_id
Group By customer.customer_id
Order By total_spending Desc
Limit 1;

-- Bottom spendign customers
Select customer.customer_id, first_name, last_name,
Sum (total) as total_spending
from customer
Join invoice On 
		customer.customer_id = invoice.customer_id
Group By customer.customer_id
Order By total_spending Asc
Limit 1;



/*write a query to return the email ,first name and last name &gerne of all classical music listerns .Order the list by email .*/

Select Distinct email, first_name, Last_name , genre.name As Name
From customer
Join invoice On 
		invoice.customer_id = customer.customer_id
JOIN invoice_line ON 
		invoice_line.invoice_id = invoice.invoice_id
Join track On 
		track.track_id = invoice_line.track_id
Join genre On 
		genre.genre_id = track.genre_id
Where genre.name Like 'Classical'
Order By email;

/*Invite the artsit who have written the most and least rock music in our dataset.Return the Artisit name and total track count for both cases*/

-- Most rock music wrtiers 
Select artist.artist_id, artist.name, Count(artist.artist_id) As number_of_songs
From track
Join album On 
		album.album_id = track.album_id
Join artist On 
		artist.artist_id = album.artist_id
Join genre On 
		genre.genre_id = track.genre_id
Where genre.name Like 'Rock'
Group BY artist.artist_id
Order BY number_of_songs Desc
Limit 1;


-- Least rock music writers
Select artist.artist_id, artist.name, Count(artist.artist_id) As number_of_songs
From track
Join album On 
		album.album_id = track.album_id
Join artist On 
		artist.artist_id = album.artist_id
Join genre On 
		genre.genre_id = track.genre_id
Where genre.name Like 'Rock'
Group BY artist.artist_id
Order BY number_of_songs Asc
Limit 1;


/*return all track names that have song length longer than the average and shorter than the average song lenth.Order by song length with the longest songs listed first*/

Select name, milliseconds
From track
Where milliseconds > (Select AVG(milliseconds) AS avg_track_length From track)
Order BY milliseconds Desc;

/*Find how much amounts was spent by each customers on the top selling artist .Return customers name ,srtist anme and total spent,identify the customers who spent the least*/

--\Top selling artisit 
with  best_selling_artist 
as
(Select  artist.artist_id, artist.name  As  artist_name, 
  Sum (invoice_line.unit_price *  invoice_line.quantity)  As total_sales
    From invoice_line
   join  track On 
 		track.track_id = invoice_line.track_id
   join album On 
 		album.album_id = track.album_id
   join  artist On 
 		artist.artist_id = album.artist_id
 
   Group  By 1
   Order  By 3 Desc
   limit  1)
   
   SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
    Sum (il.unit_price * il.quantity) As  amount_spent
   From invoice i
    join customer c On 
			c.customer_id = i.customer_id
     join invoice_line il On 
	 		il.invoice_id = i.invoice_id
     join track t On 
	 		t.track_id = il.track_id
     join album alb On 
	 		alb.album_id = t.album_id
     join best_selling_artist bsa On   bsa.artist_id = alb.artist_id
	 
Group  By 1,2,3,4
order  By 5 Desc;




/*determine themost and least popular music genre fro each country .Return each country along with the top and bottom  Genre For countires where the maximum and minimum number of purchases is shared , return all Genres*/

-- Most popular music genre per country

with popular_genre as
(
    Select  count(invoice_line.quantity) as 	
		purchases, customer.country, genre.name, genre.genre_id, 
    Row_number() 
		Over(Partition  By customer.country order By Count(invoice_line.quantity) Desc) As RowNo 
    From  invoice_line 
    join  invoice on  
			invoice.invoice_id = invoice_line.invoice_id
    join customer on
			customer.customer_id = invoice.customer_id
    join track on
			track.track_id = invoice_line.track_id
    join genre on
			genre.genre_id = track.genre_id
    Group by  2,3,4
    Order by 2 asc, 1 desc
)

Select  * from  popular_genre where  RowNo <= 1;

/*Write a query thatdetermine the customers that has spent the  most and least on music for each country.Retrun the country along with the top and bottom customer and how much they spent .For countries whre the top and bottom amount spent is shared ,provided  all customers who spent theses amounts.*/

with  Customter_with_country as  (
    Select customer.customer_id, first_name, last_name, billing_country, 
	Sum  (total) as total_spending,
    Row_number() over (partition  by  billing_country order by sum  (total) desc) as RowNo 
    from  invoice
    join  customer ON 
			customer.customer_id = invoice.customer_id
    group by  1,2,3,4
    order by  4 asc ,5 desc
)

Select * from  Customter_with_country where  RowNo <= 1;

