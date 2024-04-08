INSERT INTO "SELECT 
to_char(sale_date, 'yyyy-mm') as selling_month,
count(distinct s.customer_id) as total_customers,
floor(sum(s.quantity * p.price)) as income
from sales s 
inner join customers c 
on s.customer_id = c.customer_id 
inner join products p 
on s.product_id =p.product_id 
group by to_char(sale_date, 'yyyy-mm')" (selling_month,total_customers,income) VALUES
	 ('1992-09',226,2618930332),
	 ('1992-10',230,8358113698),
	 ('1992-11',228,8031353737),
	 ('1992-12',229,7708189846);
