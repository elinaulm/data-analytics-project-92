/*шаг 4*/
select COUNT(first_name) as customers_count
from customers;

/* считаем общее число покупателей (даже повторяющихся)*/

/*шаг 5*/
select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    COUNT(s.sales_person_id) as operations,
    FLOOR(SUM(p.price * s.quantity)) as income
from sales as s
inner join employees as e
    on s.sales_person_id = e.employee_id
inner join products as p
    on s.product_id = p.product_id
group by CONCAT(e.first_name, ' ', e.last_name)
order by income desc
limit 10;


with tab as (
    select
        CONCAT(e.first_name, ' ', e.last_name) as seller,
        FLOOR(AVG(p.price * s.quantity)) as average_income
    from sales as s
    inner join employees as e
        on s.sales_person_id = e.employee_id
    inner join products as p
        on s.product_id = p.product_id
    group by CONCAT(e.first_name, ' ', e.last_name)
)

select
    seller,
    average_income
from tab
group by seller, average_income
having (select AVG(average_income) from tab) > average_income
order by average_income;


select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    /*селектим имя продавца, день недели и суммарную выручку по дням недели*/
    TO_CHAR(s.sale_date, 'day') as day_of_week,
    FLOOR(SUM(p.price * s.quantity)) as income
from sales as s
inner join employees as e
    on s.sales_person_id = e.employee_id
inner join products as p
    on s.product_id = p.product_id
group by
    CONCAT(e.first_name, ' ', e.last_name),
    day_of_week,
    EXTRACT(isodow from s.sale_date)
order by EXTRACT(isodow from s.sale_date), seller;


/*шаг 6*/
select
    case
        when age between 16 and 25 then '16-25'
        when age between 26 and 40 then '26-40'
        when age > 40 then '40+'
    end as age_category,
    COUNT(age) as age_count
from customers
group by 1
order by 1;


select
    TO_CHAR(s.sale_date, 'YYYY-mm') as selling_month,
    COUNT(distinct c.customer_id) as total_customers,
    FLOOR(SUM(p.price * s.quantity)) as income
from sales as s
inner join customers as c
    on s.customer_id = c.customer_id
inner join products as p
    on s.product_id = p.product_id
group by 1
order by 1;


with tab as (
    select
        id,
        customer,
        min(sale_date) as sale_date
    from (
        select
            p.price,
            --скрещиваем имя и фамилию покупателя
            c.customer_id as id,
            s.sale_date,
            concat(c.first_name, ' ', c.last_name) as customer
        from sales as s
        inner join products as p
            on s.product_id = p.product_id --соединяем таблицы по id
        inner join customers as c
            on s.customer_id = c.customer_id --соединяем таблицы по id
    ) as fool
    where price = 0 --выделяем только строки со значением цены 0
    group by 1, 2 --группируем по id и customer
)

select
    tab.customer,
    tab.sale_date,
    --соединяем имя и фамилию сотрудника, выделяем самого первого
    min(concat(e.first_name, ' ', e.last_name)) as seller
from tab
inner join sales as s
    on tab.id = s.customer_id --соединяем таблицы по id
inner join employees as e
    on s.sales_person_id = e.employee_id --соединяем по id
group by tab.customer, tab.sale_date;


