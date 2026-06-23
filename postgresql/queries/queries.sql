--Consulta A: Buscar historial de pedidos, ítems y pagos de un cliente específico

-- [NO] SCHEMA PUBLIC (Escaneo secuencial completo de tablas desvinculadas)
EXPLAIN ANALYZE
SELECT c.customer_unique_id, o.order_id, oi.product_id, op.payment_value
FROM public.customers c
JOIN public.orders o ON c.customer_id = o.customer_id
JOIN public.order_items oi ON o.order_id = oi.order_id
JOIN public.order_payments op ON o.order_id = op.order_id
WHERE c.customer_unique_id = 'un-id-de-cliente-aqui';

-- [SI] SCHEMA ECOMMIFY_OLIST_ANALYTICS (Usa los Índices PK y UNIQUE automáticamente)
EXPLAIN ANALYZE
SELECT c.customer_unique_id, o.order_id, oi.product_id, op.payment_value
FROM ecommify_olist_analytics.customers c
JOIN ecommify_olist_analytics.orders o ON c.customer_id = o.customer_id
JOIN ecommify_olist_analytics.order_items oi ON o.order_id = oi.order_id
JOIN ecommify_olist_analytics.order_payments op ON o.order_id = op.order_id
WHERE c.customer_unique_id = 'un-id-de-cliente-aqui';


--Consulta B: Filtrar ítems de un año específico vendidos por un vendedor concreto

-- [NO] SCHEMA PUBLIC (Busca en toda la tabla histórica año por año)
EXPLAIN ANALYZE
SELECT oi.order_id, oi.price, s.seller_city
FROM public.order_items oi
JOIN public.sellers s ON oi.seller_id = s.seller_id
WHERE oi.shipping_limit_date BETWEEN '2018-01-01 00:00:00' AND '2018-12-31 23:59:59'
  AND s.seller_id = '3504c0cb-71d7-fa48-d967-e0e4c94d59d9'; -- UUID ficticio con formato válido

-- [SI] SCHEMA ECOMMIFY_OLIST_ANALYTICS (Aprovecha la exclusión de partición RANGE p2018 e índices)
EXPLAIN ANALYZE
SELECT oi.order_id, oi.price, s.seller_city
FROM ecommify_olist_analytics.order_items_partitioned oi
JOIN ecommify_olist_analytics.sellers s ON oi.seller_id = s.seller_id
WHERE oi.shipping_limit_date BETWEEN '2018-01-01 00:00:00' AND '2018-12-31 23:59:59'
  AND s.seller_id = '3504c0cb-71d7-fa48-d967-e0e4c94d59d9'; -- Mismo UUID para comparar justamente


--Consulta C: Analizar ingresos totales agrupados por tipo de pago (Boleto vs Tarjeta)

-- [NO] SCHEMA PUBLIC (Filtra fila por fila toda la tabla de pagos masiva)
EXPLAIN ANALYZE
SELECT payment_type, SUM(payment_value) as total_ingresos
FROM public.order_payments
WHERE payment_type = 'boleto'
GROUP BY payment_type;

-- [SI] SCHEMA ECOMMIFY_OLIST_ANALYTICS (Lee DIRECTAMENTE la tabla hija dedicada order_payments_p_boleto)
EXPLAIN ANALYZE
SELECT payment_type, SUM(payment_value) as total_ingresos
FROM ecommify_olist_analytics.order_payments_partitioned_list
WHERE payment_type = 'boleto'
GROUP BY payment_type;
