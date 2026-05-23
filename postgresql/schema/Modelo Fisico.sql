create table public.customers (
  customer_id uuid not null,
  customer_unique_id text null,
  customer_zip_code_prefix integer null,
  customer_city text null,
  customer_state text null,
  constraint customers_pkey primary key (customer_id)
) TABLESPACE pg_default;


create table public.orders (
  order_id uuid not null,
  customer_id uuid null,
  order_status text null,
  order_purchase_timestamp timestamp without time zone null,
  order_approved_at timestamp without time zone null,
  order_delivered_carrier_date timestamp without time zone null,
  order_delivered_customer_date timestamp without time zone null,
  order_estimated_delivery_date timestamp without time zone null,
  constraint orders_pkey primary key (order_id)
) TABLESPACE pg_default;

create table public.order_payments (
  order_id uuid not null,
  payment_sequential numeric not null,
  payment_type text null,
  payment_installments numeric null,
  payment_value numeric null,
  constraint order_payments_pkey primary key (order_id, payment_sequential)
) TABLESPACE pg_default;

create table public.order_items (
  order_id uuid not null,
  order_item_id integer not null,
  product_id uuid null,
  seller_id uuid null,
  shipping_limit_date timestamp without time zone null,
  price numeric null,
  freight_value numeric null,
  constraint order_items_pkey primary key (order_id, order_item_id)
) TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS order_items_p0
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE IF NOT EXISTS order_items_p1
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE IF NOT EXISTS order_items_p2
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE IF NOT EXISTS order_items_p3
PARTITION OF order_items
FOR VALUES WITH (MODULUS 4, REMAINDER 3);

create table public.sellers (
  seller_id uuid not null,
  seller_zip_code_prefix numeric null,
  seller_city text null,
  seller_state text null,
  constraint sellers_pkey primary key (seller_id)
) TABLESPACE pg_default;
