SELECT "omni_dbt__products"."PRODUCT_ID",
    COALESCE(SUM("omni_dbt__order_items"."PRODUCT_PRICE"), 0) AS "GROSS_REVENUE",
    COALESCE(SUM("omni_dbt__order_items"."PRODUCT_PRICE"), 0) - COALESCE(SUM("omni_dbt__order_items"."SUPPLY_COST"), 0) AS "GROSS_PROFIT",
    COALESCE(SUM("omni_dbt__order_items"."SUPPLY_COST"), 0) AS "SUPPLY_COST_TOTAL"
FROM {{ref('order_items')}} AS "omni_dbt__order_items"
    LEFT JOIN {{ref('products')}} AS "omni_dbt__products" ON "omni_dbt__order_items"."PRODUCT_ID" = "omni_dbt__products"."PRODUCT_ID"
GROUP BY 1
