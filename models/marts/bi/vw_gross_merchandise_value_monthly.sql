-- topline gmv aggregated by month & client
-- transaction values in GBP before fees & refunds

with gross_merchandise_value as (

    select *
    from {{ ref('int_transactions_recognised') }}
),

gmv_by_month as (
    
    select 
        strftime('%Y-%m-01', transaction_date) as transaction_month,
        sum(transaction_amount_gbp) as total_gmv_gbp
    
    from gross_merchandise_value
    group by 
        1
), 

-- ensure there are no gaps for time series reporting

datespine_join as (

    select
        spine.report_month,
        coalesce(
            gmv_by_month.total_gmv_gbp,
            0
        ) as total_gmv_gbp

    from {{ ref('int_calendar_months') }} as spine
    left join gmv_by_month
        on spine.report_month = gmv_by_month.transaction_month
),

final as (

    select 
        report_month,
        total_gmv_gbp
    from datespine_join
)

select *
from final

