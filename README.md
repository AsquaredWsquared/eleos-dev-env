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

Now you have a local copy of the repository, go into your terminal and run the postgresql12_odoo.sh:
