CREATE TABLE ecommify_olist_analytics.customers (
  customer_id uuid NOT NULL,
  customer_unique_id text,
  customer_zip_code_prefix integer,
  customer_city text,
  customer_state text,
  CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);

CREATE TABLE ecommify_olist_analytics.orders (
  order_id uuid NOT NULL,
  customer_id uuid,
  order_status text,
  order_purchase_timestamp timestamp without time zone,
  order_approved_at timestamp without time zone,
  order_delivered_carrier_date timestamp without time zone,
  order_delivered_customer_date timestamp without time zone,
  order_estimated_delivery_date timestamp without time zone,
  CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);

CREATE TABLE ecommify_olist_analytics.order_items (
  order_id uuid NOT NULL,
  order_item_id integer NOT NULL,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric,
  CONSTRAINT order_items_pkey PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE ecommify_olist_analytics.order_payments (
  order_id uuid NOT NULL,
  payment_sequential numeric NOT NULL,
  payment_type text,
  payment_installments numeric,
  payment_value numeric,
  CONSTRAINT order_payments_pkey PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE ecommify_olist_analytics.sellers (
  seller_id uuid NOT NULL,
  seller_zip_code_prefix numeric,
  seller_city text,
  seller_state text,
  CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);


--Tabla particionada order_items partition RANGE 

CREATE TABLE ecommify_olist_analytics.order_items_partitioned (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

--Tablas hijas order_items

CREATE TABLE ecommify_olist_analytics.order_items_p2016 (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_items_p2017 (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_items_p2018 (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_items_p2019 (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_items_p2020 (
  order_id uuid,
  order_item_id integer,
  product_id uuid,
  seller_id uuid,
  shipping_limit_date timestamp without time zone,
  price numeric,
  freight_value numeric
);

--Tabla particionada order_payments partition LIST

CREATE TABLE ecommify_olist_analytics.order_payments_partitioned_list (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);

--Tablas hijas order_payments

CREATE TABLE ecommify_olist_analytics.order_payments_p_boleto (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_payments_p_credit_card (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);

CREATE TABLE ecommify_olist_analytics.order_payments_p_debit_card (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);
CREATE TABLE ecommify_olist_analytics.order_payments_p_not_defined (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);
CREATE TABLE ecommify_olist_analytics.order_payments_p_voucher (
  order_id uuid,
  payment_sequential numeric,
  payment_type text,
  payment_installments numeric,
  payment_value numeric
);