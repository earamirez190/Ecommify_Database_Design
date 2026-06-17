--Índice B-tree

--Script Tabla customers:
CREATE INDEX IF NOT EXISTS idx_customers_unique_id ON ecommify_olist_analytics.customers (customer_unique_id);
CREATE INDEX IF NOT EXISTS idx_customers_zip_code_prefix ON ecommify_olist_analytics.customers (customer_zip_code_prefix);
--Script Tabla orders:
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON ecommify_olist_analytics.orders (customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON ecommify_olist_analytics.orders (order_status);
CREATE INDEX IF NOT EXISTS idx_orders_purchase_timestamp ON ecommify_olist_analytics.orders (order_purchase_timestamp);
--Script Tabla order_items:
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON ecommify_olist_analytics.order_items (order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON ecommify_olist_analytics.order_items (product_id);
CREATE INDEX IF NOT EXISTS idx_order_items_seller_id ON ecommify_olist_analytics.order_items (seller_id);
--Script Tabla order_payments:
CREATE INDEX IF NOT EXISTS idx_order_payments_order_id ON ecommify_olist_analytics.order_payments (order_id);
CREATE INDEX IF NOT EXISTS idx_order_payments_type ON ecommify_olist_analytics.order_payments (payment_type);
--Script Tabla sellers:
CREATE INDEX IF NOT EXISTS idx_sellers_zip_code_prefix ON ecommify_olist_analytics.sellers (seller_zip_code_prefix);


--Índice Hash

--Script Tabla customers:
CREATE INDEX IF NOT EXISTS idx_customers_city_hash ON ecommify_olist_analytics.customers USING HASH (customer_city);
CREATE INDEX IF NOT EXISTS idx_customers_state_hash ON ecommify_olist_analytics.customers USING HASH (customer_state);
--Script Tabla orders:
CREATE INDEX IF NOT EXISTS idx_orders_status_hash ON ecommify_olist_analytics.orders USING HASH (order_status);
--Script Tabla order_payments:
CREATE INDEX IF NOT EXISTS idx_order_payments_type_hash ON ecommify_olist_analytics.order_payments USING HASH (payment_type);
--Script Tabla sellers:
CREATE INDEX IF NOT EXISTS idx_sellers_city_hash ON ecommify_olist_analytics.sellers USING HASH (seller_city);
CREATE INDEX IF NOT EXISTS idx_sellers_state_hash ON ecommify_olist_analytics.sellers USING HASH (seller_state);


--Índice Brin

--Script Tabla orders:
CREATE INDEX IF NOT EXISTS idx_orders_purchase_timestamp_brin ON ecommify_olist_analytics.orders USING BRIN (order_purchase_timestamp);


--Particionamiento aplicado

--Partición RANGE

--Tabla order_items_partitioned
DROP TABLE IF EXISTS ecommify_olist_analytics.order_items_partitioned CASCADE;
CREATE TABLE ecommify_olist_analytics.order_items_partitioned (
    order_id uuid,
    order_item_id integer,
    product_id uuid,
    seller_id uuid,
    shipping_limit_date timestamp without time zone,
    price numeric,
    freight_value numeric
) PARTITION BY RANGE (shipping_limit_date);

--Tablas hijas order_items_partitioned

CREATE TABLE ecommify_olist_analytics.order_items_p2016 PARTITION OF ecommify_olist_analytics.order_items_partitioned FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');
CREATE TABLE ecommify_olist_analytics.order_items_p2017 PARTITION OF ecommify_olist_analytics.order_items_partitioned FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');
CREATE TABLE ecommify_olist_analytics.order_items_p2018 PARTITION OF ecommify_olist_analytics.order_items_partitioned FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');
CREATE TABLE ecommify_olist_analytics.order_items_p2019 PARTITION OF ecommify_olist_analytics.order_items_partitioned FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');
CREATE TABLE ecommify_olist_analytics.order_items_p2020 PARTITION OF ecommify_olist_analytics.order_items_partitioned FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');


--Partición LIST

--Tabla order_payments_partitioned_list

DROP TABLE IF EXISTS ecommify_olist_analytics.order_payments_partitioned_list CASCADE

CREATE TABLE ecommify_olist_analytics.order_payments_partitioned_list (
    order_id uuid,
    payment_sequential numeric,
    payment_type text,
    payment_installments numeric,
    payment_value numeric
) PARTITION BY LIST (payment_type);
	
--Tablas hijas order_payments_partitioned_list
CREATE TABLE ecommify_olist_analytics.order_payments_p_not_defined PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list for values  in ('not_defined') TABLESPACE pg_default;

CREATE TABLE ecommify_olist_analytics.order_payments_p_voucher PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list for values in ('voucher') TABLESPACE pg_default;

CREATE TABLE ecommify_olist_analytics.order_payments_p_credit_card PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list for values in ('credit_card') TABLESPACE pg_default;

CREATE TABLEecommify_olist_analytics.order_payments_p_boleto PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list for values in ('boleto') TABLESPACE pg_default;

CREATE TABLE ecommify_olist_analytics.order_payments_p_debit_card PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list for values in ('debit_card') TABLESPACE pg_default;

