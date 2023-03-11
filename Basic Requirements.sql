-- Which tracks appeared in the most playlists? how many playlist did they appear in?
SELECT trackid, count(*) 
FROM playlisttracks
GROUP BY trackid
ORDER BY count DESC;

-- Which track generated the most revenue? which genre?
SELECT TrackId, sum(UnitPrice*Quantity) AS revenue 
FROM invoiceitems
GROUP BY TrackId
ORDER BY revenue DESC;

-- which album?
SELECT albums.albumid, albums.title, sum(invoiceitems.UnitPrice) AS revenue 
FROM invoiceitems
JOIN tracks
	ON invoiceitems.TrackId = tracks.trackid
JOIN albums
	ON tracks.albumid = albums.albumid
GROUP BY albums.albumid
ORDER BY revenue DESC;

-- which genre?
SELECT genres.genreid, genres.name, sum(invoiceitems.UnitPrice) AS revenue 
FROM invoiceitems
JOIN tracks
	ON invoiceitems.TrackId = tracks.trackid
JOIN genres
	ON tracks.genreid = genres.genreid
GROUP BY genres.genreid
ORDER BY revenue DESC;

-- Which countries have the highest sales revenue? What percent of total revenue does each country make up?
WITH negara AS
(SELECT invoices.billingcountry, SUM (invoices.total) AS pendapatanbagian
FROM invoices
GROUP BY invoices.billingcountry
ORDER BY pendapatanbagian DESC
)

SELECT negara.billingcountry, negara.pendapatanbagian,
	ROUND(negara.pendapatanbagian*100/(SUM(invoices.total)),2) AS persenpendapatan FROM negara, invoices
GROUP BY negara.pendapatanbagian, negara.billingcountry
ORDER BY pendapatanbagian DESC;

-- How many customers did each employee support, what is the average revenue for each sale, and what is their total sale?
SELECT employees.employeeid,employees.FirstName,employees.LastName, 
	COUNT (customers.customerid) AS totalcustomer,
	ROUND (AVG (invoices.total),2) AS averagepenjualan,
	ROUND (SUM (invoices.total),2) AS totalpenjualan 
FROM invoices
JOIN customers
	ON customers.customerid = invoices.customerid
JOIN employees
	ON employees.employeeid = customers.supportrepid
GROUP BY employees.employeeid
ORDER BY employees.employeeid ASC;
