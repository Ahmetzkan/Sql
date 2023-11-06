--Kaç farklı ülkeye ihracat yapıyorum
--86. a.Bu ülkeler hangileri..?
select distinct c.country from customers c;
select distinct o.ship_country from orders o;

--87. En Pahalı 5 ürün				  
select product_name,unit_price from products
order by unit_price desc
limit 5;
				  
--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select c.customer_id from customers c
inner join orders o on o.customer_id  = c.customer_id
where c.customer_id = 'ALFKI';

--89. Ürünlerimin toplam maliyeti
select sum(unit_price*quantity) from order_details ;

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum((unit_price*quantity) *( 1 - discount) ) as Toplam_maliyet from order_details; 

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products;

--92. En Pahalı Ürünün Adı
select product_name,unit_price from products
order by unit_price desc
limit 1;

--93. En az kazandıran sipariş
select (od.quantity,od.unit_price) as "En az Kazandıran",od.order_id from order_details od
order by "En az Kazandıran" asc
limit 1;

--94. Müşterilerimin içinde en uzun isimli müşteri
select company_name from customers
order by length(company_name) desc
limit 1;

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name,last_name,
date_part('year',current_date) - date_part('year',birth_date) as yas
from employees;

--96. Hangi üründen toplam kaç adet alınmış..?
select order_id,sum(quantity) as toplam_miktar from order_details
group by order_id;

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select order_id,sum((unit_price*quantity) *(1-discount)) from order_details
group by order_id;

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select category_id, sum(units_in_stock) as Stoktaki_Birimler from products
group by category_id
order by category_id;

--99. 1000 Adetten fazla satılan ürünler?
select product_id,sum(quantity) from order_details
group by product_id
having sum(quantity) >1000;

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.company_name,o.order_id from customers c
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;

--101. Hangi tedarikçi hangi ürünü sağlıyor?
select s.supplier_id, p.product_id, s.company_name, p.product_name  from suppliers s
inner join products p  on p.supplier_id = s.supplier_id
group by s.supplier_id, p.product_id, s.company_name, p.product_name
order by s.supplier_id, p.product_id, s.company_name, p.product_name;

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id,s.company_name,o.shipped_date from orders o
inner join shippers s on o.ship_via = s.shipper_id;

--103. Hangi siparişi hangi müşteri verir..?
select o.order_id,c.company_name,c.customer_id from customers c
inner join orders o on c.customer_id = o.customer_id;

--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id, e.first_name || ' ' || e.last_name as "Ad_Soyad", count(o.order_id) as Siparis_Sayisi from orders o
inner join employees e on o.employee_id = e.employee_id
group by  e.employee_id
order by Siparis_Sayisi desc;

--105. En fazla siparişi kim almış..?
select e.employee_id, e.first_name || ' ' || e.last_name as "Ad_Soyad", count(o.order_id) as Siparis_Sayisi from orders o
inner join employees e on o.employee_id = e.employee_id
group by  e.employee_id
order by Siparis_Sayisi desc
limit 1;

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select e.employee_id, e.first_name || ' ' || e.last_name as "Ad_Soyad",
o.order_id, o.customer_id from orders o
inner join employees e on o.employee_id = e.employee_id;

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name, c.category_name, s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join categories c on p.category_id = c.category_id;

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış,
--hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış,
--hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select cu.company_name, e.first_name, e.last_name, o.order_date, s.company_name, od.order_id, sum(od.quantity),
od.unit_price, c.category_name 
from orders o
inner join shippers s on o.ship_via = s.shipper_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
inner join customers cu on cu.customer_id = o.customer_id
inner join employees e on e.employee_id = o.employee_id
group by cu.company_name, e.first_name, e.last_name, o.order_date, s.company_name, od.order_id,
od.unit_price, c.category_name;

--109. Altında ürün bulunmayan kategoriler
select p.product_id,c.category_id,c.category_name from products p
inner join categories c on p.category_id = c.category_id
where p.product_id = 0 ;

SELECT category_id, category_name
FROM categories
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM products);

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select contact_title from customers
where contact_title like  '%Manager%';

--111. FR ile başlayan 5 karakter olan tüm müşterileri listeleyiniz.
select customer_id,contact_name from customers
where customer_id ilike 'fr___';

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select phone from customers
where phone like '%(171)%';

--113. Birimdeki miktar alanında boxes geçen tüm ürünleri listeleyiniz.
select quantity_per_unit  from products
where quantity_per_unit like '%boxes%';

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.
--(MusteriAdi,Telefon)
select customer_id,contact_name,phone,country from customers
where country = 'France' or country = 'Germany';

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select unit_price from products
order by unit_price desc
limit 10;

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select customer_id,contact_name,country,city from customers
order by country,city;

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select e.first_name,e.last_name,date_part('year',current_date) - date_part('year',e.birth_date) as "Yaş"
from employees e;

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select required_date,shipped_date from orders
where required_date + interval '35 days' < shipped_date;

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select p.unit_price,c.category_id,c.category_name  from products p
inner join categories c on p.category_id = c.category_id
where p.unit_price = (select max(unit_price)from products);

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select c.category_name from categories c
where c.category_name like '%on%';

--121. Konbu adlı üründen kaç adet satılmıştır ? 
select p.product_name,sum(quantity) from order_details od
inner join products p on od.product_id = p.product_id
where p.product_name = 'Konbu'
group by p.product_name;

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct(product_name)) from products p 
inner join suppliers s on p.supplier_id = s.supplier_id
where s.country ='Japan';

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select o.order_date,max(o.freight) as "Max Nakliye Ücreti",min(o.freight)as "Min Nakliye Ücreti"
,avg(o.freight) as "Ortalama Nakliye Ücreti" from orders o
where date_part('year',o.order_date) = '1997'
group by o.order_date;

--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers
where fax is not null;


--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
 select order_id,shipped_date from orders
 where shipped_date between '1996-07-16' and '1996-07-30';
