-- =============================================================================
-- 1. TABLAS BASE E INDEPENDIENTES
-- =============================================================================

-- TABLA: CUSTOMERS
CREATE TABLE ecommify_olist_analytics.customers (
  customer_id uuid NOT NULL,
  customer_unique_id text NOT NULL,
  customer_zip_code_prefix integer NULL,
  customer_city text NULL,
  customer_state text NULL,
  
  -- [AVANZADO] JSONB: Para metadatos dinámicos del cliente
  metadata jsonb NULL, 
  
  CONSTRAINT customers_pkey PRIMARY KEY (customer_id),
  CONSTRAINT customers_unique_id_unique UNIQUE (customer_unique_id)
);

-- TABLA: SELLERS
CREATE TABLE ecommify_olist_analytics.sellers (
  seller_id uuid NOT NULL,
  seller_zip_code_prefix integer NULL, -- Optimización a integer para códigos postales
  seller_city text NULL,
  seller_state text NULL,
  
  -- [AVANZADO] ARRAY: Categorías manejadas por el vendedor
  categories text[] NULL, 
  
  CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);


-- =============================================================================
-- 2. TABLAS CON RELACIONES (LLAVES FORÁNEAS Y RESTRICCIONES)
-- =============================================================================

-- TABLA: ORDERS
CREATE TABLE ecommify_olist_analytics.orders (
  order_id uuid NOT NULL,
  customer_id uuid NOT NULL,
  order_status text NOT NULL,
  order_purchase_timestamp timestamp without time zone NOT NULL,
  order_approved_at timestamp without time zone NULL,
  order_delivered_carrier_date timestamp without time zone NULL,
  order_delivered_customer_date timestamp without time zone NULL,
  order_estimated_delivery_date timestamp without time zone NULL,
  
  CONSTRAINT orders_pkey PRIMARY KEY (order_id),
  
  -- Llave Foránea hacia Customers
  CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) 
    REFERENCES ecommify_olist_analytics.customers (customer_id) ON DELETE RESTRICT,
    
  -- Validación de estados válidos
  CONSTRAINT chk_order_status CHECK (order_status IN ('created', 'approved', 'processing', 'shipped', 'delivered', 'canceled', 'unavailable')),
  
  -- Validación lógica de fechas
  CONSTRAINT chk_delivery_date_logic CHECK (order_delivered_customer_date >= order_purchase_timestamp)
);

-- TABLA: ORDER_ITEMS (Estándar, no particionada)
CREATE TABLE ecommify_olist_analytics.order_items (
  order_id uuid NOT NULL,
  order_item_id integer NOT NULL,
  product_id uuid NOT NULL,
  seller_id uuid NOT NULL,
  shipping_limit_date timestamp without time zone NULL,
  price numeric(10,2) NOT NULL, -- Precisión decimal añadida
  freight_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_items_pkey PRIMARY KEY (order_id, order_item_id),
  
  -- Llaves Foráneas
  CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) 
    REFERENCES ecommify_olist_analytics.orders (order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) 
    REFERENCES ecommify_olist_analytics.sellers (seller_id) ON DELETE RESTRICT,
    
  -- Validaciones de precios positivos
  CONSTRAINT chk_item_price_positive CHECK (price >= 0),
  CONSTRAINT chk_freight_value_positive CHECK (freight_value >= 0)
);

-- TABLA: ORDER_PAYMENTS (Estándar, no particionada)
CREATE TABLE ecommify_olist_analytics.order_payments (
  order_id uuid NOT NULL,
  payment_sequential integer NOT NULL, -- Cambiado a integer
  payment_type text NOT NULL,
  payment_installments integer NOT NULL, -- Cambiado a integer
  payment_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_payments_pkey PRIMARY KEY (order_id, payment_sequential),
  
  -- Llave Foránea
  CONSTRAINT fk_order_payments_orders FOREIGN KEY (order_id) 
    REFERENCES ecommify_olist_analytics.orders (order_id) ON DELETE CASCADE,
    
  -- Validaciones
  CONSTRAINT chk_payment_type CHECK (payment_type IN ('credit_card', 'debit_card', 'voucher', 'boleto', 'not_defined')),
  CONSTRAINT chk_payment_installments CHECK (payment_installments >= 0),
  CONSTRAINT chk_payment_value_positive CHECK (payment_value > 0)
);


