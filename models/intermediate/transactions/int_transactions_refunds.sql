
with staging as (

    select * from {{ ref('stg_transactions') }}
),

type_filter as (

    select *
    from staging
    where 
        transaction_type = 'refund'
),

fx_conversion as (
    select
        type_filter.*,
        rate.exchange_rate_to_gbp,
        round(type_filter.transaction_amount * rate.exchange_rate_to_gbp, 2) as transaction_amount_gbp

    from type_filter
    
    left join {{ ref('int_currency_rates') }} as rate
        on type_filter.currency = rate.currency
        and type_filter.transaction_date >= rate.valid_from
        and type_filter.transaction_date < rate.valid_to
),

final as (
    select
        transaction_id as refund_transaction_id,
        client_id,
        transaction_date as refund_transaction_date,
        currency as refund_transaction_currency,
        transaction_amount as refund_transaction_amount,
        transaction_amount_gbp as refund_transaction_amount_gbp,
        platform_fee_margin

    from fx_conversion
)

select * from final