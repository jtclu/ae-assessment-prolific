
    select
      count(*) as failures,
      case when count(*) != 0
        then 'true' else 'false' end as should_warn,
      case when count(*) != 0
        then 'true' else 'false' end as should_error
    from (
      
    
  
    
    

with child as (
    select linked_transaction_id as from_field
    from main_intermediate."int_transactions_payments"
    where linked_transaction_id is not null
),

parent as (
    select refund_transaction_id as to_field
    from main_intermediate."int_transactions_refunds"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test