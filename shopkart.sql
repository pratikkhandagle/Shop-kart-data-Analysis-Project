create database shopkart;
use shopkart;

use shopkart;

select * from shopkart_data;

EXEC sp_rename'Shopkart_cleaned_data' , 'shopkart_data';


-- 1. Total Sales, Profit & Margin
SELECT 
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit,
(SUM(Profit) * 100.0 / SUM(Revenue)) AS Profit_Margin_Percent
FROM shopkart_data;

-- 2.Negative Profit Impact ,Count & Total Loss
SELECT 
COUNT(*) AS Negative_Orders,
SUM(Profit) AS Total_Loss
FROM shopkart_data
WHERE Profit < 0;

--3. Loss by Category
SELECT Category,
COUNT(*) AS Loss_Orders,
SUM(Profit) AS Total_Loss
FROM shopkart_data
WHERE Profit < 0
GROUP BY Category
ORDER BY Total_Loss ASC;

--4. Average Discount in loss orders
SELECT Category,
AVG(Discount) AS Avg_Discount,
SUM(Profit) AS Total_Loss
FROM shopkart_data
WHERE Profit < 0
GROUP BY Category
ORDER BY Avg_Discount DESC;


--5. which state is high perform in the  profit
SELECT State,
SUM(Profit) AS Total_Profit
FROM shopkart_data
GROUP BY State
ORDER BY Total_Profit DESC;


--6.Top 10 Product wise Total loss
SELECT TOP 10
Product_Name,
SUM(Profit) AS Total_Loss
FROM shopkart_data
where profit < 0
GROUP BY Product_Name
ORDER BY Total_Loss DESC;

select * from shopkart_data;



--7.which customers they make highest profit and their total orders
SELECT TOP 10
Customer_ID,
SUM(Profit) AS Total_Profit,
COUNT(Order_ID) AS Total_Orders
FROM shopkart_data
GROUP BY Customer_ID
ORDER BY Total_Profit DESC;

--8. what % of Total Profit Is Lost
SELECT 
(SUM(CASE WHEN Profit < 0 THEN Profit ELSE 0 END) * 100.0 
/ SUM(Profit)) AS Loss_Percentage
FROM shopkart_data;

--9.what % of oreders they making loss
SELECT 
    COUNT(CASE WHEN Profit < 0 THEN 1 END) * 100.0 
    / COUNT(*) AS Loss_Order_Percentage
FROM shopkart_data;

--10.Which Products Have Highest Loss Rate %
SELECT Product_Name,
COUNT(CASE WHEN Profit < 0 THEN 1 END) * 100.0 / COUNT(*) AS Loss_Rate_Percent
FROM shopkart_data
GROUP BY Product_Name
ORDER BY Loss_Rate_Percent DESC;

-- 11. How Many Discount applied and make profit
SELECT Discount,
SUM(Profit) AS Total_Profit
FROM shopkart_data
GROUP BY Discount
ORDER BY Discount DESC;

-- 12.Which Customers Generate Loss
SELECT Customer_ID,
SUM(Profit) AS Total_Profit
FROM shopkart_data
GROUP BY Customer_ID
HAVING SUM(Profit) < 0
ORDER BY Total_Profit DESC;

-- 13 .which state made high profit margin 
SELECT State,
SUM(Profit) * 100.0 / SUM(Revenue) AS Profit_Margin
FROM shopkart_data
GROUP BY State
ORDER BY Profit_Margin DESC;


-- 14. what is the monthly profit
SELECT 
YEAR(Order_Date) AS Year,
MONTH(Order_Date) AS Month,
SUM(Profit) AS Monthly_Profit
FROM shopkart_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;


--15. Which payment method made high profit and discount
select Payment_Method,
sum(Profit) as Payment_method_wise_profit,
sum(Discount) as Discount
from shopkart_data
group by Payment_Method
order by sum(Profit)  ASC;


