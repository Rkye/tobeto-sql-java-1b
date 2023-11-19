--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını 
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select product_id, product_name, company_name, phone, units_in_stock from products p
inner join suppliers s on p.supplier_id = s.supplier_id
where units_in_stock = 0

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address, first_name || ' ' || last_name as "ad soyad", order_date from orders o
inner join employees e on o.employee_id = e.employee_id
where order_date between '1998-03-01' and '1998-03-31'


--WHERE EXTRACT(MONTH FROM "TarihSutunu") = 2 AND EXTRACT(YEAR FROM "TarihSutunu") = 2023;
--28. 1997 yılı şubat ayında kaç siparişim var?
select count(order_id), order_date from orders
where extract(month from order_date) = 02 and extract(year from order_date) = 1997 
group by order_date

--29. London şehrinden 1998 yılında kaç siparişim var?
select count(order_id),order_date from orders 
where ship_city = 'London' and extract(year from order_date) = 1998
group by order_date

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name, phone from customers c
inner join orders o on o.customer_id = c.customer_id
where extract(year from order_date) = 1997
group by contact_name, phone

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select order_id, freight from orders
where freight > 40
order by freight desc

--32.Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city, c.company_name as "ad_soyad", freight from orders o
inner join customers c on c.customer_id = o.customer_id
where freight > 40 
order by freight desc

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı 
--( ad soyad birleşik olacak ve büyük harf)
select o.order_date, o.ship_city, upper(e.first_name || ' ' || e.last_name) as "ad-soyad" from orders o
full join employees e on e.employee_id = o.employee_id
where extract(year from order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları
--( telefon formatı 2223322 gibi olmalı )
--translate('translate', 'rnlt', '123');
--replace(replace(c.phone,'-','.'),'.','')
--replace('abcdefabcdef', 'cd', 'XX')
select c.contact_name,translate(c.phone, '.- ', '') from customers c
inner join orders o on o.customer_id = c.customer_id 
where extract(year from order_date) = 1997

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date, c.contact_name, e.first_name || ' ' || e.last_name as "ad-soyad" from orders o
inner join customers c on c.customer_id = o.customer_id
inner join employees e on e.employee_id = o.employee_id
order by o.order_date desc

--36. Geciken siparişlerim?
select order_id, required_date, shipped_date from orders
where required_date < shipped_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_date, c.company_name, c.contact_name from orders o 
inner join customers c on c.customer_id = o.customer_id
where shipped_date > required_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select od.order_id, p.product_name, c.category_name, od.quantity from products p
inner join categories c on p.category_id = c.category_id
inner join order_details od on od.product_id = p.product_id
where od.order_id = 10248

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id, p.product_name, s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join order_details od on p.product_id = od.product_id
where od.order_id = 10248

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select e.first_name || ' ' || e.last_name as "ad-soyad", p.product_name, od.quantity, o.order_date
from order_details od
inner join orders o on od.order_id = o.order_id
inner join employees e on e.employee_id = o.employee_id
inner join products p on od.product_id = p.product_id
where e.employee_id = 3 and extract(year from order_date) = 1997

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name as "ad-soyad",
od.quantity*od.unit_price as "total price"
from orders o
inner join employees e on e.employee_id = o.employee_id
inner join order_details od on od.order_id = o.order_id
where extract(year from order_date) = 1997
order by "total price" desc
limit 1

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad
select sum(quantity * unit_price) as "Total_Sales_Price", e.employee_id, e.first_name, e.last_name from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
group by e.employee_id, e.first_name, e.last_name
order by "Total_Sales_Price" desc
limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select product_name, unit_price, category_name from products p
inner join categories c on c.category_id = p.product_id
order by unit_price desc
limit 1

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id from orders o
inner join employees e on e.employee_id = o.employee_id
order by order_date desc

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(quantity*unit_price), o.order_id,o.order_date from orders o
inner join order_details od on od.order_id = o.order_id 
group by o.order_id, o.order_date
order by order_date desc
limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity) as "Toplam Satis", o.order_date
from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where extract(month from o.order_date) = 01
group by p.product_name, c.category_name, o.order_date
order by o.order_date desc

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select od.order_id, sum(od.quantity) from order_details od
group by od.order_id
having sum(od.quantity) > (select avg(quantity) from order_details)

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name, sum(od.quantity) as "total sales"
from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
inner join order_details od on od.product_id = p.product_id
group by p.product_name, c.category_name, s.company_name
order by sum(od.quantity) desc
limit 1

