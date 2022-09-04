use Bank
go

--1. Liệt kê danh sách khách hàng ở Đà Nẵng


select customer.Cust_id, Cust_name, Cust_ad, account.Ac_no
from customer, account
where cust_ad LIKE N'%Đà Nẵng'

--2. Liệt kê những tài khoản loại VIP (type = 1)

SELECT *
FROM account
WHERE ac_type=1

--3. Liệt kê những khách hàng không sử dụng số điện thoại của Mobi phone
SELECT  *
FROM customer 
WHERE Cust_phone not in (SELECT  Cust_phone
						FROM customer 
						WHERE Cust_phone LIKE '_[90,93,89]%')


--4. Liệt kê những khách hàng họ Phạm
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE N'Phạm%'

--5. Liệt kê những khách hàng tên chứa chữ g
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE '%g%'

--6. Liệt kê những khách hàng chữ cái thứ 2 của tên là chữ H, T, A, Ê
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name LIKE N'_[h,t,a,à,ạ,ã,á,ă,â,ê]%'
 
 --7. Liệt kê những giao dịch diễn ra trong quý IV năm 2016
 SELECT ac_no, t_id, t_date
 FROM  transactions
 WHERE  YEAR(t_date)='2016' AND (MONTH(t_date) between 10 and 12)

 --8. Liệt kê những giao dịch diễn ra trong mùa thu năm 2016
 SELECT ac_no, t_id, t_date
 FROM  transactions
 WHERE  YEAR(t_date)='2016' AND (MONTH(t_date) between 8 and 10)

 --9. Liệt kê những khách hàng không thuộc các chi nhánh miền bắc

 SELECT Cust_id, Cust_name, BR_id
 FROM  customer
 WHERE BR_id NOT LIKE 'VB%'

 --10. Liệt kê những tài khoản nhiều hơn 100 triệu trong tài khoản
 SELECT *
 FROM account
 WHERE ac_balance > 100000000


 --11 Liệt kê những giao dịch gửi tiền diễn ra ngoài giờ hành chính

SELECT t_id, ac_no, DATEPART(HOUR,t_time) as 'Time'
FROM  transactions
where (DATEPART(HOUR,t_time) between 17 and 23) or (DATEPART(HOUR,t_time) between 0 and 7) or (DATEPART(HOUR,t_time) between 11 and 13)
				 

 --12 Liệt kê những giao dịch rút tiền diễn ra vào khoảng từ 0-3h sáng

 SELECT t_id, ac_no, DATEPART(HOUR,t_time) as 'Time', DATEPART(minute,t_time) as 'minute'
 FROM  transactions
 where DATEPART(HOUR,t_time) between 0 and 3

 --13 Tìm những khách hàng có địa chỉ ở Ngũ Hành Sơn – Đà nẵng

select * 
from customer
where Cust_ad like N'%Ngũ Hành Sơn%' and  Cust_ad like N'%Đà nẵng%'

--14 Liệt kê những chi nhánh chưa có địa chỉ 1 XXX

select * from branch
where BR_ad IS NULL


 --15 Liệt kê những giao dịch rút tiền bất thường (nhỏ hơn 50.000) XXX
  SELECT *
 FROM  transactions
 where t_amount < 50000 and t_type = 1

 -- 16. Liệt kê các giao dịch gửi tiền diễn ra trong năm 2017. XXX
 SELECT *
 FROM  transactions
 where YEAR(t_date) = 2017 and t_type = 0
 -- 17 Liệt kê những giao dịch bất thường (tiền trong tài khoản âm)
 SELECT *
 FROM  account
 where ac_balance < 0 
-- 18. Hiển thị tên khách hàng và tên tỉnh/thành phố mà họ sống

select  Cust_name, PARSENAME(replace(replace(replace(Cust_ad, '.', ''), '-', '.'), ',', '.'), 1) as 'Tên Tỉnh/ Thành Phố'
from customer


--19 Hiển thị danh sách khách hàng có họ tên không bắt đầu bằng chữ N, T
SELECT Cust_id, Cust_name
FROM customer
WHERE Cust_name  LIKE N'[^N,T]%'

-- 20. Hiển thị danh sách khách hàng có kí tự thứ 3 từ cuối lên là chữ a, u, i ()

select  Cust_id, Cust_name, RIGHT(Cust_name, 3)
from customer
where RIGHT(Cust_name, 3) like N'[a, â, ă, u, ư, i]%'

--21. Hiển thị khách hàng có tên đệm là Thị hoặc Văn
select  Cust_id, Cust_name
from customer
where (parsename(replace(Cust_name, ' ', '.'), 2) = N'Thị') or (parsename(replace(Cust_name, ' ', '.'), 2) = N'Văn')


--22. Hiển thị khách hàng có địa chỉ sống ở vùng nông thôn. Với quy ước: nông thôn là vùng mà địa chỉ chứa: thôn, xã, xóm
select cust_id, cust_name, cust_ad from customer
where (cust_ad like N'%thôn%') or (cust_ad like N'%xã%') or (cust_ad like N'%xóm%')


--23 Hiển thị danh sách khách hàng có kí tự thứ hai của TÊN là chữ u hoặc ũ hoặc a. Chú ý: TÊN là từ cuối cùng của cột cust_name
select  Cust_id, Cust_name
from customer
where parsename(replace(Cust_name, ' ', '.'), 1) like N'_[u, ũ, a]%'