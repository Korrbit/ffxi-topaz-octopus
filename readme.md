# ffxi-darkstar-octopus

---
This branch is broken but in the works.

Current state:
- single.tf will work
- zones.tf can work with a couple of tweaks to main.tf
- regions.tf is a work in progress

Design:
- single.tf - will create a single dsgame
- zones.tf - will create a dsgame for each zone
- regions.tf - will create a dsgame for reach region

This in intended to allow for deployment flexibility

---
Container and microservices approach for darkstar allows you to quickly setup and deploy a ffxi server.

Terraform orchestrates the environments - Infrastructure As Code. (https://www.terraform.io/) You will need to install the terraform client to run terraform init, terraform plan and terraform apply.

* `terraform init` is required to setup the inital terraform-providers
* `terraform plan` plan the orchestration
* `terraform apply` apply plan (build and deploy environment)
* `terraform apply -auto-approve` apply plan (build and deploy environment) without approve prompt.

---

Microservices approach sets up multiple map containers (one for each map)
seperate services (game, connect, search and db); utilizes docker volume to persist db data as well as build data;

all instances are based off of ubuntu:bionic, db is based off mariadb:10.4.5-bionic

---

onbuild:
- db container shallow clones darkstar (master or branch you defined), copies SQL into seed directory; cleans up
- dsbuild container installs dependencies; clones darkstar (master or branch you defined); compiles; copies to local filepath; cleans up
- dsconnect runs from local filepath
- dsgame runs from local filepath
- dssearch runs from local filepath

onstart:
- There are now many environment variables for all containers
- dsbuild will build darkstar and uses `sed` to inject environment configuration parameters. Please see docker-compose.yml (if using docker) or main.tf (if using Terraform)
- dsbuild will update sql tables if needed. The intent with the database saving to local file system is to allow for changes in master to reflect in sql.
- dsconnect will update config file to provide the right ip address for msg server
- db container copies seed data to target; prepends a `use` statement; injects a zone_ip update script
- db container will run seed data if db defined as `$MYSQL_DATABASE` does not exist

---

recommendations:

Most configuraiton options are configurable via .tf files.

If using terraform;
- copy `vars.tf.example` -> `vars.tf`; modify to your needs, if you don't you'll see WARNINGS (but server should still work);

instructions:

* install latest docker CE (https://store.docker.com/search?type=edition&offering=community)
* clone repo `git clone https://github.com/Korrbit/ffxi-darkstar-octopus.git`
* cd into repo `cd ffxi-darkstar-octopus`

If using terraform:
* install latest terraform: https://www.terraform.io/downloads.html
* `terraform init` is required to setup the inital terraform-providers
* `terraform plan` plan the orchestration
* `terraform apply` apply plan (build and deploy environment)
* `terraform apply -auto-approve` apply plan (build and deploy environment) without approve prompt.

---

admin:


If using terraform:
* `terraform destroy -auto-approve` will nuke the environment, including database if you decide to forego using an external volume
* connect to `0.0.0.0:23055` to with your (MariaDB) database tool of choice. use the credentials defined in `var.tf`;

* `docker logs <container name>` will show logs for the container you specify.

---

usage:

see darkstar doc/wiki for how to actually use the server: https://wiki.dspt.info/index.php/Main_Page

services are exposed on the (typical) ports:

- `0.0.0.0:54230` (darkstar-dsgame, darkstar-dsconnect)
- `0.0.0.0:54230/udp` (darkstar-dsgame)
- `0.0.0.0:54231` (darkstar-dsconnect)
- `0.0.0.0:54001` (darkstar-dsconnect)
- `0.0.0.0:54002` (darkstar-dssearch)
- `0.0.0.0:23055` (MariaDB)
- `0.0.0.0:5000` (Docker registry) --only if using Terraform

---

additional objectives:
* add in website to manage accounts
* incorporate Jenkins to allow for updates real time as new updates are pushed into github repo
* design 'always on' deployment, including updates
* integration / build testing
* more runtime environment configuration (complete whats left)

possible additions:
* add ELK or similar stack for logging and reporting

---
This project is based off the following works:

Dockerfiles:
* https://github.com/DarkstarProject/darkstar/tree/docker
* https://github.com/notsureifkevin/ffxi-darkstar-docker
* https://github.com/crahda/dockstar

Wait-for-it:
* https://github.com/vishnubob/wait-for-it