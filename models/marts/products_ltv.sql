select
    products.product_id,
    coalesce(sum(order_items.product_price), 0) as gross_revenue,
    coalesce(sum(order_items.product_price), 0) - coalesce(sum(order_items.supply_cost), 0) as gross_profit,
    coalesce(sum(order_items.supply_cost), 0) as supply_cost_total
from {{ ref('order_items') }} as order_items
left join {{ ref('products') }} as products
    on order_items.product_id = products.product_id
group by 1
