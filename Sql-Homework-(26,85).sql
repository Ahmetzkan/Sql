++English
  --26. Write a query to get the list of products that are out of stock along with the name and contact number of the suppliers.
select p.product_id, p.product_name, s.company_name, s.phone
from products p
inner join suppliers s on p.supplier_id = s.supplier_id
where units_in_stock = 0;

--27. What is the address, employee's first name, and last name of the orders placed in March 1998?
select o.order_date, o.ship_address, e.first_name, e.last_name
from orders o
inner join employees e on e.employee_id = o.employee_id
where extract(year from o.order_date) = 1998
and extract(month from o.order_date) = 3;

--28. How many orders do I have in February 1997?
select count(o) as "number_of_orders", o.order_date
from orders o
where date_part('year', o.order_date) = 1997
and date_part('month', o.order_date) = 2
group by o.order_date;

--29. How many orders do I have from London in 1998?
select count(orders) as "number_of_orders_from_london"
from orders
where date_part('year', orders.order_date) = 1998
and orders.ship_city = 'London'
group by orders.order_date;

--30. Contact name and phone number of customers who placed orders in 1997.
select o.order_date, c.contact_name, c.phone
from orders o
inner join customers c on c.customer_id = o.customer_id
where date_part('year', o.order_date) = 1997;

--31. Orders with freight cost over 40.
select order_id, freight
from orders
where freight > 40;

--32. City and customer name of orders with freight cost over 40.
select o.ship_city, c.contact_name, o.freight
from orders o
inner join customers c on c.customer_id = o.customer_id
where o.freight > 40;

--33. Order date, city, and employee's name in uppercase for orders placed in 1997.
select o.order_date, o.ship_city, upper(concat(e.first_name, ' ', e.last_name)) as "Full Name"
from orders o
inner join employees e on o.employee_id = e.employee_id
where date_part('year', o.order_date) = 1997;

--34. Contact name and phone number of customers who placed orders in 1997.
select o.order_date, c.contact_name, regexp_replace(c.phone, '\D', '', 'g') as "Phone"
from orders o
inner join customers c on o.customer_id = c.customer_id
where date_part('year', o.order_date) = 1997;

--35. Order date, customer contact name, employee first name, and last name.
select o.order_date, c.contact_name, concat(e.first_name, ' ', e.last_name) as "Employee Name"
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id;

--36. Delayed orders.
select order_id, required_date, shipped_date
from orders
where required_date < shipped_date;

--37. Order date and customer name for delayed orders.
select o.order_id, o.order_date, c.contact_name
from orders o
inner join customers c on o.customer_id = c.customer_id
where required_date < shipped_date;

--38. Product name, category name, and quantity of products sold in order 10248.
select o.order_id, p.product_name, c.category_name, od.quantity
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where o.order_id = 10248;

--39. Product name and supplier name of products sold in order 10248.
select o.order_id, p.product_name, s.contact_name
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where o.order_id = 10248;

--40. Products and quantities sold by employee with ID 3 in 1997.
select e.employee_id, o.order_date, p.product_name, od.quantity
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year', o.order_date) = 1997
and e.employee_id = 3;

--41. Employee ID, name, and maximum quantity sold in a single order in 1997.
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name", od.quantity as Max_Quantity_Sold
from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year', o.order_date) = 1997
group by e.employee_id, od.quantity
order by sum(od.quantity * od.unit_price) desc
limit 1;

--42. Employee ID, name, and maximum quantity sold in a single order in 1997.
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name", od.quantity as Max_Quantity_Sold
from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year', o.order_date) = 1997
group by e.employee_id, od.quantity
order by max(od.quantity) desc
limit 1;

--43. Name, price, and category of the most expensive product.
select product_name, unit_price, category_name
from products
inner join categories on products.category_id = categories.category_id
order by unit_price desc;

--44. Employee name, order date, and order ID sorted by order date.
select o.order_id, o.order_date, e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name"
from orders o
inner join employees e on o.employee_id = e.employee_id
order by order_date;

--45. Average price and order ID of my last 5 orders.
select avg(p.unit_price) as Average_Price, o.order_id, o.order_date
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
group by o.order_id
order by order_date desc
limit 5;

--46. Name and category of products sold in January, along with the total sales quantity.
select p.product_name, c.category_name, o.order_date, sum(od.quantity) as "Total Sales Quantity"
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where date_part('month', o.order_date) = 1
group by p.product_name, c.category_name, o.order_date;

