-- bring together only transaction types that will end up in the topline gmv and revenue calculation

with recognised_transactions as ( 

    select 
        transaction_id,
        client_id,
        transaction_date,
        transaction_amount,
        transaction_amount_gbp,
        platform_fee_margin,
        'payments' as transaction_type

    from main_intermediate."int_transactions_payments"

    union all

    select 
        chargeback_transaction_id as transaction_id,
        client_id,
        chargeback_transaction_date as transaction_date,
        chargeback_transaction_amount as transaction_amount,
        chargeback_transaction_amount_gbp as transaction_amount_gbp,
        platform_fee_margin,
        'resolved chargeback' as transaction_type

    from main_intermediate."int_transactions_chargebacks"
    where
        chargeback_status = 'resolved'
),

final as (

    select 
        transaction_id,
        client_id,
        transaction_date,
        transaction_amount,
        transaction_amount_gbp,
        platform_fee_margin,
        transaction_type

    from recognised_transactions
)

select *
from final