
USE ProjectGroup6
Go


--Collect the customer’s reviews and and quantity of sales from each order to evaluate the product.
Create View Cosmetics.ProductReview as
Select p.ProductID,ProductName,sum(Quantity) as SalesQty,AVG(r.rating) as ProductsRating
from Cosmetics.Product p 
join Cosmetics.Review r
on p.ProductID = r.ProductID
join Cosmetics.OrderItems oi
on p.ProductID =oi.ProductID 
group by p.ProductID,ProductName

select * from  Cosmetics.ProductReview;



--Recommend suitable products based on customer’s skin type
Create View Cosmetics.Recommendation as
Select CustomerID,ProductName as Recommend_Product,ProductCategoryName
from Cosmetics.CustomerPersonalInfo cpi 
join Cosmetics.Subcategory s 
on cpi.SkinType = s.ProductSubcategoryName 
join Cosmetics.Product p
on s.ProductSubcategoryID =p.ProductSubcategoryID 
join Cosmetics.Category c 
on c.ProductCategoryID =s.ProductCategoryID 

select * from Cosmetics.Recommendation;


--Summarize the sales condition of each retailer with the best sales product and total sales.
Create View Cosmetics.RetailerSales as
with best_sales as
(select * from
(select retailerID, p.productID,productName,SUM(UnitPrice*Quantity) as salesamount, sum(Quantity)as Qty,
RANK()over(PARTITION by retailerID order by SUM(UnitPrice*Quantity)Desc)as rank
from Cosmetics.Orders o 
join Cosmetics.OrderItems oi 
on oi.OrderID =o.OrderID
join Cosmetics.Product p 
on p.ProductID =oi.ProductID 
group by RetailerID,p.ProductID,productName) temp1
where rank=1)
Select r.retailerID,retailerName,COUNT(distinct o.OrderID) as OrdQty,
productName as Best_Sales_Product,Qty as Best_Sales_Qty, salesamount as TotalSales
from Cosmetics.Retailers r 
join Cosmetics.Orders o 
on r.RetailerID =o.RetailerID 
join Cosmetics.OrderItems oi 
on oi.OrderID =o.OrderID 
join best_sales bs
on r.RetailerID =bs.retailerID
group by r.RetailerID,retailerName,productName,Qty,salesamount 

select * from Cosmetics.retailerSales
order by retailerID;

