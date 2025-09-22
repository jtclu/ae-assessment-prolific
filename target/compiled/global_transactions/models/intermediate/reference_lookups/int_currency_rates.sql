-- slowly changing dimension of currency conversion rates to GBP

with staging as (
    select * from main_staging."stg_currency_rates"
),

currency_history as (
    select
        currency,
        exchange_rate_to_gbp,
        rate_date as valid_from,
        lead(rate_date) over (
            partition by currency 
            order by rate_date asc
        ) as valid_to

    from staging
),

final as (
    select
        currency,
        exchange_rate_to_gbp,
        valid_from,
        coalesce(valid_to, date('9999-12-31')) as valid_to

    from currency_history
)

select * from final