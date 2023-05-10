--función sin parametro de entrada para devolver el precio máximo.
create or replace function precio_maximo()
returns numeric
as $$
declare precio_max numeric;
begin
  select max(unit_price) into precio_max
  from public.products;
  return precio_max;
  
end $$ language 'plpgsql';

select precio_maximo()


--parametro de entrada. Obtener el numero de ordenes por empleado.
create or replace function num_ordenes(empleado int)
returns numeric
as $$
declare ordenes numeric;
begin
  select count(order_id) into ordenes
  from public.orders
  where empleado = employee_id;
  return ordenes;
  
end $$ language 'plpgsql';

select num_ordenes(1);


--Obtener la venta de un empleado con un determinado producto.
create or replace function venta_empleado(empleado int, producto int)
returns int
as $$
declare venta int;
begin
  select sum(d.quantity) into venta
  from public.order_details as d
  inner join public.orders as o
  on d.order_id = o.order_id
  and d.product_id = producto
  and o.employee_id = empleado;
  return venta;
  
end $$ language 'plpgsql';

select venta_empleado(4,1);

---------------------
--DEVUELVE UNA TABLA

--Crear una funcion para devolver una tabla con producto_id, nombre, precio y unidades -->
-->en strock, debe obtener los productos terminados en n
create or replace function tabla_nueva()
returns table (productid smallint, productname character varying, unitprice real, unitsinstock smallint)
as $$
begin 
  return query
  select product_id, product_name, unit_price, units_in_stock
  from public.products
  where product_name like '%n';

end $$ language 'plpgsql';

select * from tabla_nueva()


--Creamos la función contador_ordenes_anio() QUE CUENTE LAS ORDENES POR AÑO devuelve una tabla con año y contador.
create or replace function contador_ordenes_anio()
returns table (anio numeric, contador bigint)
as $$
begin 
  return query
  select extract(year from order_date), count(order_id)
  from public.orders
  group by extract(year from order_date);

end $$ language 'plpgsql';

select * from contador_ordenes_anio()


--Lo mismo que el ejemplo anterior pero con un parametro de entrada que sea el año.
create or replace function contador_ordenes_anio(ano integer)
returns table (anio numeric, contador bigint)
as $$
begin 
  return query
  select extract(year from order_date), count(order_id)
  from public.orders
  where extract(year from order_date) = ano
  group by anio;

end $$ language 'plpgsql';

select * from contador_ordenes_anio(1996)


--PROCEDIMIENTO ALMACENADO PARA OBTENER PRECIO PROMEDIO Y SUMA DE UNIDADES EN STOCK POR CATEGORIA.
create or replace function unidades_stock_categoria(categoria integer)
returns table (precio_promedio numeric, suma_stock bigint)
as $$
begin 
  return query
  select avg(unit_price), sum(units_in_stock)
  from public.products
  where category_id = categoria
  group by category_id;

end $$ language 'plpgsql';

select * from unidades_stock_categoria(1)






