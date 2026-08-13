{{ config(
    materialized='incremental',
    unique_key=['test_name', 'invocation_id']
) }}

with demo_tests as (
    select 'ledger_revenue_kpi' as test_name union all
    select 'ledger_price_per_item_kpi' union all
    select 'ledger_return_rate_kpi' union all
    select 'ledger_first_time_buyers'
)

select
    test_name,
    uniform(0, 1, random()) as passed,
    current_timestamp() as evaluated_at,
    '{{ invocation_id }}' as invocation_id
from demo_tests
