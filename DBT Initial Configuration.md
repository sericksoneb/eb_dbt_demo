# Creating a New DBT Project
1. Install DBT. You can do this in your pwd, but it is recommended to create a virtual environment first. 
```
pip install dbt

dbt init dbt_demo            #Change "dbt-demo" to be the name of your new project
                             #This will scaffold (auto create) a DBT project for you to use

cd dbt_demo                  #Change directory to the new project you just created
```
2. Create new profile (DB connection)
In your root folder (i.e. /Users/ab1234/) there should be a folder called ".dbt"; in this folder, open the "profiles.yml" file and paste the following profile connection: 
```
snowflake-dbt-demo:
  outputs:
    dev:
      type: snowflake
      account: xna97994.us-east-1

      # User/password auth
      user: EBAdmin
      password: ########          #Replace the #s with the actual password

      role: SYSADMIN
      database: DBT_DEMO_DW
      warehouse: DEMO_DW
      schema: DW_DEV
      threads: 4
      client_session_keep_alive: False

    prod:
      type: snowflake
      account: xna97994.us-east-1

      # User/password auth
      user: EBAdmin
      password: ########          #Replace the #s with the actual password           

      role: SYSADMIN
      database: DBT_DEMO_DW
      warehouse: DEMO_DW
      schema: DW
      threads: 4
      client_session_keep_alive: False
  target: dev                     #Set default target to dev
```
This creates two environments: dev and prod. The default target is dev, so every time you run `dbt run` to execute your sql scripts, it will target the dev environment. This is great for testing! To run the prod environment, you simply specify the target in your command: `dbt run -t prod`.
3. Update project settings
Open the file "dbt_project.yml" in a text editor and replace the text with the following: 
```
# project
name: eb_dbt_demo
version: '1.0.0'

# config version
config-version: 2

# profile
profile: 'snowflake-dbt-demo'   # Note how this profile will refer to the profile connection created in the previous step

# file path configs
source-paths: ["models"]
analysis-paths: ["analysis"]
test-paths: ["tests"]
data-paths: ["data"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

# model configs
models:
  
  +snowflake_warehouse: "DEMO_WH"
  
  eb_dbt_demo:
    enabled: true
    materialized: table
    staging:
      +enabled: true
      +materialized: table
      +schema: staging 

# snowflake database configs 
quoting:
  database: false
  identifier: false
  schema: false

```
4. Connect to GitHub and publish repository
```
git init                                                                #intialize empty repository
git add .                                                               #add all files
git commit -m "New DBT Project"                                         #commit changes
git remote add origin https://github.com/sericksoneb/eb_dbt_demo.git       #add repository to newly created git repository
git push -u origin master                                               #push changes to master
```