--47. Orders with sales quantity above the average.
select o.order_id, (od.unit_price * od.quantity) as Total_Sales
from order_details od
inner join orders o on od.order_id = o.order_id
group by o.order_id, od.quantity, od.unit_price, Total_Sales
having (od.quantity * od.unit_price) > (select avg(od.quantity * od.unit_price) from order_details od)
order by Total_Sales desc;

--48. Name, category, and supplier name of the best-selling product in terms of quantity.
select p.product_name, c.category_name, s.contact_name, od.quantity
from products p
inner join categories c on p.category_id = c.category_id
inner join order_details od on p.product_id = od.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
group by p.product_name, c.category_name, s.contact_name, od.quantity
order by count(od.quantity) desc
limit 1;

--49. Number of different countries my customers are from.
select count(distinct country) as "Number of Countries" from customers;

--50. Total sales made by employee with ID 3 from the last January until now.
select e.employee_id, sum(od.unit_price * od.quantity) as Total_Sales
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where e.employee_id = 3
and o.order_date >= '1900-01-01'
and o.order_date <= current_date
group by e.employee_id;

--51. Products sold in order 10248: name, category, and quantity.
select o.order_id, p.product_name, c.category_name, od.quantity
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where o.order_id = 10248;

--52. Products sold in order 10248: name and supplier name.
select p.product_name, s.contact_name, o.order_id
from order_details od
inner join orders o on od.order_id = o.order_id
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where o.order_id = 10248;

--53. Products sold by employee with ID 3 in 1997: name and quantity.
select e.employee_id, p.product_name, od.quantity
from orders o
inner join employees e on o.employee_id = e.employee_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
where e.employee_id = 3
and extract(year from o.order_date) = 1997;

--54. Employee ID, name, and maximum quantity sold in a single order in 1997.
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name", od.quantity as Max_Quantity_Sold
from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year', o.order_date) = 1997
group by e.employee_id, od.quantity
order by sum(od.quantity * od.unit_price) desc
limit 1;

--55. Employee ID, name, and maximum quantity sold in a single order in 1997.
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name"
from orders o
inner join employees e on o.employee_id = e.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from o.order_date) = 1997
group by o.order_id, e.employee_id, od.quantity, od.unit_price
order by max(od.quantity * od.unit_price) desc
limit 1;

--56. Name, price, and category of the most expensive product.
select product_name, unit_price, category_name
from products
inner join categories on products.category_id = categories.category_id
order by unit_price desc;

--57. Employee name, order date, and order ID sorted by order date.
select o.order_id, o.order_date, e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name"
from orders o
inner join employees e on o.employee_id = e.employee_id
order by order_date;

--58. Average price and order ID of my last 5 orders.
select avg(p.unit_price) as Average_Price, o.order_id, o.order_date
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
group by o.order_id
order by order_date desc
limit 5;

--59. Name and category of products sold in January, along with the total sales quantity.
select p.product_name, c.category_name, o.order_date, sum(od.quantity) as "Total Sales Quantity"
from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where date_part('month', o.order_date) = 1
group by p.product_name, c.category_name, o.order_date;

--60. Orders with sales quantity above the average.
select o.order_id, (od.unit_price * od.quantity) as Total_Sales
from order_details od
inner join orders o on od.order_id = o.order_id
group by o.order_id, od.quantity, od.unit_price, Total_Sales
having (od.quantity * od.unit_price) > (select avg(od.quantity * od.unit_price) from order_details od)
order by Total_Sales desc;

--61. Name, category, and supplier name of the best-selling product in terms of quantity.
select p.product_name, c.category_name, s.contact_name, od.quantity
from products p
inner join categories c on p.category_id = c.category_id
inner join order_details od on p.product_id = od.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
group by p.product_name, c.category_name, s.contact_name, od.quantity
order by count(od.quantity) desc
limit 1;

--62. Number of different countries my customers are from.
select count(distinct country) as "Number of Countries" from customers;

--63. Number of customers from each country.
select count(customer_id), country from customers
group by customers.country;

--64. Total sales made by employee with ID 3 from the last January until now.
select e.employee_id, sum(od.unit_price * od.quantity) as Total_Sales
from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where e.employee_id = 3
and o.order_date >= '1900-01-01'
and o.order_date <= current_date
group by e.employee_id;

