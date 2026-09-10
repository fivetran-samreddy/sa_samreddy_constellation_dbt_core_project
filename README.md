# sa_samreddy_constellation_dbt_core_project

A standalone dbt project (Databricks) for the Constellation customer.

## What's in here

- `models/staging/sources.yml` — points at `sa_samreddy.Constellation_demo.COFFEE_PRICES_LATEST`
- `models/staging/stg_coffee_prices_rounded.sql` — rounds the `HIGH` column to the
  nearest whole dollar (`.00`) whenever `HIGH >= 75.00`; values below the
  threshold pass through unchanged
- `profiles.yml.example` — template Databricks connection profile

## Setup

1. Install the Databricks adapter:
   ```bash
   pip install dbt-databricks
   ```
2. Copy `profiles.yml.example` to `~/.dbt/profiles.yml` and fill in:
   - `host` — your Databricks workspace hostname
   - `http_path` — your SQL warehouse's HTTP path (Databricks UI: SQL Warehouses → your warehouse → Connection details)
   - `token` — a personal access token (or configure OAuth instead)
3. Confirm the connection: `dbt debug`
4. Run the model: `dbt run --select stg_coffee_prices_rounded`
5. Check the result:
   ```sql
   select * from sa_samreddy.Constellation_demo.stg_coffee_prices_rounded;
   ```

## Notes / things to double check

- The model lists all of `COFFEE_PRICES_LATEST`'s other columns explicitly
  (`ID`, `C_DATE`, `OPEN`, `LOW`, `CLOSE`, `VOLUME`, `CURRENCY`,
  `_fivetran_deleted`, `_fivetran_synced`) rather than using `SELECT * EXCEPT`,
  so it'll run on any Databricks runtime. If the source table gains new
  columns later, add them here too.
- The rounding logic currently uses standard rounding (`round(HIGH, 0)`),
  so e.g. `75.34` → `75.00` and `76.6` → `77.00`. If you actually want
  truncation (always drop to the floor) instead of rounding, swap `round`
  for `floor`.
- The `>= 75.00` threshold is hardcoded in the model; move it to a `var` in
  `dbt_project.yml` if you'll need to tune it per environment.

## Publishing this to GitHub

This folder is not yet a git repo. To set it up:

```bash
cd sa_samreddy_constellation_dbt_core_project
git init
git add -A
git commit -m "Initial Constellation dbt project: round HIGH >= 75.00"
gh repo create sa_samreddy_constellation_dbt_core_project --private --source=. --remote=origin --push
```

(Or create an empty repo on github.com first, then `git remote add origin <url>` and `git push -u origin main`.)
