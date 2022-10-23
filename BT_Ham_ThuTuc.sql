use bank
go


--1.Kiểm tra một khách hàng nào đó đã tồn tại trong hệ thống CSDL của ngân hàng chưa nếu biết: 
--họ tên, số điện thoại của họ. Đã tồn tại trả về 1, ngược lại trả về 0

CREATE FUNCTION fCheckCust (@custName nvarchar(50), @custPhone varchar(13))
RETURNS int
AS
BEGIN
	DECLARE @result INT

    IF NOT EXISTS ( SELECT *
					FROM dbo.customer
					WHERE Cust_name = @custName AND Cust_phone = @custPhone)
	BEGIN
		SET @result = 0
	END
    
	ELSE 
	BEGIN
		SET @result = 1
	END

	RETURN @result

END

PRINT dbo.fCheckCust(N'Hà Công Lực', '01283388103')


--câu 2: Trả về tên, địa chỉ và số điện thoại của khách hàng nếu biết mã khách.

create function fPrintCust (@custId varchar(10))
returns table
as
return
	select  cust_name, cust_ad,  cust_phone  
	from customer 
	where cust_id = @custId

select * from dbo.fPrintCust('000001')



-- 3.In ra danh sách khách hàng của một chi nhánh cụ thể nếu biết mã chi nhánh đó.
create function fGetCustOfBranch (@brId varchar(10))
returns table
as
return select cust_id, cust_name, cust_ad 
from customer 
where br_id = @brId


select * from dbo.fGetcustOfBranch('VB001')

-- 4.Trả về tên chi nhánh ngân hàng nếu biết mã của nó.
create function fGetNameBranch (@branchId varchar(10))
returns nvarchar(100)
as
begin
	declare @result nvarchar(50)
	select @result = br_name 
	from branch 
	where br_id = @branchId

	return @result
end

print dbo.fGetNameBranch('VB001')

-- 5.Trả về tên của khách hàng nếu biết mã khách.
create function fGetCustName(@custId varchar(10))
returns nvarchar(50)
as 
begin 

	declare @custName nvarchar(50)

	select @custName = cust_name
	from customer 
	where cust_id = @custId

	return @custName

end

print N'Tên khách hàng: ' + dbo.fGetCustName('000001')

-- 6.Trả về số tiền có trong tài khoản nếu biết mã tài khoản.
create function fGetAcBalance(@acNo varchar(20))
returns int
as 
begin 

	declare @AcBalance int

	select @AcBalance = ac_balance
	from account 
	where ac_no = @acNo

	return @AcBalance

end


print  dbo.fGetAcBalance('1000000001')

--7. Trả về số lượng khách hàng nếu biết mã chi nhánh

create function fcountCust(@brId varchar(10))
returns int
as
begin
	declare @result int

	select @result = count(cust_id) 
	from customer
	where br_id = @brId

	return @result
end

print dbo.fcountCust('VT011')

--8.Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. Giao dịch bất thường: 
--giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am

create function fCheckTrans(@trans_id varchar(10))
returns nvarchar(100)
as 
begin
	declare @transType int, @transTime time, @result nvarchar(100)
	
	select @transType = t_type, @transTime = t_time from transactions where t_id = @trans_id

	if @transType = 0 
		begin
			if  @transTime between '00:00' and '03:00'
			begin
				set @result = N'Thời điểm rút tiền không hợp lệ'
			end

			else
			begin
				set @result = N'Rút tiền thành công'
			end	
		end

	else if @transType = 1
	begin
		if (@transTime between '08:00' and '12:00') or (@transTime between '13:00' and '17:00') 
		begin
			set @result = N'Gửi tiền thành công'
		end

		else
		begin
			set @result = N'Thời điểm gửi tiền không hợp lệ'
		end
	end

	return @result
end

print dbo.fCheckTrans('0000000210')

-- BÀI TẬP THỦ TỤC HOẶC HÀM 22 CÂU

