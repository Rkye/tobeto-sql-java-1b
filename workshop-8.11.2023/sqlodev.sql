--1 Product isimlerini (`ProductName`) ve birim başına miktar
--  (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
select product_name, quantity_per_unit from products;

--2 Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`)
--  değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
select product_id, product_name,discontinued from products where discontinued = 1;

--3 Durdurulan Ürün Listesini, Ürün kimliği ve ismi 
--  (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
select product_id, product_name,discontinued from products where discontinued = 0;

--4 Ürünlerin maliyeti 20'dan az olan Ürün listesini
--  (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price < 20;

--5 Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini
--  (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price between 15 and 25;

--6 Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`)
--  stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order;

--7 İsmi `a` ile başlayan ürünleri listeleyeniz.
select product_name from products where product_name like 'A%';

--8 İsmi `i` ile biten ürünleri listeleyeniz.
select product_name from products where product_name like '%i';

--9 Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name , unit_price, (unit_price * 1.18) as unit_price_kdv from products;

--10 Fiyatı 30 dan büyük kaç ürün var?
select count(*) as units_bigger_30 from products where unit_price > 30;

--11 Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select unit_price, lower(product_name) from products order by unit_price desc;

--12 Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select e.first_name || ' ' || e.last_name as isim_soyisim from employees e;

--13 Region alanı NULL olan kaç tedarikçim var?
select count(*) from suppliers where region is null;

--14 a.Null olmayanlar?
select count(*) from suppliers where region is not null;

--15 Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select upper('TR' || '' || product_name) from products;

--16 a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select 'TR' || '' || product_name as pName, unit_price
from products 
where unit_price < 20;

--17 En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price
from products
where unit_price = (select MAX(unit_price) from products)

--18 En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price
from products
order by unit_price desc
limit 10; 

--19 Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price
from products
where unit_price > (select avg(unit_price) from products);

--20 Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select (unit_price*units_in_stock) as totalPrice from products;

--21 Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select count(product_id) from products where units_in_stock > 0 and discontinued = 1

--22 Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT category_name, product_name
FROM products p
FULL OUTER JOIN categories c on c.category_id = p.category_id;

--23 Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select category_name, avg(unit_price)
from products p
right join categories c on p.category_id = c.category_id
group by c.category_name;

--24 En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select product_name, unit_price, category_name
from products p
left join categories c on c.category_id = p.category_id 
order by unit_price desc limit 1;

--25 En çok satılan ürünümün adı, kategorisinin adı ve tedarikçisinin adı
select product_name, category_name, company_name, units_on_order 
from products p
left join categories c on c.category_id = p.category_id
left join suppliers s on s.supplier_id = p.supplier_id
order by units_on_order desc limit 1;