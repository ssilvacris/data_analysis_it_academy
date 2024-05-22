-- Data Analysis Specialization - IT Academy
-- Tarea S2.01. Nociones básicas SQL
-- Cristiane de Souza da Silva
-- 05/2024

-- Nivel 1
-- Ejercicio 1 ( archivo adjunto )

-- Ejercicio 2
-- Utilizando JOIN realizarás las siguientes consultas:
-- Listado de los países que están realizando compras.
        
select distinct(company.country),  transaction.declined as not_declined
from company join transaction
on  company.id = transaction.company_id
having not_declined = 0; --  compras realizadas por los paises cuyas transacciones fueron aceptadas.
        
-- Desde cuántos países se realizan las compras..
        
select count(distinct company.country) as countries_bought,  transaction.declined as not_declined
from company join transaction
on  company.id = transaction.company_id
where transaction.declined = 0; --  compras realizadas cuyas transacciones fueron aceptadas.
            
-- Identifica a la compañía con la mayor media de ventas.
        
select company.company_name, avg(transaction.amount) as highest_average_sales
from company join transaction
on company.id = transaction.company_id
where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
        group by company.company_name
        order by highest_average_sales desc
        limit 1;
        
        
-- Ejercicio 3
-- Utilizando sólo subconsultas (sin utilizar JOIN):
-- Muestra todas las transacciones realizadas por empresas de Alemania.
            
select id as transactions_Germany
from transaction
where company_id in (
	select id  -- subquery con las empresas alemanes
	from company
	where country in ('Germany')
	);
                
-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
select company_name as company_amount_greater_average
from company
where id in (
	select company_id -- subquery con las companias con trasaciones por encima del promedio 
	from transaction
	where amount >(
		select avg(amount) -- subquery con el promedio de todas las transaciones 
		from transaction
		)
);
                
-- Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.
            
select company_name as companies_wo_records
from company 
	where id not in (
	select company_id 
	from transaction
            ); 
        -- Todas las empresas tienen transaciones registradas

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
-- Nivel 2
-- Ejercicio 1
-- Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.

select cast(timestamp as date) as date_most_sales , sum(amount) as total_sales_day -- cast: cambia el valor para fecha sin la hora
from transaction
where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
group by date_most_sales
order by total_sales_day desc
limit 5;


-- Ejercicio 2
-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
		
select company.country, avg(transaction.amount) as average_sales
from company join transaction
on company.id = transaction.company_id
where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
group by country
order by average_sales desc;

-- Ejercicio 3
/* En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias 
para hacer competencia a la compañía "Non Institute". Para ello, te piden la lista de todas 
las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.*/
-- Muestra el listado aplicando JOIN y subconsultas.
            
select transaction.id, company.company_name, company.country
from company join transaction
on company.id = transaction.company_id
where company.country = (
	select country
	from company
	where company_name = "Non Institute"
				)
and company.company_name <> "Non Institute"
          ;                
				

-- Muestra el listado aplicando solo subconsultas.

select id, company_id
from transaction
where company_id in (
	select  id
	from company
	where country = (
		select country
		from company
		where company_name = "Non Institute"
		)
	and company_name <> "Non Institute" -- solamente las empresas del mismo pais de Non Institute.
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Nivel 3
-- Ejercicio 1
/* Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones
 con un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021, 
 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.*/
 
select  company.company_name, company.phone, tabladates.timestamp, tabladates.amount as amount_100_200
from company join
	(select * 
	from transaction
	where (timestamp like '2021-04-29%' or timestamp like '2021-07-20%' or timestamp like '2022-03-13%')
	and amount > 100 and amount < 200) as tabladates
on tabladates.company_id = company.id
order by amount_100_200 desc ;

-- Ejercicio 2
/* Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que 
se requiera, por lo que te piden la información sobre la cantidad de transacciones que realizan 
las empresas, pero el departamento de recursos humanos es exigente y quiere un listado de las empresas 
donde especifiques si tienen más de 4 o menos transacciones.*/

select company.company_name, if(count(transaction.id) > 4, 'Yes', 'No') as 'more than 4 transactions'
from company join transaction
on  company.id = transaction.company_id
group by company.company_name;
