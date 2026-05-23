'Unir Clientes con Órdenes: Obtener detalles del cliente para sus órdenes'

SELECT
    c.customer_unique_id,
    c.customer_city,
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
LIMIT 5;


'Consulta Compleja: Clientes, Órdenes, Items y Pagos para una visión completa.'

SELECT
    c.customer_unique_id,
    c.customer_city,
    o.order_id,
    o.order_purchase_timestamp,
    oi.product_id,
    oi.price,
    p.payment_type,
    p.payment_value
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    payments p ON o.order_id = p.order_id
LIMIT 5;

'Unir Órdenes con Pagos: Ver los detalles de pago para cada orden.'

SELECT
    o.order_id,
    o.order_status,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM
    orders o
JOIN
    payments p ON o.order_id = p.order_id
LIMIT 5;

