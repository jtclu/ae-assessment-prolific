
    select
      count(*) as failures,
      case when count(*) != 0
        then 'true' else 'false' end as should_warn,
      case when count(*) != 0
        then 'true' else 'false' end as should_error
    from (
      
    
  
    
    

select
    client_id as unique_field,
    count(*) as n_records

from main_staging."stg_client_contracts"
where client_id is not null
group by client_id
having count(*) > 1



  
  
      
    ) dbt_internal_test