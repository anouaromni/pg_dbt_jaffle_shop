with

products as (

    select * from {{ ref('stg_products') }}

)

select
    product_id,
    product_name_changed,
    product_description,
    price,
    created_at
from products
