-- keeps original grain so can be easily reused for fk dim joins (eg. client) + different reporting timeframe aggregations

with recognised_transactions as ( 

    select 
        *,
        date(transaction_date, 'start of month') as transaction_month

    from main_intermediate."int_transactions_recognised"
), 

-- if discounts should apply, transaction must take place during contract month and not exceed spending threshold

client_contract_status as (

    select
        recognised_transactions.*,
        contracts.is_in_contract,
        contracts.spend_threshold, 
        contracts.discounted_fee_margin 

    from recognised_transactions
    left join main_intermediate."int_clients" as contracts
        on recognised_transactions.client_id = contracts.client_id
        and recognised_transactions.transaction_month = contracts.report_month
),

spend_threshold as (

    select
        *,
        case
            when is_in_contract is true then
                sum(transaction_amount_gbp) over(
                    partition by client_id
                    order by transaction_date asc
                    rows between unbounded preceding and 1 preceding
                ) 
            when is_in_contract is false then null
        end as cumulative_contract_spend

    from client_contract_status
),

discount_applicable as (

    select 
        *,
        case
            when is_in_contract is true 
                and cumulative_contract_spend < spend_threshold 
            then true
            else false
        end as discount_is_applicable

    from spend_threshold
),

final as (

    select
        transaction_id,
        client_id,
        transaction_date,
        transaction_amount_gbp,
        transaction_type, 
        case
            when discount_is_applicable is true 
            then discounted_fee_margin
            else platform_fee_margin
        end as platform_fee_margin
        
    from discount_applicable
)

select *
from final