--65. Total revenue from product with ID 10 in the last 3 months.
select sum(od.unit_price * od.quantity) as Revenue
from order_details od
inner join products p on od.product_id = p.product_id
inner join orders o on od.order_id = o.order_id
where p.product_id = 10
and o.order_date >= current_date - Interval '3 months';

--66. Total number of orders each employee has handled.
select e.employee_id, concat(e.first_name, ' ', e.last_name) as "Full Name", count(o.order_id) as "Number of Orders"
from orders o
inner join employees e on o.employee_id = e.employee_id
where o.order_date <= current_date
group by e.employee_id
order by "Number of Orders" desc;

--67. I have 91 customers, but only 89 have placed orders. Find the 2 customers who haven't.
select c.customer_id, c.contact_name, o.order_id
from orders o
right join customers c on o.customer_id = c.customer_id
where order_id is null;

--68. Company name, contact title, address, city, and country of customers in Brazil.
select c.company_name, c.contact_title, c.address, c.city, c.country from customers c
where country= 'Brazil';

--69. Customers who are not in Brazil.
select c.contact_name, c.country from customers c
where country != 'Brazil';

--70. Customers whose country is either Spain, France, or Germany.
select c.contact_name, c.country from customers c
where c.country = 'Spain' or c.country= 'France' or c.country='Germany';

--71. Customers whose fax numbers are not known.
select c.customer_id, c.contact_name, c.fax from customers c
where c.fax is null;

--72. Customers located in London or Paris.
select c.contact_name, c.city from customers c
where c.city = 'London' or c.city ='Paris';

--73. Customers residing in Mexico D.F. and have a contact title of 'Owner'.
select c.city, c.contact_title from customers c
where c.city= 'México D.F.' and c.contact_title = 'Owner';

--74. Products whose names start with 'C', along with their names and prices.
select product_name, unit_price from products
where product_name like 'C%';

--75. Employees whose first names start with 'A', along with their first names, last names, and birth dates.
select e.first_name, e.last_name, e.birth_date from employees e
where e.first_name like 'A%';

--76. Company names of customers with 'RESTAURANT' in their names.
select c.contact_name, c.company_name from customers c
where lower(c.company_name) like '%restaurant%';

--77. Names and prices of all products priced between $50 and $100.
select product_name, unit_price from products
where unit_price between 50 and 100;

--78. Orders with order IDs and dates between July 1, 1996, and December 31, 1996.
select o.order_id, o.order_date from orders o
where o.order_date between '1996-07-01' and '1996-12-31';

--79. Customers whose country is either Spain, France, or Germany.
select c.contact_name, c.country from customers c
where c.country = 'Spain' or c.country= 'France' or c.country='Germany';

--80. Customers whose fax numbers are not known.
select c.customer_id, c.contact_name, c.fax from customers c
where c.fax is null;

--81. Sorting my customers by country:
select c.customer_id, c.contact_name, c.country from customers c
order by country desc;

--82. Sorting my products from most expensive to least expensive, displaying product names and prices.
select p.product_name, p.unit_price from products p
order by p.unit_price desc;

--83. Sorting my products from most expensive to least expensive, but showing their stocks from least to greatest, displaying product names and prices.
select p.product_name, p.unit_price from products p
order by p.unit_price desc, p.units_in_stock asc;

--84. Number of products in category 1.
select category_id, count(category_id) as Product_Count from products
where category_id = 1
group by products.category_id;

--85. Number of different countries I export to.
select count(distinct(ship_country)) as "Number of Export Countries" from orders;

++Turkish
--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id,p.product_name,p.units_in_stock,s.company_name,s.phone from products p
inner join suppliers s on p.supplier_id = s.supplier_id
where units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı?
select o.order_date,o.ship_address,e.first_name,e.last_name from orders o
inner join employees e on e.employee_id = o.employee_id
where extract(year from o.order_date) = 1998
and extract(month from o.order_date) = 3;

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(o) as "kac_siparisim_var?",o.order_date from orders o
where date_part('year', o.order_date) = 1997
and date_part('month', o.order_date) = 2
group by o.order_date;

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(orders) as "Londradan_kac_siparisim_var?" from orders
where date_part('year',orders.order_date) = 1998
and orders.ship_city = 'London'
group by orders.order_date;

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select o.order_date,c.contact_name,c.phone from orders o
inner join customers c on c.customer_id = o.customer_id
where date_part('year',o.order_date) = 1997;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select order_id,freight from orders
where freight >40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city,c.contact_name,o.freight from orders o
inner join customers c on c.customer_id =o.customer_id
where o.freight >40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı 
--( ad soyad birleşik olacak ve büyük harf)
select o.order_date,o.ship_city,e.first_name || ' ' ||e.last_name as "Ad_Soyad" from orders o
inner join employees e on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i,
--ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select o.order_date,c.contact_name,regexp_replace(c.phone,'\D','','g') from orders o
inner join customers c on o.customer_id =c.customer_id
where date_part('year',o.order_date) = 1997;

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date,c.contact_name,e.first_name || ' ' ||e.last_name as "Ad_Soyad" from orders o
inner join customers c on o.customer_id = c.customer_id
inner join employees e on o.employee_id = e.employee_id;

