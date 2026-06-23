# Modelo entidad-relación (ER) normalizado

```mermaid
erDiagram
    %% Relaciones internas del esquema public (PostgreSQL)
    "public.customers" ||--o{ "public.orders" : customer_id
    "public.orders" ||--o{ "public.order_items" : order_id
    "public.orders" ||--o{ "public.order_payments" : order_id
    "public.sellers" ||--o{ "public.order_items" : seller_id

    %% Entidades del esquema public
    "public.customers" {
        UUID customer_id PK
        VARCHAR customer_unique_id
        INTEGER customer_zip_code_prefix FK "Ref -> mongo.geolocation"
        VARCHAR customer_city
        VARCHAR customer_state
        JSONB metadata "NULL"
    }
    
    "public.orders" {
        UUID order_id PK
        UUID customer_id FK
        VARCHAR order_status
        DATETIME order_purchase_timestamp
        DATETIME order_approved_at
        DATETIME order_delivered_carrier_date
        DATETIME order_delivered_customer_date
        DATETIME order_estimated_delivery_date
        %% Nota: Las reseñas de esta orden viven en mongo.order_reviews
    }
    
    "public.order_items" {
        UUID order_id PK,FK
        INTEGER order_item_id PK
        UUID product_id FK "Ref -> mongo.products"
        UUID seller_id FK
        DATETIME shipping_limit_date
        NUMERIC price
        NUMERIC freight_value
    }
    
    "public.order_payments" {
        UUID order_id PK,FK
        INTEGER payment_sequential PK
        VARCHAR payment_type
        NUMERIC payment_installments
        NUMERIC payment_value
    }
    
    "public.sellers" {
        UUID seller_id PK
        INTEGER seller_zip_code_prefix FK "Ref -> mongo.geolocation"
        VARCHAR seller_city
        VARCHAR seller_state
        TEXT[] categories "NULL"
    }
```
