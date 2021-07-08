# dbt_demo

## Table of Contents
- [PreReqs](#prereqs)
- [Install DBT CLI](#install-dbt-cli)
- [Useful DBT Commands](#useful-dbt-commands)
- [Troubleshooting](#troubleshooting)
- [Get DBT Cloud](#get-dbt-cloud)	

## PreReqs
- [Visual Studio Code](https://code.visualstudio.com/download])
- [Git](https://git-scm.com/downloads)
- [Python3](https://www.python.org/downloads/windows/) 

<!-- ## Getting Started with DBT
1. Sign up for a [DBT Cloud trial](https://www.getdbt.com/signup/) -->

## Install DBT CLI

1. Change to your personal root folder (i.e. C:/Users/<your_user>/)

2. Install DBT using Command Line Interface
	### Git Bash
	```bash
	virtualenv -m venv dbt-env                  #Create a Virtual Environment for DBT called "dbt-env"
	source ~/dbt-env/Scripts/activate           #Activate the virtual environment
	pip install dbt                             #Install DBT
	dbt deps                                    #Install dbt_utils (used in most dbt scripts)
	```	

	**Bash Pro-Tip:** alias these commands in your ~/.bashrc file. For example, you can add a command like "alias env_dbt='source ~/dbt-env/bin/activate'" and then every time you type "env_dbt" it will activate the dbt environment.
		
      ```bash
      # Add alias to ~/.bashrc
cd ~                                		    #change to the root directory
      nano .bashrc                        	    #open the file in a text editor

      #Paste these commands in the text box: 
      alias env_dbt='source ~/dbt-env/bin/activate'
      alias dbt_repo='cd /<path_to_repository>'     #replace <path_to_repository> with the location to the repository you cloned earlier

      #Ctrl+X to exit, press 'Y' to save changes
      source .bashrc                      	    #reload your .bashrc file so the aliases work

      ```
	
	### PowerShell
	```PowerShell
	py -m venv dbt-env                          #Create a Virtual Environment for DBT called "dbt-env"
	.\\dbt-env\Scripts\activate                 #Activate the virtual environment
	pip install dbt                             #Install DBT
	dbt deps                                    #Install dbt_utils (used in most dbt scripts)
	```
	
3. Connect to Snowflake
  - Once dbt is installed, you will need to create a profiles file (first check to see if one was created automatically) that will establish a connection to Snowflake.
    - Open a blank notepad and paste the code below. Search "DBT Demo" in LastPass for the login credentials.
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
        schema: DW_DEV
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

4. Run DBT
  If you made it this far, great job! You should now be able to run dbt commands in your repository. Let's check. 
  -  Change your directory to this git repository (dbt_demo) that you should have cloned/downloaded(`cd /Xerva/Training/dbt_demo/`).
  -  Refer back to step 2 to activate your virtual environment (if you are on the same command line as previous steps, you won't have to activate it again)
  -  Run `dbt test` to make sure dbt runs (if it does, dbt was installed correctly! If it doesn't, refer to the [troubleshooting](#troubleshooting) section below).

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

# Get DBT Cloud
For simplicity, I have created a DBT Cloud environment for each of you to use. Although you will not be creating your own DBT Cloud environment, here are a list of steps to go through in creating a new project. 
1. [Sign up](https://www.getdbt.com/signup/) for DBT Cloud
2. Create new [Github integration](https://cloud.getdbt.com/#/profile/integrations/). This will install DBT Cloud in your github repository and link your project to the repository. 
3. Configure project to use DBT repository and Establish Connection to DB (Account Settings > Projects > Project Name > Add Repository/Connection) 
4. Create [Dev/Prod Environments](https://cloud.getdbt.com/#/accounts/21506/projects/35634/environments/).