-- 1.Trả về tên chi nhánh ngân hàng nếu biết mã của nó.

create function fGetNameBranch (@branchId varchar(10))
returns nvarchar(100)
as
begin
	declare @result nvarchar(50)
	select @result = br_name 
	from branch 
	where br_id = @branchId

	return @result
end

print dbo.fGetNameBranch('VB001')

-- 2.Trả về tên, địa chỉ và số điện thoại của khách hàng nếu biết mã khách.

create function fPrintCust (@custId varchar(10))
returns table
as
return
	select  cust_name, cust_ad,  cust_phone  
	from customer 
	where cust_id = @custId

select * from dbo.fPrintCust('000001')

-- 3. In ra danh sách khách hàng của một chi nhánh cụ thể nếu biết mã chi nhánh đó
	
create function fGetCustOfBranch (@brId varchar(10))
returns table
as
return select cust_id, cust_name, cust_ad 
from customer 
where br_id = @brId


select * from dbo.fGetcustOfBranch('VB001')

--4.Kiểm tra một khách hàng nào đó đã tồn tại trong hệ thống CSDL của ngân hàng chưa nếu biết: 
--họ tên, số điện thoại của họ. Đã tồn tại trả về 1, ngược lại trả về 0

CREATE FUNCTION fCheckCust (@custName nvarchar(50), @custPhone varchar(13))
RETURNS int
AS
BEGIN
	DECLARE @result INT

    IF NOT EXISTS ( SELECT *
					FROM dbo.customer
					WHERE Cust_name = @custName AND Cust_phone = @custPhone)
	BEGIN
		SET @result = 0
	END
    
	ELSE 
	BEGIN
		SET @result = 1
	END

	RETURN @result

END

PRINT dbo.fCheckCust(N'Hà Công Lực', '01283388103')

-- 5.Cập nhật số tiền trong tài khoản nếu biết mã số tài khoản và số tiền mới. 
--Thành công trả về 1, thất bại trả về 0
create proc fUpdateAcblanch(@acNo varchar(10), @newAcBalanch int)
as
begin
	update account 
	set ac_balance = @newAcBalanch
	where ac_no = @acNo

	if @@rowcount > 0
	begin
		print '1'
		return
	end
	else 
	begin
		print '0'
		return
	end
end

exec fUpdateAcblanch '1000000054', '197525000'



--6.Cập nhật địa chỉ của khách hàng nếu biết mã số của họ. Thành công trả về 1, thất bại trả về 0
create proc fUpdateCustAd(@CustId varchar(10), @newCustAd nvarchar(50))
as
begin
	update customer 
	set cust_ad = @newCustAd
	where cust_id = @CustId

	if @@rowcount > 0
	begin
		print '1'
		return
	end
	else 
	begin
		print '0'
		return
	end
end

exec fUpdateCustAd '000035', N'Huế'


-- 7.Trả về số tiền có trong tài khoản nếu biết mã tài khoản.


create function fGetAcBalance(@acNo varchar(20))
returns int
as 
begin 

	declare @AcBalance int

	select @AcBalance = ac_balance
	from account 
	where ac_no = @acNo

	return @AcBalance

end


print  dbo.fGetAcBalance('1000000001')

-- 8.Trả về số lượng khách hàng, tổng tiền trong các tài khoản nếu biết mã chi nhánh.
create function fGetCountAndSum (@branchId varchar(10))
returns nvarchar(100)
as
begin
		declare @countCust int, @sumAcNo int, @result nvarchar(100)

		select @countCust = count(customer.cust_id), @sumAcNo = sum(account.ac_balance)
		from customer join account on customer.cust_id = account.cust_id
		where customer.br_id = @branchId
		group by customer.br_id

		set @result = N'số lượng khách hàng: ' + cast(@countCust as varchar) + N' Tổng tiền trong các tài khoản: ' + cast(@sumAcNo as varchar)
		
		return @result
end

