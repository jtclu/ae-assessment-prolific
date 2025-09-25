with source as (
    select * from {{ ref('transaction_resolutions') }}
),

src_transaction_resolutions as (
    select
        transaction_id,
        resolution_status,
        resolution_date

    from source
)

select * from src_transaction_resolutions

