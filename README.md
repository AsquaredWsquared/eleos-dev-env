# eleos-dev-env

Welcome to the Scottish Tech Army Odoo Development environment installation guide using Docker.

Odoo is an open source Enterprise Resource Planning (ERP) system written in Python which relies on a PostgreSQL backend to store data.

The source code for Odoo can be found here but by the end of the guide you should have a local copy that you can rummage around in.
https://github.com/odoo/odoo

The installation steps that follow are intended for developers who are new to Odoo, Docker and Python and want a local development environment to play around with Odoo and PostgreSQL. 

If you are already an Odoo/Docker/Python ninja then this guide isn't aimed at you and I've got a couple of questions ;-)

The process is going to be broken down into three main steps:

1. Create a local PostgreSQL Docker container from a Docker image and connect to it.
2. Create a separate local Odoo Docker container from a Docker image that has the Odoo source code in it.
3. Connect to the container we created in step 2 using Visual Studio Code and create our first custom Odoo module/add on.

Prerequisites

Odoo is written in Python and is intended to run on Ubuntu Linux. However you should be able to run Odoo locally on Windows, OS X or Linux using Docker. 

To run Odoo locally, for exploring the code and developing, you'll need:

1. git or a client like GitHub Desktop or GitKraken for source control.
2. A Docker Hub account, and you have installed Docker Desktop.
3. Visual Studio Code which is free and lets you connect and develop as if you are inside a Docker container (if you have a preferred IDE then skip this step and configure it to your liking)

Step 1 PostgreSQL Container Creation

Checkout the code from this GitHub repository. To check the code out locally, you'll need access to git. 

If you're using git on the command-line the command to clone this repository using SSH is:

> git clone git@github.com:AquaredWsquared/eleos-dev-env.git

To clone this repository using HTTPS, use:

> git clone https://github.com/AsquaredWsquared/eleos-dev-env.git

Now you have a local copy of the repository, go into your terminal:

> docker run -it --rm -e POSTGRES_PASSWORD=mysecretpassword -v postgres13-data:/var/lib/postgresql/data -p 5432:5432 postgres:13

This will take a few minutes to go off and install a Docker image from the Docker Hub and then start up a Docker container which has PostgreSQL 13 running in it.

This creates a super secure password for your local dev PostgreSQL database:

> mysecretpassword 

so probably not a good idea to use this in production.

You can check the command has worked by opening up Docker Desktop and you should have a Postgres Image and in Containers/Apps there should be a running instance of PostgreSQL called <random_name> postgres:13 PORT: 5432. There is a CLI button which you can use to connect to your instance and execute commands, for example:

> psql -h localhost -p 5432 -U postgres -W

You will then be prompted to enter your password: mysecretpassword and given a postgres prompt where you can execute commands

> postgres=#

For example, if you type \l you will be given a list of databases or \du will list users.

We will need to create a role for Odoo to connect and create a database in PostgreSQL. Execute the following command from the postgres prompt:

> postgres=# CREATE ROLE odoo CREATEDB LOGIN PASSWORD 'odoo';

Step 2 Odoo Container creation

We now need to create an Odoo Image and then an Odoo Container to connect to our PostgreSQL container using the odoo role we created in Step 1.

Using Visual Studio Code we can build a local Docker image with the following command:

> docker build . -t odoo15

This will then take a while to build the image (probably best to go and make a cup of coffee while you wait) Once the image is built we need to tell Docker that we want to create a container based on our image. To do this use the following command:

> docker run --rm -it --name=sta-odoo-dev -v sta-odoo-data:/opt/odoo/data -v sta-odoo-vscode:/opt/odoo/.vscode -v sta-odoo-custom-addons:/opt/odoo/custom_addons -v sta-odoo-home:/home/odoo -p 8069:8069 --env-file=odoo.env odoo15 bash

In Docker Desktop you should now have two Docker Images: postgresql and odoo15 and two running Docker Containers: sta-odoo-dev and <random_name>