print dbo.fGetCountAndSum('VT011')
--
-- type table
create function fGetCountAndSum2 (@branchId varchar(10))
returns table
as
return
		select  count(customer.cust_id) as N'Số lượng', sum(account.ac_balance) as N'Tổng'
		from customer join account on customer.cust_id = account.cust_id
		where customer.br_id = @branchId
		group by customer.br_id

select * from dbo.fGetCountAndSum2('VT011')



--9. Kiểm tra một giao dịch có bất thường hay không nếu biết mã giao dịch. Giao dịch bất thường: 
--giao dịch gửi diễn ra ngoài giờ hành chính, giao dịch rút diễn ra vào thời điểm 0am  3am

create function fCheckTrans(@trans_id varchar(10))
returns nvarchar(100)
as 
begin
	declare @transType int, @transTime time, @result nvarchar(100)
	
	select @transType = t_type, @transTime = t_time from transactions where t_id = @trans_id

	if @transType = 0 
		begin
			if  @transTime between '00:00' and '03:00'
			begin
				set @result = N'Thời điểm rút tiền không hợp lệ'
			end

			else
			begin
				set @result = N'Rút tiền thành công'
			end	
		end

	else if @transType = 1
	begin
		if (@transTime between '08:00' and '12:00') or (@transTime between '13:00' and '17:00') 
		begin
			set @result = N'Gửi tiền thành công'
		end

		else
		begin
			set @result = N'Thời điểm gửi tiền không hợp lệ'
		end
	end

	return @result
end


print dbo.fCheckTrans('0000000254')

-- 10.Trả về mã giao dịch mới. Mã giao dịch tiếp theo được tính như sau: MAX(mã giao dịch đang có) + 1. 
--Hãy đảm bảo số lượng kí tự luôn đúng với quy định về mã giao dịch

create function fGetTransId()
returns varchar(10)
as
begin
	declare @result varchar(10)

	select  @result = replicate('0', 10 - len(max(t_id))) + cast(max(t_id) as varchar)
	from transactions

	return @result
end

print dbo.fGetTransId()

--11 Thêm một bản ghi vào bảng TRANSACTIONS nếu biết các thông tin ngày giao dịch, thời gian giao dịch, số tài khoản, loại giao dịch, số tiền giao dịch. Công việc cần làm bao gồm:
--a.Kiểm tra ngày và thời gian giao dịch có hợp lệ không. Nếu không, ngừng xử lý
--b.Kiểm tra số tài khoản có tồn tại trong bảng ACCOUNT không? Nếu không, ngừng xử lý
--c.Kiểm tra loại giao dịch có phù hợp không? Nếu không, ngừng xử lý
--d.Kiểm tra số tiền có hợp lệ không (lớn hơn 0)? Nếu không, ngừng xử lý
--e.Tính mã giao dịch mới
--f.Thêm mới bản ghi vào bảng TRANSACTIONS
--g.Cập nhật bảng ACCOUNT bằng cách cộng hoặc trừ số tiền vừa thực hiện giao dịch tùy theo loại giao dịch


--12.Thêm mới một tài khoản nếu biết: mã khách hàng, loại tài khoản, số tiền trong tài khoản. Bao gồm những công việc sau:
--a.Kiểm tra mã khách hàng đã tồn tại trong bảng CUSTOMER chưa? Nếu chưa, ngừng xử lý
--b.Kiểm tra loại tài khoản có hợp lệ không? Nếu không, ngừng xử lý
--c.Kiểm tra số tiền có hợp lệ không? Nếu NULL thì để mặc định là 50000, nhỏ hơn 0 thì ngừng xử lý.
--d.Tính số tài khoản mới. Số tài khoản mới bằng MAX(các số tài khoản cũ) + 1
--e.Thêm mới bản ghi vào bảng ACCOUNT với dữ liệu đã có.

-- 22.Sinh mã chi nhánh tự động. Sơ đồ thuật toán của module được mô tả như sau:
