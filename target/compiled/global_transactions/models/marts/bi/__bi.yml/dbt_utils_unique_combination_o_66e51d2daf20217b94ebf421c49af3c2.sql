





with validation_errors as (

    select
        client_id, report_month
    from main_marts."vw_revenue_by_client_monthly"
    group by client_id, report_month
    having count(*) > 1

)

select *
from validation_errors


