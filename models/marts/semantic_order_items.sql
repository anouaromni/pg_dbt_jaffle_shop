{{ config(materialized='semantic_view') }}

TABLES (
    order_items AS {{ ref('order_items') }}
        COMMENT = 'One row per purchased order item with product, customer, revenue, and cost context.'
)

FACTS (
    order_items.line_revenue AS order_items.product_price
        COMMENT = 'Revenue for one order item.',
    order_items.line_cost AS order_items.supply_cost
        COMMENT = 'Supply cost allocated to one order item.',
    order_items.line_profit AS order_items.product_price - order_items.supply_cost
        COMMENT = 'Row-level calculated profit: revenue minus allocated supply cost.'
)

DIMENSIONS (
    order_items.order_date AS order_date
        COMMENT = 'Date the order was placed.',
    order_items.order_month AS DATE_TRUNC('month', order_items.order_date)
        COMMENT = 'Calculated calendar month for monthly analysis.',
    order_items.product_name AS product_name
        COMMENT = 'Purchased product name.',
    order_items.item_type AS CASE
        WHEN order_items.is_food_item THEN 'food'
        WHEN order_items.is_drink_item THEN 'drink'
        ELSE 'other'
    END
        COMMENT = 'Calculated product category from food and drink flags.'
)

METRICS (
    order_items.total_revenue AS SUM(order_items.product_price)
        COMMENT = 'Additive calculation: total order-item revenue.',
    order_items.total_supply_cost AS SUM(order_items.supply_cost)
        COMMENT = 'Additive calculation: total allocated supply cost.',
    order_items.gross_profit AS SUM(order_items.product_price - order_items.supply_cost)
        COMMENT = 'Calculated aggregate: revenue minus supply cost.',
    order_items.order_count AS COUNT(DISTINCT order_items.order_id)
        COMMENT = 'Distinct-count calculation: number of orders.',
    order_items.customer_count AS COUNT(DISTINCT order_items.customer_id)
        COMMENT = 'Distinct-count calculation: number of purchasing customers.',
    order_items.average_item_revenue AS AVG(order_items.product_price)
        COMMENT = 'Average calculation: mean revenue per order item.',
    order_items.food_revenue AS SUM(
        CASE
            WHEN order_items.is_food_item THEN order_items.product_price
            ELSE 0
        END
    )
        COMMENT = 'Conditional calculation: revenue from food items.',
    order_items.gross_margin_pct AS 100 * DIV0(
        SUM(order_items.product_price - order_items.supply_cost),
        SUM(order_items.product_price)
    )
        COMMENT = 'Ratio calculation: gross profit as a percentage of revenue.'
)

COMMENT = 'Example Snowflake semantic view built with the dbt_semantic_view package.'
