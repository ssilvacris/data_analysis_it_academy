-- Data Analysis Specialization - IT Academy
-- Tarea S2.01. Nociones básicas SQL
-- Cristiane de Souza da Silva
-- 05/2024

-- Nivel 1
-- Ejercicio 1 ( archivo adjunto )

-- Ejercicio 2
-- Utilizando JOIN realizarás las siguientes consultas:
-- Listado de los países que están realizando compras.
        
select distinct(country)  
from company c join transaction t
on  c.id = t.company_id; 
        
-- Desde cuántos países se realizan las compras.
	
select count(distinct country) as countries_bought
from company c join transaction t
on  c.id = t.company_id; 
            
-- Identifica a la compañía con la mayor media de ventas.
        
select company_name, round(avg(amount), 2) as highest_average_sales
from company c join transaction t
on c.id = t.company_id
where t.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
        group by c.company_name
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
select *
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
	where  id not in (
	select company_id 
	from transaction
            ); 
        -- Todas las empresas tienen transaciones registradas

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --         
-- Nivel 2
-- Ejercicio 1
/*Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
Muestra la fecha de cada transacción junto con el total de las ventas.*/

select cast(timestamp as date) as date_most_sales , sum(amount) as total_sales_day -- cast: cambia el valor para fecha sin la hora
from transaction
where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
group by date_most_sales
order by total_sales_day desc
limit 5;


-- Ejercicio 2
-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
		
select c.country, round(avg(t.amount),2) as average_sales
from company c join transaction t
on c.id = t.company_id
where t.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
group by country
order by average_sales desc;

-- Ejercicio 3
/* En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias 
para hacer competencia a la compañía "Non Institute". Para ello, te piden la lista de todas 
las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.*/
-- Muestra el listado aplicando JOIN y subconsultas.
            
select t.id, c.company_name, c.country
from company c join transaction t
on c.id = t.company_id
where c.country = (
	select country
	from company
	where company_name = "Non Institute"
				)
and c.company_name <> "Non Institute";                
				

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
 
select  c.company_name, c.country,  c.phone, tabladates.timestamp, tabladates.amount as amount_100_200
from company c join
	(select * 
	from transaction t
	where (timestamp like '2021-04-29%' or timestamp like '2021-07-20%' or timestamp like '2022-03-13%')
	and amount > 100 and amount < 200) as tabladates
on company_id = c.id
where declined = 0
order by amount_100_200 desc ;

-- Ejercicio 2
/* Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que 
se requiera, por lo que te piden la información sobre la cantidad de transacciones que realizan 
las empresas, pero el departamento de recursos humanos es exigente y quiere un listado de las empresas 
donde especifiques si tienen más de 4 o menos transacciones.*/

select c.company_name, count(t.id) as quant_transactions, if(count(t.id) > 4, 'Yes', 'No') as 'more than 4 transactions'
from company c join transaction t
on  c.id = t.company_id
group by c.company_name
order by quant_transactions desc;
