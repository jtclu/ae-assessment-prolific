with source as (

    select * 
    from main."currency_rates"
),

src_currency_dates as (

    select
        currency,
        exchange_rate_to_gbp,
        date(rate_date) as rate_date

    from source
)

select * from src_currency_dates