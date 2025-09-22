
  
    
    
    create  table main_intermediate."int_clients"
    as
        -- all clients in dataset, plus contract detail lookup where applicable
-- assume clients transact both in & out of contract and may enter multiple contracts throughout lifetime
-- for ease of use this will be a cartesian join with rows for each client/reporting month combination, with contract months & attributes flagged
-- advantage: simple to add new column flagging useful aggregates downstream e.g. transaction count or cumulative value per client month
-- disadvantage: grain currently fine for sample data but may run into performance issue if dataset becomes large

-- first construct a spine contraining all known clients on a monthly view

with all_clients as (

    select distinct 
        client_id
    from main_staging."stg_transactions"

    union

    select
        client_id
    from main_staging."stg_client_contracts"
),

client_timeline as (

    select
        report_month, 
        client_id

    from all_clients
    cross join 
        main_intermediate."int_calendar_months" 
),

contract_details as (

    select  
        client_id,
        contract_start_date,
        date(
            contract_start_date,
            '+' || contract_duration_months || ' months'
        ) as contract_end_date,
        spend_threshold, -- assume GBP equivalent and is cumulative maximum spend that the discount is applicable to during the contract
        discounted_fee_margin

    from main_staging."stg_client_contracts" 
),

-- contract status during month
client_monthly_attribute as (

    select  
        client_timeline.client_id,
        client_timeline.report_month,
        case
            when contract_details.contract_start_date is not null then true
            else false
        end as is_in_contract,
        contract_details.spend_threshold, -- assume GBP equivalent and is cumulative maximum spend that the discount is applicable to
        contract_details.discounted_fee_margin

    from client_timeline
    left join contract_details
        on client_timeline.client_id = contract_details.client_id
        and client_timeline.report_month >= contract_details.contract_start_date
        and client_timeline.report_month < contract_details.contract_end_date
),

final as (

    select
        client_id,
        report_month,
        is_in_contract,
        spend_threshold, -- only populated if is_in_contract = true
        discounted_fee_margin -- only populated if is_in_contract = true

    from client_monthly_attribute
)

select * from final

  