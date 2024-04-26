/*шаг 4*/ 
select 
COUNT(first_name) as customers_count
from customers;

/* считаем общее число покупателей (даже повторяющихся)*/

/*шаг 5*/ 
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
order by average_income
;


select 
concat(first_name, ' ', last_name) as seller,  /*селектим имя продавца, день недели и суммарную выручку по дням недели*/
to_char(sale_date, 'day') as day_of_week,
floor(sum(p.price * s.quantity)) as income
from sales s
inner join employees e
on e.employee_id = s.sales_person_id
inner join products p 
on s.product_id = p.product_id 
group by concat(first_name, ' ', last_name), day_of_week, extract(isodow from sale_date)
order by extract(isodow from sale_date), seller;   


/*шаг 6*/
select
    case
        when age between 16 and 25 then '16-25'
        when age between 26 and 40 then '26-40'
        when age > 40 then '40+'
    end as age_category,
    count(age) as age_count
from customers
group by 1
order by 1;


select 
to_char(s.sale_date,'YYYY-mm') as selling_month,
count(distinct(c.customer_id)) as total_customers,
floor(sum(p.price * s.quantity)) as income
from sales s
inner join customers c 
on s.customer_id = c.customer_id 
inner join products p 
on s.product_id = p.product_id
group by 1
order by 1;

with tab as (
    select distinct
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer,
        (
            select min(s.sale_date)
            from sales as s
            inner join products as p on s.product_id = p.product_id
            where p.price = 0
        ) as sale_date,
        concat(e.first_name, ' ', e.last_name) as seller
    from sales as s
    inner join customers as c
        on s.customer_id = c.customer_id
    inner join products as p
        on s.product_id = p.product_id
    inner join employees as e
        on s.sales_person_id = e.employee_id
    where p.price = 0
    group by
        concat(c.first_name, ' ', c.last_name),
        concat(e.first_name, ' ', e.last_name),
        s.sale_date,
        c.customer_id
    order by c.customer_id
)

select
    customer,
    sale_date,
    seller
from tab
order by customer;