-- =============================================================================
-- 3. OPTIMIZACIÓN: ESTRATEGIA DE PARTICIONAMIENTO NATIVO
-- =============================================================================

-- TABLA MAESTRA PARTICIONADA: order_items_partitioned (Por RANGE usando la fecha límite de envío)
-- Nota: En Postgres, la llave primaria de una tabla particionada DEBE incluir la columna de partición.
CREATE TABLE ecommify_olist_analytics.order_items_partitioned (
  order_id uuid NOT NULL,
  order_item_id integer NOT NULL,
  product_id uuid NOT NULL,
  seller_id uuid NOT NULL,
  shipping_limit_date timestamp without time zone NOT NULL,
  price numeric(10,2) NOT NULL,
  freight_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_items_partitioned_pkey PRIMARY KEY (order_id, order_item_id, shipping_limit_date),
  CONSTRAINT fk_partitioned_items_sellers FOREIGN KEY (seller_id) 
    REFERENCES ecommify_olist_analytics.sellers (seller_id) ON DELETE RESTRICT,
  CONSTRAINT chk_part_item_price_positive CHECK (price >= 0),
  CONSTRAINT chk_part_freight_value_positive CHECK (freight_value >= 0)
) PARTITION BY RANGE (shipping_limit_date);

-- Creación formal de las tablas hijas por Rango de Años (FROM inclusive, TO exclusivo)
CREATE TABLE ecommify_olist_analytics.order_items_p2016 PARTITION OF ecommify_olist_analytics.order_items_partitioned
    FOR VALUES FROM ('2016-01-01 00:00:00') TO ('2017-01-01 00:00:00');

CREATE TABLE ecommify_olist_analytics.order_items_p2017 PARTITION OF ecommify_olist_analytics.order_items_partitioned
    FOR VALUES FROM ('2017-01-01 00:00:00') TO ('2018-01-01 00:00:00');

CREATE TABLE ecommify_olist_analytics.order_items_p2018 PARTITION OF ecommify_olist_analytics.order_items_partitioned
    FOR VALUES FROM ('2018-01-01 00:00:00') TO ('2019-01-01 00:00:00');

CREATE TABLE ecommify_olist_analytics.order_items_p2019 PARTITION OF ecommify_olist_analytics.order_items_partitioned
    FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2020-01-01 00:00:00');

CREATE TABLE ecommify_olist_analytics.order_items_p2020 PARTITION OF ecommify_olist_analytics.order_items_partitioned
    FOR VALUES FROM ('2020-01-01 00:00:00') TO ('2021-01-01 00:00:00');


-- -----------------------------------------------------------------------------


-- TABLA MAESTRA PARTICIONADA: order_payments_partitioned_list (Por LIST usando el tipo de pago)
CREATE TABLE ecommify_olist_analytics.order_payments_partitioned_list (
  order_id uuid NOT NULL,
  payment_sequential integer NOT NULL,
  payment_type text NOT NULL,
  payment_installments integer NOT NULL,
  payment_value numeric(10,2) NOT NULL,
  
  CONSTRAINT order_payments_partitioned_pkey PRIMARY KEY (order_id, payment_sequential, payment_type),
  CONSTRAINT chk_part_payment_installments CHECK (payment_installments >= 0),
  CONSTRAINT chk_part_payment_value_positive CHECK (payment_value > 0)
) PARTITION BY LIST (payment_type);

-- Creación formal de las tablas hijas por Lista de Valores
CREATE TABLE ecommify_olist_analytics.order_payments_p_boleto PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list
    FOR VALUES IN ('boleto');

CREATE TABLE ecommify_olist_analytics.order_payments_p_credit_card PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list
    FOR VALUES IN ('credit_card');

CREATE TABLE ecommify_olist_analytics.order_payments_p_debit_card PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list
    FOR VALUES IN ('debit_card');

CREATE TABLE ecommify_olist_analytics.order_payments_p_not_defined PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list
    FOR VALUES IN ('not_defined');

CREATE TABLE ecommify_olist_analytics.order_payments_p_voucher PARTITION OF ecommify_olist_analytics.order_payments_partitioned_list
    FOR VALUES IN ('voucher');