--49. Kaç ülkeden müşterim var
select count(distinct o.ship_country) as "Country Number_" from orders o

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id, sum(od.unit_price * od.quantity) from order_details od
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = 3 and o.order_date between '01-01-1998' and current_date
group by e.employee_id

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where od.order_id = 10248
 
--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name from suppliers s
inner join products p on  p.supplier_id = s.supplier_id
inner join order_details od on od.product_id = p.product_id
where od.order_id = 10248

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity, o.order_date from products p
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
inner join employees e on o.employee_id = e.employee_id
where e.employee_id = 3 and extract(year from o.order_date) = 1997

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name as "AD-SOYAD", o.order_id, sum(od.quantity * od.unit_price)
from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
where extract(year from o.order_date) = 1997
group by e.employee_id, "AD-SOYAD", o.order_id
order by sum(od.quantity * od.unit_price) desc
limit 1

--55.  1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, e.first_name || ' ' || e.last_name as "AD-SOYAD", sum(od.quantity * od.unit_price)
from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
where extract(year from o.order_date) = 1997
group by e.employee_id, "AD-SOYAD"
order by sum(od.quantity * od.unit_price) desc
limit 1

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, od.unit_price, c.category_name from order_details od
inner join orders o on o.order_id = od.order_id
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
order by od.unit_price desc
limit 1

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name as "AD-SOYAD", o.order_date, o.order_id 
from orders o 
inner join employees e on e.employee_id = o.employee_id
order by o.order_date desc

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.quantity * od.unit_price) as "Ortalama Fiyat", od.order_id from order_details od
group by od.order_id
order by od.order_id desc
limit 5

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity * od.unit_price) from order_details od
inner join products p on p.product_id = od.product_id
inner join orders o on o.order_id = od.order_id
inner join categories c on c.category_id = p.category_id
where extract(month from o.order_date) = 01
group by c.category_name, p.product_name

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select od.order_id, sum(od.quantity) from order_details od
group by od.order_id
having sum(od.quantity) > (select avg(quantity) from order_details)

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
inner join suppliers s on s.supplier_id = p.supplier_id
group by p.product_name, c.category_name, s.company_name
order by sum(quantity) desc
limit 1

--62. Kaç ülkeden müşterim var
select count(distinct country) as "Ulke Sayisi" from customers

--63. Hangi ülkeden kaç müşterimiz var
select country, count(distinct customer_id) from customers
group by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select e.employee_id, sum(od.unit_price * od.quantity) from order_details od
inner join orders o on o.order_id = od.order_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = 3 and o.order_date between '01-01-1998' and current_date
group by e.employee_id

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.quantity * od.unit_price) from order_details od
inner join orders o on o.order_id = od.order_id
inner join products p on p.product_id = od.product_id
where p.product_id = 10 and o.order_date >= current_date - interval '3 months'

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id, count(distinct order_id) from orders o
right join employees e on e.employee_id = o.employee_id
group by e.employee_id

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.company_name, o.order_id from customers c
left join orders o on o.customer_id = c.customer_id
where o.order_id is null

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers
where country = 'Brazil'

--69. Brezilya’da olmayan müşteriler
select company_name, contact_name, address, city, country from customers
where country != 'Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers
where country = 'Spain' or country = 'France' or country = 'Germany'

--71. Faks numarasını bilmediğim müşteriler
select company_name, fax from customers
where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
select company_name, contact_name, address, city, country from customers
where city = 'London' or city = 'Paris'

--73. Hem México D.F.’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select city, company_name, contact_title from customers
where city = 'México D.F.' and contact_title = 'Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name like 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name, birth_date from employees 
where first_name like 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where company_name like '%Restaurant%' or company_name like '%Restaurante%' or company_name like '%restauration%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin
--(Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between '1996-07-01' and '1996-12-31'

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers
where country = 'Spain' or country = 'France' or country = 'Germany'

--80. Faks numarasını bilmediğim müşteriler
select company_name, fax from customers where fax is null

--81. Müşterilerimi ülkeye göre sıralıyorum:
select company_name, country from customers
order by country 

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price desc

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, 
--ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price desc, units_in_stock

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(product_id) from products p
inner join categories c on c.category_id = p.category_id
where c.category_id = 1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct country) from customers






