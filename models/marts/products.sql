with

products as (

    select * from {{ ref('stg_products') }}

)

select
    product_id,
    product_name as product_name_changed,
    product_type,
    product_description,
    product_price,
    is_food_item,
    is_drink_item
from products
