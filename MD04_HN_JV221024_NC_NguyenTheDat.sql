create database QUANLYBANHANG;
use QUANLYBANHANG;
-- -BAI 1-------------- 
create table CUSTOMERS(
customer_id varchar (4) primary key,
name varchar (100) not null,
email varchar(100)not null, 
phone varchar(25) not null,
address varchar(255)not null
);
create table orders(
orderId varchar(4),
customer_id varchar(4),
primary key(orderId,customer_id),
total_amount double not null,
order_date date not null,
foreign key(customer_id) references CUSTOMERS(customer_id)
);
create table products(
product_id varchar(4) primary key,
name varchar(255) not null,
description text,
price double not null,
status bit(1)not null
);
create table orders_details(
orderId varchar(4),
product_id varchar(4),
primary key(orderId,product_id),
price  double,
quantity int(11),
foreign key(orderId) references orders(orderId),
foreign key(product_id) references products(product_id)
);
-- -------------BAI 2------------
insert into CUSTOMERS(customer_id,name,email,phone,address) value
						  ('C001','Nguyễn Trung Mạnh','manhnt@gmail.com',984756322,'Cầu Giấy,Hà Nội'),
						  ('C002','Hồ Hải Nam','namhh@gmail.com',984875926,'BA Vì,Hà Nội'),
                          ('C003','Tô Ngọc Vũ','vutn@gmail.com',904725784,'Mộc Châu,Sơn La'),
                          ('C004','Phạm Ngọc Anh ','anhpn@gmail.com',984635365,'Vinh,Nghệ An'),
                          ('C005','Trương Minh Cường','cuongtm@gmail.com',989735642,'Hai Bà Trưng,Hà Nội');
insert into products(product_id,name,description,price,status) value 
('P001','Iphone 13 ProMax','Bản 512 GB,xanh lá',22999999,1),
('P002','Dell Vostro','Core i5,RAM 8GB',14999999,1),
('P003','Marbook Pro M2','8CPU 10GPU 8GB 256GB',28999999,1),
('P004','Apple Watch Ultra','Titanium Alpine Loop Smail',18999999,1),
('P005','Airpods 2 2022','Spatial Audio',4090000,1);
insert into orders(orderId,customer_id,total_amount,order_date) value
('H001','C001',52999997,'2023/2/22'),
('H002','C001',80999997,'2023/3/11'),
('H003','C002',54359998,'2023/1/22'),
('H004','C003',102999995,'2023/3/14'),
('H005','C003',80999997,'2022/3/12'),
('H006','C004',110449994,'2023/2/1'),
('H007','C004',79999996,'2023/3/29'),
('H008','C005',29999998,'2023/2/14'),
('H009','C005',28999999,'2023/1/10'),
('H010','C005',149999994,'2023/4/1');
insert into orders_details(orderId,product_id,price,quantity)value
 ('H001','P002',14999999,1),
 ('H001','P004',18999999,2),
 ('H002','P001',22999999,1),
 ('H002','P003',28999999,2),
 ('H003','P004',18999999,2),
 ('H003','P005',4090000,4),
 ('H004','P002',14999999,3),
 ('H004','P003',28999999,2),
 ('H005','P001',22999999,1),
 ('H005','P003',28999999,2),
 ('H006','P005',4090000,5),
 ('H006','P002',14999999,6),
 ('H007','P004',18999999,3),
 ('H007','P001',22999999,1),
 ('H008','P002',14999999,2),
 ('H009','P003',28999999,1),
 ('H010','P003',28999999,2),
 ('H010','P001',22999999,4);
-- BÀI 3---------
-- 1--
select name,email,phone,address from CUSTOMERS;
-- 2-- 
select CUSTOMERS.name,CUSTOMERS.phone,CUSTOMERS.address 
from CUSTOMERS  join orders on orders.customer_id= CUSTOMERS.customer_id 
 where orders.order_date like "2023-03-%"
group by CUSTOMERS.customer_id ;
-- 3-- 
select month(ORDERS.order_date) as Month,
 sum(ORDERS.total_amount)　Revenue 
