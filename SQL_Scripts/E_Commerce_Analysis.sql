use e_commerce;

-- top 3 cities with highest number of customers
Select location,count(*) as number_of_customers
from customers
group by location
order by count(*) desc
limit 3;

-- Customers Distribution
with OrderDetail as(
select Count(Order_id) as NumberOfOrders
from orders 
group by Customer_id)
select NumberOfOrders, count(*) As CustomerCount
from OrderDetail
group by NumberOfOrders
order by NumberOfOrders;

-- Premium Products Trend
Select Product_id,avg(quantity) As AvgQuantity,
      Sum(quantity * price_per_unit) AS TotalRevenue
from orderdetails
group by Product_id
having avg(quantity) = 2
order by TotalRevenue desc; 

-- Category-Wise Customer reach
With Unique_Cust as (
Select distinct customer_id,
        Product_id
from Orders O join Orderdetails OD ON
O.order_id = OD.Order_id)
select category,count(distinct Customer_id) As unique_customers
from Products P join Unique_Cust U on
P.product_id = U.product_id
group by Category
order by count(Customer_id) desc;

-- month-on-month percentage change in total sales
With Sales_Change as (
select date_format(Order_date,'%Y-%m') as Month,
       sum(total_amount) as TotalSales,
     lag(sum(total_amount)) 
  over(order by date_format(Order_date,'%Y-%m')) as Prv_Sales
 from orders
 group by date_format(Order_date,'%Y-%m'))
 select Month ,TotalSales,
        round(((TotalSales - Prv_Sales)/Prv_Sales)*100,2) As PercentChange
from Sales_Change;

-- Month-on-month change in Average Order values
With Avg_Orders as (
select date_format(Order_date,'%Y-%m') as Month,
       round(avg(total_amount),2) as AvgOrderValue
 from Orders 
 group by Month)
 select Month,AvgOrderValue,round((AvgOrderValue - lag(AvgOrderValue) over(order by Month)),2)  as ChangeInValue
 from Avg_Orders
 order by ChangeInValue desc ;
 
 -- FAstest Turnover rates products
 Select product_id,Count(*) as SalesFrequency
 from orderdetails
 group by Product_id
 order by SalesFrequency desc
 limit 5;
 
 -- month-on-month growth rate in the customer base
 with FirstPurchase as (
 Select Customer_id,min(order_date) As FirstPurchase
 from  Orders
 group by customer_id)
 select date_format(FirstPurchase,'%Y-%m') as FirstPurchaseMonth,
        Count(*) as TotalNewCustomers 
 from FirstPurchase       
 group by date_format(FirstPurchase,'%Y-%m')
 order by date_format(FirstPurchase,'%Y-%m');
 
 -- months with the highest sales volume
 Select Date_format(Order_date,'%Y-%m') as Month,
           Sum(Total_amount) as TotalSales
 from Orders
 group by Date_format(Order_date,'%Y-%m')   
 order by    Sum(Total_amount) desc 
 limit 3;    