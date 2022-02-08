# eleos-dev-env

Welcome to the Scottish Tech Army Odoo Development environment installation guide using Docker.

Odoo is an open source Enterprise Resource Planning (ERP) system written in Python which relies on a PostgreSQL backend to store data.

The source code for Odoo can be found [here](https://github.com/odoo/odoo) but by the end of the guide you should have a local copy in a Docker Container that you can rummage around in.


**The installation steps that follow are intended for developers who are new to Odoo, Docker and Python and want a local development environment to play around with Odoo and PostgreSQL.**


*If you are already an Odoo/Docker/Python/Git ninja then this guide isn't aimed at you and I've got a couple of questions ;-)*

The process is going to be broken down into three main steps:

1. Create a local PostgreSQL Docker Container from a Docker Image and connect to it using the Docker Desktop CLI.
2. Create a separate local Odoo Docker Container from a Docker Image that has the Odoo source code in it.
3. Connect to the container we created in step 2 using Visual Studio Code and create our first custom Odoo module/add on.

Prerequisites

Odoo is written in Python and is intended to run on Ubuntu Linux. However you should be able to run Odoo locally on Windows, OS X or Linux using Docker. 

To run Odoo locally, for exploring the code and developing, you'll need:

1. git or a client like GitHub Desktop or GitKraken for source control.
2. A [Docker Hub account](https://hub.docker.com/signup), and you have installed [Docker Desktop](https://www.docker.com/products/docker-desktop).
3. [Visual Studio Code](https://code.visualstudio.com/download) which is free and lets you connect and develop as if you are inside a Docker Container.

## Step 1 PostgreSQL Container Creation

Open Visual Studio Code and click on **Clone Git Repository...**

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step1.JPG">

Copy and Paste the command below into the drop down list and press Enter :

> git clone https://github.com/AsquaredWsquared/eleos-dev-env.git

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step2.JPG">

Create a folder of your choice to store the repository in.

Then click on Open in the pop up at the bottom right of the window.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Step3.JPG">

Then make your choice whether you trust me or not.

Now you have a local copy of the repository, we need to open a terminal. Click on Terminal, New Terminal. Then Copy and Paste the command below to create our PostgreSQL Docker Image:

> docker run -it --rm --name=sta-postgres-dev -e POSTGRES_PASSWORD=mysecretpassword -v postgres13-data:/var/lib/postgresql/data -p 5432:5432 postgres:13

This docker command will take a few minutes to go off and install a Docker Image (postgres:13) from the Docker Hub and then start up a Docker Container (sta-postgres-dev) which has PostgreSQL 13 running in it.

The command creates a super secure password for your local dev PostgreSQL database:

> mysecretpassword 

...so probably not a good idea to use this in production.

The -v postgres13-data:/var/lib/postgresql/data part creates a Docker Volume. What this means in reality is that when we shut our container down the data for our db isn't lost but stored in a Docker Volume.

You can check the command has worked by opening up Docker Desktop and you should have a Postgres Image:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker1.JPG">

and in Containers/Apps there should be a running instance of PostgreSQL called sta-postgres-dev postgres:13 PORT: 5432. There is a CLI button (I just can't make it show up in my snippet!) which you can use to connect to your instance and execute commands:

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker2.JPG">

Click on the Docker CLI button and Copy and Paste the command below into the Docker CLI:

> psql -h localhost -p 5432 -U postgres -W

You will then be prompted to enter your password: mysecretpassword and given a postgres prompt where you can execute commands.

> postgres=#

For example, if you type \l you will be given a list of databases or \du will list users.

We will need to create a role for Odoo to connect and create a database in PostgreSQL. Execute the following command from the postgres prompt:

> postgres=# CREATE ROLE odoo CREATEDB LOGIN PASSWORD 'odoo';

We next need to create a database for Odoo to connect to:

> postgres=# CREATE DATABASE odoo15 OWNER odoo ENCODING UTF8;

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker4.JPG">

## Step 2 Odoo Container Creation

We now need to create an Odoo Image and then an Odoo Container to connect to our PostgreSQL Container using the odoo role we created in Step 1.

Using Visual Studio Code we can build a local Docker Image with the following command pasted in the terminal:

> docker build . -t odoo15

This will take a while to build the image the first time (probably best to go and make a cup of coffee while you wait) The docker command uses the Dockerfile from the repository to build the image. 

Once the build is complete if you look in Docker Desktop you should see the image (Odoo15):

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker3.JPG">

We need to tell Docker that we want to create a container based on our image. To do this use the following command in the terminal:

> docker run --rm -it --name=sta-odoo-dev -v sta-odoo-data:/opt/odoo/data -v sta-odoo-vscode:/opt/odoo/.vscode -v sta-odoo-custom-addons:/opt/odoo/custom_addons -v sta-odoo-home:/home/odoo -p 8069:8069 --env-file=odoo.env odoo15 bash

In Docker Desktop you should now have two Docker Images: postgresql and odoo15 and two running Docker Containers: sta-odoo-dev and sta-postgres-dev.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Docker5.JPG">

## Step 3 Connect to our "sta-odoo-dev" Container with Visual Studio Code using the "Remote - Containers" extension

Enough of the scripting shenanigans! We can now try and hook into our shiny new container (sta-odoo-dev) with Visual Studio Code and break/make stuff.

To use Visual Studio Code Remote Development with Docker containers you need to install the “Remote - Containers” extension.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture1.JPG">

Once you have installed the extension, click the “Remote Explorer” toolbar button on the left hand side of your screen. If the containers are still running you should see them listed like below.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture2.JPG">

To attach to the container for development, click the folder with a plus sign (attach to container) to the right of its name, and a new Visual Studio Code window will be launched. 

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture3.JPG">

At this point Visual Studio Code will automatically install its server utilities in the Odoo home folder and then display the “Welcome” screen. 
Click on Open Folder then change /home/odoo to **/opt/odoo** and click OK. 

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture4.JPG">

This should then display the code root folder and we now have access to the source code for Odoo and we can write our own custom add_ons/modules.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/Capture5.JPG">

We need to first install the Python Extension inside our container. To do this, press the Extensions toolbar button, search for Python, then hit the Install in Container button.

<img src="https://github.com/AsquaredWsquared/eleos-dev-env/blob/main/images/PythonExtension.JPG">