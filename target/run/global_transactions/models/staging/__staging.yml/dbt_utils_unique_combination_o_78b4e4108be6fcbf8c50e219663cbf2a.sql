
    select
      count(*) as failures,
      case when count(*) != 0
        then 'true' else 'false' end as should_warn,
      case when count(*) != 0
        then 'true' else 'false' end as should_error
    from (
      
    
  





with validation_errors as (

    select
        transaction_id, transaction_type
    from main_staging."stg_transactions"
    group by transaction_id, transaction_type
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test