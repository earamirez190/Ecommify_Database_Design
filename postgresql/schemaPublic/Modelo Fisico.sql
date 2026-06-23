-- 1. TABLA: CUSTOMERS
CREATE TABLE public.customers (
  customer_id uuid NOT NULL,
  customer_unique_id text NOT NULL,
  customer_zip_code_prefix integer NULL,
  customer_city text NULL,
  customer_state text NULL,
  metadata jsonb NULL, 
  CONSTRAINT customers_pkey PRIMARY KEY (customer_id),
  CONSTRAINT customers_unique_id_unique UNIQUE (customer_unique_id) 
);


-- 2. TABLA: SELLERS
CREATE TABLE public.sellers (
  seller_id uuid NOT NULL,
  seller_zip_code_prefix integer NULL,
  seller_city text NULL,
  seller_state text NULL,
  categories text[] NULL, 
  CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);


-- 3. TABLA: ORDERS
CREATE TABLE public.orders (
  order_id uuid NOT NULL,
  customer_id uuid NOT NULL,
  order_status text NOT NULL,
  order_purchase_timestamp timestamp without time zone NOT NULL,
  order_approved_at timestamp without time zone NULL,
  order_delivered_carrier_date timestamp without time zone NULL,
  order_delivered_customer_date timestamp without time zone NULL,
  order_estimated_delivery_date timestamp without time zone NULL,
  
  CONSTRAINT orders_pkey PRIMARY KEY (order_id),
  CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) 
    REFERENCES public.customers (customer_id) ON DELETE RESTRICT,
  CONSTRAINT chk_order_status CHECK (order_status IN ('created', 'approved', 'processing', 'shipped', 'delivered', 'canceled', 'unavailable')),
  CONSTRAINT chk_delivery_date_logic CHECK (order_delivered_customer_date >= order_purchase_timestamp)
);


-- 4. TABLA: ORDER_ITEMS
CREATE TABLE public.order_items (
  order_id uuid NOT NULL,
  order_item_id integer NOT NULL,
  product_id uuid NOT NULL,
  seller_id uuid NOT NULL,
  shipping_limit_date timestamp without time zone NULL,
  price numeric(10,2) NOT NULL,
  freight_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_items_pkey PRIMARY KEY (order_id, order_item_id),
  CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) 
    REFERENCES public.orders (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) 
    REFERENCES public.sellers (seller_id) ON DELETE RESTRICT,
  CONSTRAINT chk_item_price_positive CHECK (price >= 0),
  CONSTRAINT chk_freight_value_positive CHECK (freight_value >= 0)
);


-- 5. TABLA: ORDER_PAYMENTS
CREATE TABLE public.order_payments (
  order_id uuid NOT NULL,
  payment_sequential integer NOT NULL,
  payment_type text NOT NULL,
  payment_installments integer NOT NULL,
  payment_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_payments_pkey PRIMARY KEY (order_id, payment_sequential),
  CONSTRAINT fk_order_payments_orders FOREIGN KEY (order_id) 
    REFERENCES public.orders (order_id) ON DELETE CASCADE,
  CONSTRAINT chk_payment_type CHECK (payment_type IN ('credit_card', 'debit_card', 'voucher', 'boleto', 'not_defined')),
  CONSTRAINT chk_payment_installments CHECK (payment_installments >= 0),
  CONSTRAINT chk_payment_value_positive CHECK (payment_value > 0)
);
