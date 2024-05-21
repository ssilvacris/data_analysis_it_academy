-- Data Analysis Specialization - IT Academy
-- Tasca S2.01. Nocions bàsiques SQL
-- Cristiane de Souza da Silva
-- 05/2024

-- Nivel 1
	-- Exercici 1 ( annex 1)

	-- Exercici 2
		-- Utilitzant JOIN realitzaràs les següents consultes:
		-- Llistat dels països que estan fent compres.
        
        select distinct(company.country),  transaction.declined as not_declined
        from company join transaction
        on  company.id = transaction.company_id
        having not_declined = 0; --  compras realizadas por los paises cuyas transacciones fueron aceptadas.
        
		-- Des de quants països es realitzen les compres.
        
        select count(distinct company.country) as countries_bought,  transaction.declined as not_declined
        from company join transaction
        on  company.id = transaction.company_id
        where transaction.declined = 0; --  compras realizadas cuyas transacciones fueron aceptadas.
            
		-- Identifica la companyia amb la mitjana més gran de vendes.
        
        select company.company_name, avg(transaction.amount) as highest_average_sales
        from company join transaction
		on company.id = transaction.company_id
        where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
        group by company.company_name
        order by highest_average_sales desc
        limit 1;
        
        
	-- Exercici 3
		-- Utilitzant només subconsultes (sense utilitzar JOIN):
			-- Mostra totes les transaccions realitzades per empreses d'Alemanya.
            
            select id
            from transaction
            where company_id in
				(select id  -- subquery con las empresas alemanes
				from company
				where country in ('Germany')
                );
                
			-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
            select company_name
            from company
            where id in (
				select company_id -- subquery con las companias con trasaciones por encima del promedio 
                from transaction
                where amount >(
					select avg(amount) -- subquery con el promedio de todas las transaciones 
					from transaction
                    )
				);
                
			-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
            
        select company_name
        from company 
        where id not in (
			select company_id 
            from transaction
            ); 
        -- Todas las empresas tienen transaciones registradas
        
-- Nivell 2
	-- Exercici 1
		-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

		select cast(timestamp as date) as date_most_sales , sum(amount) as total_sales_day -- cast: cambia el valor para fecha sin la hora
		from transaction
        where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
		group by date_most_sales
		order by total_sales_day desc
		limit 5;


	-- Exercici 2
		-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
		
        select company.country, avg(transaction.amount) as average_sales
        from company join transaction
        on company.id = transaction.company_id
		where transaction.declined = 0 --  vendas realizadas cuyas transacciones fueron aceptadas.
        group by country
        order by average_sales desc;

	-- Exercici 3
		-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
			-- Mostra el llistat aplicant JOIN i subconsultes.
            
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
				
            
			-- Mostra el llistat aplicant solament subconsultes.
            
        
          
-- Nivell 3
	-- Exercici 1
		-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.


	-- Exercici 2
		-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
            


        