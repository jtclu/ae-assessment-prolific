





with validation_errors as (

    select
        currency, rate_date
    from main_staging."stg_currency_rates"
    group by currency, rate_date
    having count(*) > 1

)

select *
from validation_errors