--16. Which order status made high profit and revenue
select sum(Revenue)as Total_Revenue ,Order_Status,
sum(Profit) as profit_by_order_status
from shopkart_data
group by Order_Status
order by sum(Profit) DESC;


--17. which city is generate the high revenue
select distinct(City) as City,
sum(Revenue) as Total_revenue
from shopkart_data
group by City
order by Total_revenue DESC;

select * from shopkart_data;

--18.which gender is made highest profit
select distinct(Gender), 
sum(Profit) as Gender_wise_profit
from shopkart_data
group by Gender
order by Gender DESC;

--19.Which are the top 10 best selling products
select top 10 Product_Name,
sum(Revenue) as total_revenue
from shopkart_data
group by Product_Name
order by total_revenue DESC;

--20.Which top 5 products generate the highest profit
select top 5 Product_Name,
sum(Profit) as Profit
from shopkart_data
group by Product_Name
order by Profit DESC;

--21.Which month have highest sales
select month(Order_Date) as month,
sum(Quantity) as Total_Quantity,
sum(Revenue) as Total_Revenue
from shopkart_data
group by month(Order_Date)
order by Total_Quantity DESC; 

--22.Which year has the highest sales
select year(Order_Date) as year,
sum(Quantity) as Total_Quantity,
sum(Revenue) as Total_Revenue
from shopkart_data
group by year(Order_Date)
order by Total_Quantity DESC; 

--23.Which category generates the most sales
SELECT Category,
SUM(Revenue) AS Total_Sales
FROM shopkart_data
GROUP BY Category
ORDER BY Total_Sales DESC;

--24.What are the least selling products
SELECT TOP 10 Product_Name,
SUM(Quantity) AS Total_Sales
FROM shopkart_data
GROUP BY Product_Name
ORDER BY Total_Sales ASC;

--25.Classify customers into High / Medium / Low value according to revenue
SELECT 
Customer_ID,
SUM(Revenue) AS Total_Revenue,
CASE 
    WHEN SUM(Revenue) > 500000 THEN 'High Value'
    WHEN SUM(Revenue) BETWEEN 100000 AND 500000 THEN 'Medium Value'
    ELSE 'Low Value'
END AS Customer_Type
FROM shopkart_data
GROUP BY Customer_ID;


--26.
SELECT 
CASE 
WHEN COUNT(Order_ID) = 1 THEN 'One Time'
ELSE 'Repeat'
END AS Customer_Type,
COUNT(DISTINCT (Customer_ID)) AS Total_Customers
FROM shopkart_data
GROUP BY Customer_ID;


--27. Top 3 Products in Each Category 
WITH ranked_products AS (
SELECT 
Category,
Product_Name,
SUM(Revenue) AS Total_Revenue,
RANK() OVER(PARTITION BY Category ORDER BY SUM(Revenue) DESC) AS rnk
FROM shopkart_data
GROUP BY Category, Product_Name
)
SELECT *
FROM ranked_products
WHERE rnk <= 3;

--28.Which category is make high profit contribution
SELECT 
Category,
SUM(Profit) AS Total_Profit,
SUM(Profit) * 100.0 / 
(SELECT SUM(Profit) FROM shopkart_data) AS Profit_Contribution_Percent
FROM shopkart_data
GROUP BY Category
ORDER BY Total_Profit DESC;

--29.what is  the profit without loss
SELECT 
SUM(CASE WHEN Profit > 0 THEN Profit ELSE 0 END) AS Profit_Without_Loss
FROM shopkart_data;


SELECT 
CASE 
    WHEN Discount <= 10 THEN 'Low Discount'
    WHEN Discount BETWEEN 11 AND 30 THEN 'Medium Discount'
    ELSE 'High Discount'
END AS Discount_Group,
SUM(Profit) AS Total_Profit
FROM shopkart_data
GROUP BY 
CASE 
    WHEN Discount <= 10 THEN 'Low Discount'
    WHEN Discount BETWEEN 11 AND 30 THEN 'Medium Discount'
    ELSE 'High Discount'
END;   this all queries right for report and documentation