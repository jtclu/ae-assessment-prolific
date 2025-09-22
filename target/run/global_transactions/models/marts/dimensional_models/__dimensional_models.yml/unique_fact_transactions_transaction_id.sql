
    select
      count(*) as failures,
      case when count(*) != 0
        then 'true' else 'false' end as should_warn,
      case when count(*) != 0
        then 'true' else 'false' end as should_error
    from (
      
    
  
    
    

select
    transaction_id as unique_field,
    count(*) as n_records

from main_marts."fact_transactions"
where transaction_id is not null
group by transaction_id
having count(*) > 1



  
  
      
    ) dbt_internal_test