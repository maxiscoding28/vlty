# 👨‍🍳 Vlty (Cookbook Branch) 👨‍🍳

**NOTE**: This branch of Vlty includes a directory called `recipes/` which includes some useful commands for enabling various components of Vault. 

## What Is This?
Vlty (pronounced vaulty) is a tool I made for quickly reproducing issues related to Hashicorp Vault on my local machine.

It uses Hashicorp's official docker image for vault enterprise (or optionally vault open source) to spin up vault clusters of 1-3 nodes.

Vlty is designed to be ephemeral and highly configurable. Nodes and clusters can be quickly deleted and re-created. 

## What Do I Need To Do To Set This Up?
- [Docker](https://www.docker.com/) installed
- A valid [vault enterprise license](https://www.hashicorp.com/products/vault/pricing)
    - Optionally, you can also run [vault open source](https://hub.docker.com/r/hashicorp/vault).

## What Can I Do With It?
- **3 three-node vault clusters ([v/](./v), [dr/](./dr), and [pr/](./pr))**
    - These are the main clusters I use for reproducing vault issues and especially vault issues related to replication and/or high availability.

    - More info on working with these clusters is documented in the sections below.

- **A Vault Agent.**
    - More info on working with the vault agent can be found in the [agent/ readme (in progress)](./agent/)

- **Multiple single-node `autounseal` clusters.**
    - More info on working with these clusters can be found in the [autounseal/ readme (in progress)](./autounseal) .
    
## How Do I Make This Work?
`./start-cluster.sh` or `./stop-cluster.sh` to start or stop the 3 node cluster. 

With no first argument provided, this will start the `v` cluster only. 

You can pass specify a cluster as the first argument for the shell script `./start-cluster.sh dr` or `./stop-cluster v`.

You can pass a specfic version of vault using the variable `VERSION`: `VERSION=1.12.1-ent ./start-cluster`
- The version name uses the docker image versioning syntax

You can use the OSS version of Vault byt passing the variable `OSS=vault`: `OSS=vault ./start-cluster.sh`

You can prevent the script from initializing Vault by passing a second argument of `ni`: `./start-cluster.sh v ni`