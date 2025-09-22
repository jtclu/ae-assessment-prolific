
    select
      count(*) as failures,
      case when count(*) != 0
        then 'true' else 'false' end as should_warn,
      case when count(*) != 0
        then 'true' else 'false' end as should_error
    from (
      
    
  





with validation_errors as (

    select
        currency, rate_date
    from main_staging."stg_currency_rates"
    group by currency, rate_date
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test