
  
    
    
    create  table main_marts."dim_clients_monthly"
    as
        -- slow change monthly grain snapshot of client's spend to date

with client_monthly_attributes as (

    select *
    from main_intermediate."int_clients"
),

transaction_value_in_month as ( 

    select 
        client_id,
        date(transaction_date, 'start of month') as transaction_month,
        sum(transaction_amount_gbp) as cumulative_transaction_value_in_month

    from main_intermediate."int_transactions_recognised"
),

client_monthly_with_gmv as (

    select
        client_monthly_attributes.client_id,
        client_monthly_attributes.report_month,
        client_monthly_attributes.is_in_contract,
        transaction_value_in_month.cumulative_transaction_value_in_month

    from client_monthly_attributes
    left join transaction_value_in_month
        on client_monthly_attributes.client_id = transaction_value_in_month.client_id
        and client_monthly_attributes.report_month = transaction_value_in_month.transaction_month
),

-- add any other client attributes that can be used to segment client base for targeted campaigns

final as (

    select
        client_id,
        report_month,
        is_in_contract,
        cumulative_transaction_value_in_month

    from client_monthly_with_gmv
)

select *
from final

  