--36. Geciken siparişlerim?
select order_id,required_date,shipped_date from orders
where required_date < shipped_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_id,o.order_date,c.contact_name from orders o 
inner join customers c on o.customer_id = c.customer_id
where required_date < shipped_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select o.order_id,p.product_name,c.category_name,od.quantity from orders o 
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
inner join categories c on p.category_id = c.category_id
where o.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı,tedarikçi adı
select o.order_id,p.product_name,s.contact_name from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where o.order_id =10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select e.employee_id,o.order_date,p.product_name,od.quantity from orders o 
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997
and e.employee_id=3;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id,e.first_name || ' ' ||e.last_name ,od.quantity as Max_Satis_Adeti from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997
group by e.employee_id,od.quantity
order by sum(od.quantity *od.unit_price) desc
limit 1;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id,e.first_name || ' ' ||e.last_name as "Ad Soyad",od.quantity as Max_Satis_Adeti from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997
group by e.employee_id,od.quantity
order by max(od.quantity) desc
limit 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name,unit_price,category_name from products
inner join categories on products.category_id = categories.category_id
order by unit_price desc;

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select o.order_id,o.order_date,e.employee_id,e.first_name || ' ' ||e.last_name as "Ad Soyad" from orders o
inner join employees e on o.employee_id = e.employee_id
order by order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(p.unit_price)as Ortalama,o.order_id,o.order_date from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
group by o.order_id
order by order_date desc
limit 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,o.order_date,sum(od.quantity) as "Toplam_Satis_Miktarı" from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
inner join categories c on p.category_id = c.category_id
where date_part('month', o.order_date) = 1
group by od.quantity,p.product_name,c.category_name,o.order_date;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select o.order_id,(od.unit_price*od.quantity) as toplam_satis from order_details od
inner join orders o on od.order_id = o.order_id
group by o.order_id,od.quantity,unit_price,toplam_satis
having (od.quantity*od.unit_price) > (select avg(od.quantity* od.unit_price) from order_details od)
order by toplam_satis desc;

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.contact_name,od.quantity from products p
inner join categories c on p.category_id = c.category_id
inner join order_details od on p.product_id = od.product_id
inner join suppliers  s on p.supplier_id = s.supplier_id
group by p.product_name,c.category_name,s.contact_name,od.quantity
order by count(od.quantity) desc
limit 1;