from ORDERS where year(ORDERS.order_date)=2023 
group by Month;
-- 4-- 
select CUSTOMERS.name, CUSTOMERS.address, CUSTOMERS.email, CUSTOMERS.phone from CUSTOMERS CUSTOMERS
where not exists (select 1 from orders where (CUSTOMERS.customer_id = orders.customer_id) and
orders.order_date like "2023-02-%");
-- 5-- 
select products.product_id, products.name, sum(orders_details.quantity) as Total from products products
join orders_details orders_details on orders_details.product_id = products.product_id 
join orders orders on orders_details.orderId = orders.orderId where 
orders.order_date like '2023/3/%' group by products.product_id;
-- 6-- 
select CUSTOMERS.customer_id, CUSTOMERS.name, sum(orders.total_amount) as Total from CUSTOMERS CUSTOMERS 
join orders orders on orders.customer_id = CUSTOMERS.customer_id where
 orders.order_date >2023/3  group by 
 CUSTOMERS.customer_id order by sum(orders.total_amount) desc; 

-- 7-- 
select CUSTOMERS.name, orders.total_amount as Total, orders.order_date, sum(orders_details.quantity) as "Product Total" from CUSTOMERS CUSTOMERS 
join orders orders on CUSTOMERS.customer_id = orders.customer_id
join orders_details orders_details on orders_details.orderId = orders.orderId 
group by orders.orderId
having sum(orders_details.quantity)>=5;

-- BAI 4----
-- 1-----
create view ORDERS_VIEW as select CUSTOMERS.name, CUSTOMERS.phone, CUSTOMERS.address, sum(orders.total_amount) 
as Total, orders.order_date from CUSTOMERS CUSTOMERS 
join orders orders on orders.customer_id = CUSTOMERS.customer_id group by orders.orderId;

-- 2-----
create view CUSTOMER_VIEW as select CUSTOMERS.name, CUSTOMERS.address, CUSTOMERS.phone, count(orders.orderId) as "Total Order" from CUSTOMERS CUSTOMERS 
join orders orders on orders.customer_id = CUSTOMERS.customer_id group by CUSTOMERS.customer_id;

-- 3-----
create view PRODUCT_VIEW as select products.name, products.description, products.price, sum(orders_details.quantity) as "Total Amount" from products products
join orders_details orders_details on orders_details.product_id = products.product_id group by products.product_id;

-- 4-----
create index CUSTOMER_PHONE_AND_EMAIL on CUSTOMERS(phone,email);

-- 5-----
DELIMITER 
create procedure PROC_SEARCH_CUSTOMER 
(in	cID varchar(4)
)
begin
	select * from CUSTOMERS where CUSTOMERS.customer_id= cID;
end 

-- 6-----
DELIMITER //
create procedure PROC_SEARCH_PRODUCT ()
begin
	select * from products;
end //
-- 7-----
DELIMITER //
create procedure PROC_SEARCH_ORDER 
(in	cID varchar(4)
)
begin
	select orders.order_id, p.name, sum(orders_details.quantity) as "total_product_amount", orders.total_amount from orders orders 
    join orders_details orders_details on orders_details.order_id = orders.order_id
    join products products on products.product_id = orders_details.product_id
    where orders.customer_id = cID
    group by orders.order_id;
end //

-- 8-----
DELIMITER //
create procedure PROC_CREATE_ORDER
(in	new_order_id varchar(4),
	new_customer_id varchar(4),
	new_order_date date,
	new_total_amount double	
)
begin
	insert into orders values (new_order_id,new_customer_id,new_order_date,new_total_amount);
		begin
			select * from orders where orders.order_id = new_order_id;
		end;
    
end //

-- 9-----
DELIMITER //
create procedure PROC_COUNT_PRODUCT
(in	start_date date,
	end_date date
)
begin
	select products.name, sum(orders_details.quantity) as "Total Quantity" from orders_details od
    join products products on products.product_id = orders_details.product_id 
    join orders orders on orders.order_id = orders_details.order_id
    where orders.order_date between start_date and end_date
    group by products.product_id;
    
end //

-- 10-----
DELIMITER //
create procedure PROC_COUNT_PRODUCT_ORDER_BY_DESC 
(in	target_month varchar (2),
	target_year varchar (10)
)
begin
	select products.name, sum(orders_details.quantity) as "Total Quantity" from orders_details od
    join products products on products.product_id = od.product_id 
    join orders orders on orders.order_id = orders_details.order_id
    where month(orders.order_date) = target_month and year(orders.order_date) = target_year
    group by products.product_id
    order by sum(orders_details.quantity) desc;
end//