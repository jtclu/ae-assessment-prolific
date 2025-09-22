
  
    
    
    create  table main_intermediate."int_transactions_fraud"
    as
        -- transactions representing fraud

with staging as (

    select * from main_staging."stg_transactions"
),

type_filter as (

    select *
    from staging
    where 
        transaction_type = 'fraud'
),

fx_conversion as (

    select
        type_filter.*,
        rate.exchange_rate_to_gbp,
        round(type_filter.transaction_amount * rate.exchange_rate_to_gbp, 2) as transaction_amount_gbp

    from type_filter
    left join main_intermediate."int_currency_rates" as rate
        on type_filter.currency = rate.currency
        and type_filter.transaction_date >= rate.valid_from
        and type_filter.transaction_date < rate.valid_to
),

final as (
    
    select
        transaction_id as fraud_transaction_id,
        client_id,
        transaction_date as fraud_transaction_date,
        currency as fraud_transaction_currency,
        transaction_amount as fraud_transaction_amount,
        transaction_amount_gbp as fraud_transaction_amount_gbp

    from fx_conversion
)

select * from final

  