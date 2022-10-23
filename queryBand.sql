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

SELECT t_id, ac_no, t_time
FROM  transactions
where t_type = 1 and (t_time not between '08:00:00' and '12:00:00') and (t_time not between '13:30:00' and '17:00:00') 

 --12 Liệt kê những giao dịch rút tiền diễn ra vào khoảng từ 0-3h sáng

 SELECT t_id, ac_no, t_time
 FROM  transactions
 where t_type = 0 and t_time between '00:00:00' and '03:00:00'

 --13 Tìm những khách hàng có địa chỉ ở Ngũ Hành Sơn – Đà nẵng

select * 
from customer
where Cust_ad like N'%Ngũ Hành Sơn%' and  Cust_ad like N'%Đà nẵng%'

--14 Liệt kê những chi nhánh chưa có địa chỉ 1 

select * from branch
where BR_ad IS NULL


 --15 Liệt kê những giao dịch rút tiền bất thường (nhỏ hơn 50.000)
  SELECT *
 FROM  transactions
 where t_amount < 50000 and t_type = 0

 -- 16. Liệt kê các giao dịch gửi tiền diễn ra trong năm 2017. 
 SELECT *
 FROM  transactions
 where YEAR(t_date) = 2017 and t_type = 1
 -- 17 Liệt kê những giao dịch bất thường (tiền trong tài khoản âm)
 SELECT *
 FROM  account 
 where ac_balance < 0 
 select * from transactions
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
select  Cust_id, Cust_name, parsename(replace(Cust_name, ' ', '.'), 1)
from customer
where parsename(replace(Cust_name, ' ', '.'), 1) like N'_[u, ũ, a]%'

-- 25. Thống kê số lượng giao dịch, tổng số tiền giao dịch theo loại
select t_type,  count(t_id) as 'So luong giao dich', sum(t_amount) as 'tong so tien'
from transactions
group by t_type


--26 Có bao nhiêu khách hàng có địa chỉ ở Huế
select  count(cust_id) as 'so luong'
from customer
where cust_ad like N'%Huế%'

--36 Số tiền trung bình của mỗi lần thực hiện giao dịch rút tiền trong năm 2017 là bao nhiêu
select  cast(avg(t_amount) as int) as 'Trung Binh'
from transactions
where year(t_date) = 2017 and t_type = 0

-- 1 Có bao nhiêu khách hàng có địa chỉ ở Quảng Nam thuộc chi nhánh ngân hàng vietcombank Đà Nẵng
select count(Cust_id) N'Số lượng khách hàng'
from customer join branch
on customer.br_id = branch.Br_id
where customer.cust_ad like N'%Quảng Nam%' and branch.BR_name like N'% Đà Nẵng%'

--2 Hiển thị Danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ
select customer.cust_id, customer.cust_name, branch.BR_name, sum(account.ac_balance) N'Số Tiền trong tài khoản'
from customer join branch on customer.br_id = branch.Br_id 
             join account on customer.cust_id = account.cust_id
where  branch.BR_name like N'%Vũng tàu%'
group by customer.cust_id, customer.cust_name, branch.BR_name

--3 Trong quý 1 năm 2012, Có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại ngân hàng Vietcombank


select count(cus.Cust_id) as 'Số lượng khách hàng' 
from customer as cus join branch as br on cus.Br_id = br.Br_id 
							join account as ac on cus.cust_id = ac.cust_id
							join transactions as trans on ac.Ac_no = trans.ac_no
where br.Br_name like N'%Vietcombank%' and trans.t_type = 0 and year(trans.t_date) = 2017 and month(trans.t_date) between 1 and 3 





--1> Mùa thu năm 2012, khách hàng Trần Văn Thiện Thanh thực hiện bao nhiêu giao dịch?


select count(trans.t_id) as 'Số lượng giao dịch' 
from customer as cus join account as ac on cus.cust_id = ac.cust_id
					join transactions as trans on ac.Ac_no = trans.ac_no
where cus.Cust_name = 'Trần Văn Thiện Thanh' and  year(trans.t_date) = 2017 and month(trans.t_date) between 7 and 9 

-- 2> tổng tiền đã gửi vào Vietcombank chi nhánh Đà Nẵng năm 2013 là bao nhiêu?

select sum(trans.t_amount) as 'Tổng tiền' 
from customer as cus join branch as br on cus.Br_id = br.Br_id 
					 join account as ac on cus.cust_id = ac.cust_id
					 join transactions as trans on ac.Ac_no = trans.ac_no
where year(trans.t_date) = 2013 and br.Br_name = N'Vietcombank Đà Nẵng' and trans.t_type = 1


--3> Số tiền trung bình đã gửi vào chi nhánh Huế từ trước đến nay là bao nhiêu

select AVG(trans.t_amount) as 'Số tiền trung bình' 
from customer as cus join branch as br on cus.Br_id = br.Br_id 
							join account as ac on cus.cust_id = ac.cust_id
							join transactions as trans on ac.Ac_no = trans.ac_no
where br.Br_name like N'%Huế%' and trans.t_type = 1

--4> Có bao nhiêu khách cùng chi nhánh với Trần Văn Thiện Thanh
select count(cust_id) - 1 SLKH
from customer
where Br_id = (
				select Br_id
				from customer where Cust_name like N'Trần Văn Thiện Thanh'
			)

--6> Chi nhánh Sài Gòn có những khách hàng nào không thực hiện bất kì giao dịch nào trong vòng 3 năm trở lại đây
-- Nếu có thể, hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý



--8> Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhanh Huế.
-- Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó.

--17> Ông phạm Duy Khách thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch
--gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu.

--33> Thời gian vừa qua, hệ thống CSDL của ngân hàng bị hacker tấn công (giả sử),
--tổng tiền trong tài khoản bị thay đổi bất thường. Hãy liệt kê những tài khoản bất thường đó.
--Gợi ý: tài khoản bất thường là tài khoản có tổng tiền gửi - tổng tiền rút <> số tiền trong tài khoản 
