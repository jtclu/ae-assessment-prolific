
  
    
    
    create  table main_intermediate."int_calendar_months"
    as
        -- calendar months from earliest transaction in dataset to current month

with 
    recursive month_series(report_month) as (

        select '2024-01-01'

        union all

        -- recursively add 1 month until the end date is reached

        select date(report_month, '+1 month')
        from month_series
        where 
            report_month <= date('now')
),

final as (
    select 
        report_month 
    from month_series
)

select * from final

  