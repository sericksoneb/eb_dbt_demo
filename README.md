# Eide Bailly dbt Demo

## Table of Contents
- [PreReqs](#prereqs)
- [Install dbt CLI](#install-dbt-cli)
- [Useful dbt Commands](#useful-dbt-commands)
- [Troubleshooting](#troubleshooting)
- [Get DBT Cloud](#get-dbt-cloud)

Welcome to the Eide Bailly dbt demo! In this tutorial, you will be cloning an existing dbt repository and installing dbt on your local machine. This will allow you to access a dbt repository where you can transform your data with ease. 
DBT is a tool used to orchestrate transformation of SQL scripts (ex. Run this script, then that one, and this one has to run before that one….).  It requires some setup, but ongoing saves a lot of time otherwise spent figuring out dependencies, lineage, & data dictionaries. 

## PreReqs
Before continuing with this tutorial, please make sure to have the following installed on your machine. 
- [Visual Studio Code](https://code.visualstudio.com/download])
- [Git](https://git-scm.com/downloads)
- [Python3](https://www.python.org/downloads/windows/) 

## Clone this Repository
Clone this repository to your local machine. Open the project with Visual Studio Code. 

## Install dbt CLI

1. Change to your personal root folder (i.e. C:/Users/<your_user>/)

2. Install DBT using Command Line Interface
    - We will be installing dbt using the CLI. You can do this using Windows Powershell or Git  Bash. I recommend using Git Bash because you will need to use it in a later step. 
	### Git Bash (login as administrator)
	```bash
	python -m venv dbt-env                      #Create a Virtual Environment for DBT called "dbt-env"
	source ~/dbt-env/Scripts/activate           #Activate the virtual environment
	pip install dbt                             #Install DBT
	```	

	**Bash Pro-Tip:** alias these commands in your ~/.bashrc file. For example, you can add a command like "alias dbt_env='source ~/dbt-env/bin/activate'" and then every time you type "env_dbt" it will activate the dbt environment.
		
      ```bash
      # Add alias to ~/.bashrc
      cd ~                                          #change to the root directory
      nano .bashrc                        	    #open the file in a text editor

      #Paste these commands in the text box: 
      alias dbt_env='source ~/dbt-env/bin/activate'
      alias dbt_repo='cd /<path_to_repository>'     #replace <path_to_repository> with the location to the repository you cloned earlier
      alias dbt_prof='export DBT_PROFILES_DIR=~/dbt-env' #this command will be used later to locate your profiles.yml file

      #Ctrl+X to exit, press 'Y' to save changes
      source .bashrc                      	    #reload your .bashrc file so the aliases work
      ```
	
	### PowerShell
	
	```PowerShell
	py -m venv dbt-env                          #Create a Virtual Environment for DBT called "dbt-env"
	.\\dbt-env\Scripts\activate                 #Activate the virtual environment
	pip install dbt                             #Install DBT
	```
If you get an error running `dbt deps`, check out the [troubleshooting](#troubleshooting) section
	
3. Connect to Snowflake
    - Login to [Snowflake](https://xna97994.us-east-1.snowflakecomputing.com/) using the credentials found in LastPass (listed as "Eide Bailly - SnowflakeAdmin" under Shared-Xerva Developers)
    - Create a schema called <your_name>_dev (e.g. `CREATE SCHEMA DBT_DEMO_DW.SETH_DEV`)
    - Once dbt is installed, you will need to create a profiles file (first check to see if one was created automatically) that will establish a connection to Snowflake.
    - Open a blank notepad and paste the code below. You need to replace the following items: 
    	- **Passwords:** Search "DBT Demo" in LastPass for the login credentials and replace the #'s for the passwords.
    	- **Dev Schema:** Replace <your_schema> with the schema you created in the previous step (e.g. SETH_DEV)
    ```
    eb-dbt-demo:
    target: dev
    outputs:
      dev:
      type: snowflake
        account: xna97994

        # User/password auth
        user: ######## replace with credentials from LastPass
        password: ######## replace with credentials from LastPass

        role: SYSADMIN
        database: DBT_DEMO_DW
        warehouse: DEMO_WH
        schema: <your_schema>
        threads: 4
        client_session_keep_alive: False

      prod:
        type: snowflake
        account: xna97994

        # User/password auth
        user: ###### replace with credentials from LastPass
        password: ###### replace with credentials from LastPass

        role: SYSADMIN
        database: DBT_DEMO_DW
        warehouse: DEMO_WH
        schema: DW
        threads: 4
        client_session_keep_alive: False
    target: dev
    
    ```
    - Save the new file as "profiles.yml" in your dbt-env virtual environment you created in step 2. 

4. Run dbt
  If you made it this far, great job! You should now be able to run dbt commands in your repository. Let's check. 
    -  Open git bash. Reference your profiles.yml file by executing: `export DBT_PROFILES_DIR=~/dbt-env`. This tells dbt where your profiles.yml file is located and references it when establishing a connection to the data source. 
    -  Change your directory to this git repository (dbt_demo) that you should have cloned/downloaded(`cd /Xerva/Training/dbt_demo/` --this is where mine is located).
    -  Refer back to step 2 to activate your virtual environment (if you are using the same command line as previous steps, you won't have to activate it again. Remember you can also use the alias if you created one in step 2).
    -  Run `dbt deps` to install dbt_utils (used in most dbt scripts). You must be in the dbt repository and have your virtual environment activated to run dbt commands. 
    -  Run `dbt test` to make sure dbt runs (if it does, dbt was installed correctly! If it doesn't, refer to the [troubleshooting](#troubleshooting) section below).

5. Participation 
Now that you have successfully installed dbt, let's test it and make sure it runs.
    1. Login to [Snowflake](https://xna97994.us-east-1.snowflakecomputing.com/) using the credentials found in LastPass (listed as "Eide Bailly - SnowflakeAdmin" under Shared-Xerva Developers)
    2. Open a worksheet and execute this SQL command, replacing <name> with your name: `INSERT INTO DBT_DEMO_DW.DATALAKE.PARTICIPATION_USERS values('<name>', GETDATE());`
    3. Go to VSC, open a terminal in your project, and execute `dbt run -m dim_participation` to run the dim_participation model.
    4. Go back to Snowflake and query the table DBT_DEMO_DW.DW_DEV.DIM_PARTICIPATION to see if your name is in the table. If it is, congratulations! You have successfully completed setting up dbt. 

## Useful DBT Commands
`dbt run -m model_name` will run the select query for the specified model 
`dbt run -m +model_name` will run the model and everything upstream that feeds into it 
`dbt run` will run all models and everything upstream/downstream

## Troubleshooting
- DBT has issues installing with Python version 3.9 or higher (the latest versions of Python). If you have Python 3.9 or higher, you need to change the version of python when you create a virtualenv. Run `python --version` to check your current version of Python. If it is version 3.9 or higher, follow these steps: 
  1. Check to see if you have other versions of python already installed. They can be found in C:/Program Files/ and will be named "Python37", "Python38", etc. If you already have a version of python between 3.5 and 3.8, skip to step 3. 
  2. [Download](https://www.python.org/downloads/windows/) and install a version of Python between 3.5 and 3.8 (3.8.10 is recommended). 
  3. Refer back to step 2 above and create a virtual environment with the following command instead: `python3 -m virtualenv -p="C:/Program Files/Python38/python.exe" dbt-env`
      **Note:** If you receive an error when creating the virtualenv, you may need to run your CLI as Administrator  
- If your dbt install does not create a .dbt folder by default, you can change the DBT_PROFILE to look for a folder you specify (in this case, you will want it to be the virtual environment folder you created at `C:/Users/<YourUser>/<YourVenvFolder>`
  * Run this command to change the folder location: `export DBT_PROFILES_DIR=~/dbt-env`
  * Make sure you add the `profiles.yml` file from step 2 to the virtual environment folder you created [above](#install-dbt-cli) (in this case, "dbt-env").
  * **Note:** You may want to do this if you have multiple dbt projects. This way, you can have multiple profiles.yml files and can therefore keep your login credentials separated between clients/projects 
- If you received an error running `dbt deps`, you may need to manually add the packages.yml file to your project. Once you have created a repository and added your dbt project to the repo, you will need to create a file called "packages.yml" and place it in the same location as your dbt_project.yml. Then, add this code and rerun `dbt deps` in your command line. The dbt_utils version below only works for dbt version 19.2, which is the current version at the time this tutorial was made. You may need to adjust it depending on your current dbt version ([check here](https://github.com/dbt-labs/dbt-utils/releases) to find the dbt_utils version that you need.
  ```
  packages:
  - package: fishtown-analytics/dbt_utils
    version: 0.6.4
  ```
  
## Get DBT Cloud
For simplicity, I have created a dbt Cloud environment for each of you to use. This repository is linked to the DBT Cloud environment I created so that you can run dbt commands and make updates to the dbt repository. Although you do not need to create your own dbt Cloud environment, here are a list of steps to go through in creating a new project. 
1. Follow the steps found in [DBT Initial Configuration](https://github.com/sericksoneb/eb_dbt_demo/blob/main/DBT%20Initial%20Configuration.md)
2. [Sign up](https://www.getdbt.com/signup/) for dbt Cloud
3. Create new [Github integration](https://cloud.getdbt.com/#/profile/integrations/). This will install dbt Cloud in your github repository and link your project to the repository. 
4. Configure project to use dbt repository and Establish Connection to DB (Account Settings > Projects > Project Name > Add Repository/Connection) 
5. Add generated deploy key to your github repository
6. Create [Dev/Prod Environments](https://cloud.getdbt.com/#/accounts/21506/projects/35634/environments/).

