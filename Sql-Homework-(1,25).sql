--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
select product_name,quantity_per_unit from products;
--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) 
--değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
select product_id,product_name from products where discontinued = 1;
--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) 
--değerleriyle almak için bir sorgu yazın.
--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için sorgu yazın.
select product_id,product_name,unit_price from products where unit_price<20;
--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün 
--listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id,product_name,unit_price from products where unit_price between 15 and 25;
--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) 
--stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_id,units_on_order,units_in_stock from products where units_in_stock < units_on_order;
--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
Select *from products where LOWER(product_name) LIKE 'a%'; 
--8. İsmi `i` ile biten ürünleri listeleyeniz.
Select *from products where LOWER(product_name) LIKE '%i'; 
--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak 
--(ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name,unit_price,(unit_price *1.18) as UnitPriceKDV from products; 
--10. Fiyatı 30 dan büyük kaç ürün var?
select count(unit_price) from products where unit_price>30;
--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select lower(product_name),unit_price from products order by unit_price desc;
--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select CONCAT(first_name,' ',last_name) As Ad_Soyad from employees;
--13. Region alanı NULL olan kaç tedarikçim var?
select count(*) from employees where region is null;
--14. a.Null olmayanlar?
select count(*) from employees where region is not null;
--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp ekrana yazdır.
select CONCAT('TR ',upper(product_name)) from products;
--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select CONCAT('TR ',upper(product_name)),unit_price from products where unit_price <20;
--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name,unit_price from products where unit_price=(select max(unit_price) from products);
--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name,unit_price from products order by unit_price desc limit 10; 
--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name,unit_price from products where unit_price> (select avg(unit_price) from products);
--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select sum(unit_price * units_in_stock) as toplam_kar from products; 
--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select *from products inner join categories on categories.category_id = products.category_id ;
--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
SELECT categories.category_name, round(avg(products.unit_price)) AS urun_ortalaması FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY categories.category_name;
--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select product_name,unit_price,category_name from products
inner join categories on products.category_id = categories.category_id
where unit_price = (select max(unit_price) from products);
--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select p.product_id,c.category_name,s.company_name from products p
inner join categories c on p.category_id = c.category_id
inner join suppliers  s on p.supplier_id = s.supplier_id
where product_id =(
select product_id from order_details
group by product_id
order by count(quantity) desc
limit 1 
);
