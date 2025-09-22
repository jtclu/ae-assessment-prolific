
  
    
    
    create  table main_intermediate."int_transactions_chargebacks"
    as
        -- transactions representing chargebacks only

with staging as (

    select * from main_staging."stg_transactions"
),

type_filter as (

    select *
    from staging
    where 
        transaction_type = 'chargeback'
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

chargeback_status as (

    select
        fx_conversion.*,
        resolution.resolution_status, 
        resolution.resolution_date

    from fx_conversion
    left join main_staging."stg_transaction_resolutions" as resolution
        on fx_conversion.transaction_id = resolution.transaction_id
),

final as (
    
    select
        transaction_id as chargeback_transaction_id,
        client_id,
        transaction_date as chargeback_transaction_date,
        currency as chargeback_transaction_currency,
        transaction_amount as chargeback_transaction_amount,
        transaction_amount_gbp as chargeback_transaction_amount_gbp,
        platform_fee_margin,
        resolution_status as chargeback_status, -- pending or resolved
        resolution_date as chargeback_applicable_date

    from chargeback_status
)

select * from final

  