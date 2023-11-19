-- 86. a.Bu ülkeler hangileri..?
select distinct country from customers order by country

--87. En Pahalı 5 ürün
select product_name, unit_price from products
order by unit_price desc
limit 5

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select customer_id, count(order_id) from orders
where customer_id = 'ALFKI'
group by customer_id

--89. Ürünlerimin toplam maliyeti
select sum(units_in_stock * unit_price) from products

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select (sum(unit_price * quantity) - sum(unit_price * quantity * discount)) as "Ciro" from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products

--92. En Pahalı Ürünün Adı
select product_name, unit_price from products
order by unit_price desc
limit 1

--93. En az kazandıran sipariş
select order_id, sum(unit_price * quantity) as "Toplam Fiyat" from order_details 
group by order_id
order by "Toplam Fiyat" 
limit 1

--94. Müşterilerimin içinde en uzun isimli müşteri
select company_name from customers
order by char_length(company_name) desc
limit 1

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select e.first_name, e.last_name, extract(year from age(current_date,e.birth_date)) as yas from employees e

--96. Hangi üründen toplam kaç adet alınmış..?
select p.product_id, p.product_name, sum(quantity) from order_details od
inner join products p on p.product_id = od.product_id
group by p.product_id, p.product_name
order by sum(quantity) desc

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select order_id, sum(quantity * unit_price * (1 - discount)) as toplam_kazanc from order_details
group by order_id
order by toplam_kazanc desc

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_id, c.category_name, count(p.units_in_stock) from categories c
inner join products p on p.category_id = c.category_id
group by c.category_id, c.category_name
order by c.category_id 

--99. 1000 Adetten fazla satılan ürünler?
select p.product_name, sum(od.quantity) from order_details od
inner join products p on p.product_id = od.product_id
group by p.product_name
having sum(od.quantity) > 1000
order by sum(od.quantity) desc

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id, c.company_name, o.order_id from customers c
left join orders o on o.customer_id = c.customer_id
where order_id is null

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.supplier_id, s.company_name, p.product_id, p.product_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id


--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id, s.company_name, o.order_date from orders o
inner join shippers s on s.shipper_id = o.ship_via

--103. Hangi siparişi hangi müşteri verir..?
select o.order_id, c.company_name from customers c
inner join orders o on o.customer_id = c.customer_id

--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad, count(order_id) from orders o 
inner join employees e on e.employee_id = o.employee_id
group by e.employee_id, ad_soyad
order by e.employee_id 

--105. En fazla siparişi kim almış..?
select e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad, count(order_id) from orders o
inner join employees e on e.employee_id = o.employee_id
group by e.employee_id, ad_soyad
order by count(order_id) desc
limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id, e.employee_id, e.first_name || ' ' || e.last_name as ad_soyad, c.company_name 
from orders o
inner join employees e on e.employee_id = o.employee_id
inner join customers c on c.customer_id = o.customer_id

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_id, p.product_name, c.category_name, s.company_name from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte,
--hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış,
--hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id, c.company_name as musteri, e.first_name || ' ' || e.last_name as ad_soyad, o.order_date,
s.company_name as kargo, p.product_name, od.quantity, od.unit_price, cg.category_name, sp.company_name as tedarikci
from order_details od
inner join products p on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
inner join customers c on c.customer_id = o.customer_id
inner join employees e on e.employee_id = o.employee_id
inner join shippers s on s.shipper_id = o.ship_via
inner join categories cg on cg.category_id = p.category_id
inner join suppliers sp on sp.supplier_id = p.supplier_id

--109. Altında ürün bulunmayan kategoriler
select c.category_name, p.product_name from products p 
right join categories c on c.category_id = p.category_id
where p.product_id is null

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select company_name, contact_title from customers 
where contact_title like '%Manager%'

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select customer_id, company_name from customers where customer_id like 'FR___%'

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select company_name, phone from customers
where phone like '(171)%'

--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select product_name, quantity_per_unit from products
where quantity_per_unit like '%boxes%'

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını
--ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select company_name, contact_title, phone, country from customers
where contact_title like '%Manager%' and country in('France','Germany') 

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select product_id, product_name, unit_price from products
order by unit_price desc
limit 10

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select company_name, country, city from customers
order by company_name, country, city

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name, last_name, extract(year from age(current_date, birth_date)) as yas
from employees

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select order_id, required_date, shipped_date from orders
where extract(month from age(shipped_date,required_date)) > 1 or shipped_date is null

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select c.category_name from categories c
where exists(select category_id from products p where p.category_id = c.category_id 
			order by unit_price desc)
limit 1

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select product_name from products p
where exists(select * from categories c where p.category_id = c.category_id and
			c.category_name like '%on%')

--121. Konbu adlı üründen kaç adet satılmıştır.
select sum(quantity) from order_details od
inner join products p on p.product_id = od.product_id
where p.product_name = 'Konbu'

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct product_id) from suppliers s
inner join products p on p.supplier_id = s.supplier_id
where s.country = 'Japan'

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight), min(freight), avg(freight) from orders
where extract(year from order_date) = 1997

--124. Faks numarası olan tüm müşterileri listeleyiniz.
select company_name, fax from customers
where fax is not null

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select order_id, order_date, shipped_date from orders
where order_date between '1996-07-16' and '1996-07-30' and shipped_date is not null