select 
concat(first_name, ' ', last_name) as seller,   /*селектим имя продавца, подсчитываем количество операций по айдишникам продавцов, считаем суммарную выручку*/
count(sales_person_id) as operations,
floor(sum(p.price * s.quantity)) as income
from sales s
inner join employees e
on e.employee_id = s.sales_person_id
inner join products p 
on s.product_id = p.product_id 
group by concat(first_name, ' ', last_name)
order by income desc
limit 10;

with tab as (
select                /*делаем соединение, находим среднюю выручку каждого продавца и через подзапрос находим среднее по всем продавцам*/
concat(first_name, ' ', last_name) as seller,
floor(avg(p.price * s.quantity)) as average_income
from sales s
inner join employees e
on e.employee_id = s.sales_person_id
inner join products p 
on s.product_id = p.product_id 
group by concat(first_name, ' ', last_name)
)
select 
seller,
average_income
from tab 
group by seller, average_income
HAVING (SELECT avg(average_income) FROM tab) > average_income
;


select 
concat(first_name, ' ', last_name) as seller,  /*селектим имя продавца, день недели и суммарную выручку по дням недели*/
to_char(sale_date, 'Day') as day_of_week,
floor(sum(p.price * s.quantity)) as income
from sales s
inner join employees e
on e.employee_id = s.sales_person_id
inner join products p 
on s.product_id = p.product_id 
group by concat(first_name, ' ', last_name), day_of_week, extract(isodow from sale_date)
order by extract(isodow from sale_date), seller;  