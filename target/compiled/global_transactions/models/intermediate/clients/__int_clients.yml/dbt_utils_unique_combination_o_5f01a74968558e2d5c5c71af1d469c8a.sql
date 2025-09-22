





with validation_errors as (

    select
        client_id, report_month
    from main_intermediate."int_clients"
    group by client_id, report_month
    having count(*) > 1

)

select *
from validation_errors


