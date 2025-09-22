-- monthly aggregate view per client
-- assumes gmv and revenue are recognised before deducting refunds in expense lines -- ignores linked transactions & frauds

-- start with transaction value x correct fee (adjusting for discounts & thresholds)

with fees_collectable as (

    select 
        *,
        transaction_amount_gbp * platform_fee_margin as fees_applicable_gbp

    from main_marts."fact_transactions"
),

revenue_client_monthly as ( 

    select 
        strftime('%Y-%m-01', transaction_date) as revenue_month,
        client_id,
        sum(fees_applicable_gbp) as total_revenue_in_month

    from fees_collectable
    group by
        1, 2    
),

-- date spine for reporting view
datespine_view as ( 

    select 
        datespine.report_month,
        revenue_client_monthly.client_id,
        revenue_client_monthly.total_revenue_in_month

    from main_intermediate."int_calendar_months" as datespine
    left join revenue_client_monthly    
        on datespine.report_month = revenue_client_monthly.revenue_month
),

final as (
    
    select 
        report_month,
        client_id,
        round(total_revenue_in_month, 2) as total_revenue_in_month
    from datespine_view
)

select * from final