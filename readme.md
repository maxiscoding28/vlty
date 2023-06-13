# 🤖 Vlty 🤖

## What Is This?
Vlty (pronounced vaulty) is a tool I made for quickly reproducing issues related to Hashicorp Vault on my local machine.

It uses Hashicorp's official docker image for vault enterprise (or optionally vault open source) to spin up vault clusters of 1-3 nodes.

Vlty is designed to be ephemeral and highly configurable. Nodes and clusters can be quickly deleted and re-created. 

## What Do I Need To Do To Set This Up?
- [Docker](https://www.docker.com/) installed
- A valid [vault enterprise license](https://www.hashicorp.com/products/vault/pricing)
    - Optionally, you can also run [vault open source](https://hub.docker.com/r/hashicorp/vault).
    
## How Do I Make This Work?

## What Can I Do With It?
- **3 three-node vault clusters ([v/](./v), [dr/](./dr), and [pr/](./pr))**
    - These are the main clusters I use for reproducing vault issues and especially vault issues related to replication and/or high availability.

    - More info on working with these clusters is documented in the sections below.

- **A Vault Agent.**
    - More info on working with the vault agent can be found in the [agent/ readme](./agent/)

- **Multiple single-node `autounseal` clusters.**
    - More info on working with these clusters can be found in the [autounseal/ readme](./autounseal) .

## Working with [v/](./v), [dr/](./dr), and [pr/](./pr)