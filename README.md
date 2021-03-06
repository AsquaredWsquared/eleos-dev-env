# eleos-dev-env

Welcome to the Scottish Tech Army Odoo Development Environment Installation Guide using Docker.

Odoo is an open source Enterprise Resource Planning (ERP) system written in Python which relies on a PostgreSQL backend to store data.

The source code for Odoo can be found [here](https://github.com/odoo/odoo) but by the end of the guide you should have a local copy in a Docker Container that you can rummage around in.


**The installation steps that follow are intended for developers who are new to Odoo, Docker and Python and want a local development environment to play around with Odoo and PostgreSQL.**


*If you are already an Odoo/Docker/Python/Git ninja then this guide isn't aimed at you and I've got a couple of questions ;-)*

The process is going to be broken down into three main steps:

1. Create a local PostgreSQL Docker Container from a Docker Image and connect to it using the Docker Desktop CLI.
2. Create a separate local Odoo Docker Container from a Docker Image that has the Odoo source code in it.
3. Connect to the container we created in step 2 using Visual Studio Code and create our first custom Odoo module/add on.

### Prerequisites

Odoo is written in Python and is intended to run on Ubuntu Linux. However you should be able to run Odoo locally on Windows, OS X or Linux using Docker. 

To follow along you'll need:

1. git or a client like GitHub Desktop or GitKraken for source control.
2. A [Docker Hub account](https://hub.docker.com/signup), and you have installed [Docker Desktop](https://www.docker.com/products/docker-desktop).
3. [Visual Studio Code](https://code.visualstudio.com/download) which is free and lets you connect and develop as if you are inside a Docker Container.

## Step 1: PostgreSQL Container Creation

Open Visual Studio Code and click on **Clone Git Repository...**

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step1.JPG">

**Copy** and **Paste** the command below into the drop down list and press **Enter**:

> git clone https://github.com/AsquaredWsquared/eleos-dev-env.git

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step2.JPG">

Create a folder of your choice to store the repository in.

Then click on **Open** in the pop up at the bottom right of the window.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step3.JPG">

Then make your choice whether you trust me or not.

Now you have a local copy of the repository, we need to open a terminal. Click on **Terminal**, **New Terminal**. Then **Copy** and **Paste** the command below to create our PostgreSQL Docker Image:

> docker run -it --rm --name=sta-postgres-dev -e POSTGRES_PASSWORD=mysecretpassword -v postgres13-data:/var/lib/postgresql/data -p 5432:5432 postgres:13

This docker command will take a few minutes to go off and install a Docker Image (postgres:13) from the Docker Hub and then start up a Docker Container (sta-postgres-dev) which has PostgreSQL 13 running in it.

The command creates a super secure password for your local dev PostgreSQL database:

> mysecretpassword 

...so probably not a good idea to use this in production.

The -v postgres13-data:/var/lib/postgresql/data part creates a Docker Volume. What this means in reality is that when we shut our container down the data for our db isn't lost but stored in a Docker Volume.

You can check the command has worked by opening up Docker Desktop and you should have a Postgres Image:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker1.JPG">

and in Containers/Apps there should be a running instance of PostgreSQL called sta-postgres-dev postgres:13 PORT: 5432. There is a **CLI** button (I just can't make it show up in my snippet!) which you can use to connect to your instance and execute commands:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker2.JPG">

Click on the Docker **CLI** button and **Copy** and **Paste** the command below into the Docker CLI:

> psql -h localhost -p 5432 -U postgres -W

Or if you like the command line:

> docker exec -it sta-postgres-dev bash
> psql -h localhost -p 5432 -U postgres -W

You will then be prompted to enter your password: mysecretpassword and given a postgres prompt where you can execute commands.

> postgres=#

For example, if you type \l you will be given a list of databases or \du will list users.

We will need to create a role for Odoo to connect and create a database in PostgreSQL. Execute the following command from the postgres prompt:

> postgres=# CREATE ROLE odoo CREATEDB LOGIN PASSWORD 'odoo';

We next need to create a database for Odoo to connect to:

> postgres=# CREATE DATABASE odoo15 OWNER odoo ENCODING UTF8;

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker4.JPG">

## Step 2: Odoo Container Creation

We now need to create an Odoo Image and then an Odoo Container to connect to our PostgreSQL Container using the odoo role we created in Step 1.

Using Visual Studio Code we can build a local Docker Image with the following command pasted in the terminal:

> docker build . -t odoo15

This will take a while to build the image the first time (probably best to go and make a cup of coffee while you wait) The docker command uses the Dockerfile from the repository to build the image. 

Once the build is complete if you look in Docker Desktop you should see the image (Odoo15):

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker3.JPG">

We need to tell Docker that we want to create a container based on our image and initialise our Odoo15 database. To do this use the following command in the terminal:

> docker run --rm -it -v sta-odoo-data:/opt/odoo/data -p 8069:8069 --env-file=odoo.env odoo15 odoo -d odoo15 -i base --without-demo=all --load-language=en_GB

You should eventually see a ???Registry Loaded in xx.xxxs??? message after the modules have been loaded into the db. Now you should be able to access your new Odoo system at http://localhost:8069 and log in using the default

> user: admin, password: admin 

When you are finished you can press CTRL+C in your terminal window to stop it.


## Step 3: Connect to our "sta-odoo-dev" Container with Visual Studio Code using the "Remote - Containers" extension

You can now start up an Odoo development environment using the following command (the command mainly maps the container directories to Docker volumes so we don't lose our data when the container shuts down).

> docker run --rm -it --name=sta-odoo-dev -v sta-odoo-data:/opt/odoo/data -v sta-odoo-vscode:/opt/odoo/.vscode -v sta-odoo-custom-addons:/opt/odoo/custom_addons -v sta-odoo-home:/home/odoo -p 8069:8069 --env-file=odoo.env odoo15 bash

We can now try and hook into our shiny new dev container (sta-odoo-dev) with Visual Studio Code and break/make stuff.

To use Visual Studio Code Remote Development with Docker containers you need to install the ???Remote - Containers??? extension.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture1.JPG">

Once you have installed the extension, click the **Remote Explorer** toolbar button on the left hand side of your screen. If the containers are still running you should see them listed like below:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture2.JPG">

To attach to the container for development, click the folder with a plus sign (attach to container) to the right of its name, and a new Visual Studio Code window will be launched. 

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture3.JPG">

At this point Visual Studio Code will automatically install its server utilities in the /home/odoo/.vscode-server folder and then display the ???Welcome??? screen.

Click on Open Folder then change /home/odoo to **/opt/odoo** and click **OK**. 

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture4.JPG">

This should then display the code root folder and we now have access to the source code for Odoo and we can write our own custom add_ons/modules.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture5.JPG">

We need to first install the Python Extension inside our container. To do this, press the **Extensions** toolbar button, search for **Python**, then hit the **Install in Container** button.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/PythonExtension.JPG">

Clicking on a Python file should automatically select an interpreter for you, for example:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/PythonInterp1.JPG">

Now we need to create a Launch Configuration to tell Visual Studio Code how to start Odoo.
To do this, click the **Run** menu, click the **Add Configuration** link, then **Python File**. This will create a new **launch.json** file in the .vscode folder of your workspace.

Replace the contents of **launch.json** with this:
```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information visit:
    // https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Odoo",
            "type": "python",
            "request": "launch",
            "cwd": "${workspaceRoot}",
            "program": "${workspaceRoot}/odoo/odoo-bin",
            "args": [
                "--db_host=${env:DB_HOST}",
                "--db_port=${env:DB_PORT}",
                "--db_user=${env:DB_USER}",
                "--db_password=${env:DB_PASSWORD}",
                "--database=odoo15",
                "--limit-time-real=100000"
            ],
            "console": "integratedTerminal"
        }
    ]
}
```

Click on the **Run and Debug** button in the left hand toolbar and you should see the Odoo option in the Run area of Visual Studio Code. Click the Green triangle and it should launch Odoo!

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/PythonLaunch.JPG">

Now you should be able to access your shiny new dev Odoo system at http://localhost:8069 and log in using the default login credentials.

> user: admin, password: admin

However what we really want is to be able to write our own STA modules! Click on the Red square to stop Odoo running and we can write a skeleton module.

Open up the custom_addons folder and create a new sta_module folder inside it.
Inside that folder, create two empty files: \_\_manifest\_\_.py and \_\_init\_\_.py (make sure that you have put double underscores)

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Module1.JPG">

Open up \_\_manifest\_\_.py and add the below:

```
{
    'name': 'STA Module',
    'version': '1.0.0',
    'summary': 'Test Module',
    'author': 'Me',
    'website': 'https://www.scottishtecharmy.org/',
    'depends': [
        'base',
    ],
    'data': [
    ],
    'installable': True,
    'application': True,
    'auto_install': False,
}
```

Click on the **Run and Debug** button in the left hand toolbar and you should see the Odoo option in the Run area of Visual Studio Code. Click the Green triangle and it should launch Odoo with our new sta_module in it. Go to http://localhost:8069 and login in with admin/admin

To make our new module visible we need to enter debug/developer mode. Paste the following in your browser:

>http://localhost:8069/web?debug=1#cids=1&menu_id=5&action=37&model=ir.module.module&view_type=kanban

Then click on **Update Apps List**, **Update** Once the update is complete enter "STA Module" in the Search field and our mighty **STA Module** will appear.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/MightyModule.JPG">

To find out more about Odoo Development go to https://www.odoo.com/documentation/15.0/developer.html

## Acknowledgement

This readme and Dockerfile came from a series of three [articles](https://medium.com/@dupski/odoo-development-running-postgresql-in-docker-702406520c03) by Russell Briggs. He has very kindly made the source Dockerfile and assorted scripts available on GitHub [here](https://github.com/junariltd/junari-odoo-docker) I've just added a few pictures!!