--49. Kaç ülkeden müşterim var
select count(distinct country) from customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id,sum(od.unit_price*od.quantity) as toplam_satis from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where e.employee_id =3
and o.order_date >= '1900-01-01'
and o.order_date <= current_date
group by e.employee_id;

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select o.order_id,p.product_name,c.category_name,od.quantity from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
inner join categories c on p.category_id = c.category_id
where o.order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name,s.contact_name,o.order_id from order_details od
inner join orders o on od.order_id = o.order_id
inner join products p on od.product_id = p.product_id
inner join suppliers s on p.supplier_id = s.supplier_id
where o.order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select e.employee_id,p.product_name,od.quantity from orders o
inner join employees e on o.employee_id = e.employee_id
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id = p.product_id
where e.employee_id = 3
and extract(year from o.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id,e.first_name || ' ' ||e.last_name ,od.quantity as Max_Satis_Adeti from orders o
inner join order_details od on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where date_part('year',o.order_date) = 1997
group by e.employee_id,od.quantity
order by sum(od.quantity *od.unit_price) desc
limit 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id,e.first_name || ' ' ||e.last_name as "Ad_Soyad" from orders o
inner join employees e on o.employee_id = e.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from o.order_date) =1997
group by o.order_id,e.employee_id,od.quantity,od.unit_price
order by max(od.quantity * od.unit_price) desc
limit 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name,unit_price,category_name from products
inner join categories on products.category_id = categories.category_id
order by unit_price desc;

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select o.order_id,o.order_date,e.employee_id,e.first_name || ' ' ||e.last_name as "Ad Soyad" from orders o
inner join employees e on o.employee_id = e.employee_id
order by order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(p.unit_price)as Ortalama,o.order_id,o.order_date from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
group by o.order_id
order by order_date desc
limit 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name,c.category_name,o.order_date,sum(od.quantity) as "Toplam_Satis_Miktarı" from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id =p.product_id
inner join categories c on p.category_id = c.category_id
where date_part('month', o.order_date) = 1
group by od.quantity,p.product_name,c.category_name,o.order_date;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select o.order_id,(od.unit_price*od.quantity) as toplam_satis from order_details od
inner join orders o on od.order_id = o.order_id
group by o.order_id,od.quantity,unit_price,toplam_satis
having (od.quantity*od.unit_price) > (select avg(od.quantity* od.unit_price) from order_details od)
order by toplam_satis desc;

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name,c.category_name,s.contact_name,od.quantity from products p
inner join categories c on p.category_id = c.category_id
inner join order_details od on p.product_id = od.product_id
inner join suppliers  s on p.supplier_id = s.supplier_id
group by p.product_name,c.category_name,s.contact_name,od.quantity
order by count(od.quantity) desc
limit 1;

--62. Kaç ülkeden müşterim var
select count(distinct country) from customers;

--63. Hangi ülkeden kaç müşterimiz var
select count(customer_id),country from customers
group by customers.country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id,sum(od.unit_price*od.quantity) as toplam_satis from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where e.employee_id =3
and o.order_date >= '1900-01-01'
and o.order_date <= current_date
group by e.employee_id;

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.unit_price*od.quantity) as Ciro from order_details od
inner join products p on od.product_id = p.product_id
inner join orders o on od.order_id = o.order_id
where p.product_id =10
and o.order_date  >= Current_Date - Interval '3 months';

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id,e.first_name || ' ' ||e.last_name as "Ad_Soyad",count(o.order_id) as Siparis_Sayisi
from orders o
inner join employees e on o.employee_id = e.employee_id
where o.order_date  <= Current_Date
group by e.employee_id
order by Siparis_Sayisi desc;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id,c.contact_name,o.order_id from orders o 
right join customers c on o.customer_id = c.customer_id
where order_id is null;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select c.company_name,c.contact_title,c.address,c.city,c.country from customers c
where country= 'Brazil';

--69. Brezilya’da olmayan müşteriler
select c.contact_name,c.country from customers c
where country != 'Brazil';

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select c.contact_name,c.country from customers c
where c.country = 'Spain' or c.country= 'France' or c.country='Germany';

--71. Faks numarasını bilmediğim müşteriler
select c.customer_id,c.contact_name,c.fax from customers c
where c.fax is null;

--72. Londra’da ya da Paris’de bulunan müşterilerim
select c.contact_name,c.city from customers c
where c.city = 'Londra' or c.city ='Paris';

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select c.city,c.contact_title from customers c
where c.city= 'México D.F.' and c.contact_title = 'Owner';

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name,unit_price from products
where product_name like 'C%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select e.first_name,e.last_name,e.birth_date from employees e
where e.first_name like 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select c.contact_name,c.company_name from customers c
where  lower(c.company_name) like '%restaurant%';

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price from products
where unit_price between 50 and 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin 
--(Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select o.order_id,o.order_date from orders o
where o.order_date between '1996-07-01' and '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select c.contact_name,c.country from customers c
where c.country = 'Spain' or c.country= 'France' or c.country='Germany';

--80. Faks numarasını bilmediğim müşteriler
select c.customer_id,c.contact_name,c.fax from customers c
where c.fax is null;

--81. Müşterilerimi ülkeye göre sıralıyorum:
select c.customer_id,c.contact_name,c.country from customers c
order by country desc;

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select p.product_name,p.unit_price from products p
order by p.unit_price desc;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını 
--küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select p.product_name,p.unit_price from products p
order by p.unit_price desc,p.units_in_stock asc;

--84. 1 Numaralı kategoride kaç ürün vardır..?
select category_id,count(category_id) as Ürün_Sayisi from products
where category_id = 1
group by products.category_id;

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct(ship_country)) as İhracat_yapilan_ülke_sayisi from orders;

