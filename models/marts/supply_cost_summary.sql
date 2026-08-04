select
    'supply_cost_summary' as supply_cost_summary_id,
    cast('2000-01-01' as date) as reporting_date,

    coalesce(sum(supply_cost), 0) as total_supply_cost
from {{ ref('supplies') }}
