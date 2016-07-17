# DevOps
## Toolkit to deploy and manage a Docker Cloud Infrastructure and Docker Registries on AWS with Rancher + Drone for continuous integration and deployment.

###### Georges Jentgen | <georges@polysign.lu>
---

### Introduction
This toolkit is meant as a starting project to launch and manage a cloud infrastructure on AWS running Rancher + Drone for continuous integration and deployment.

Rancher is an orchestration project built on top of Docker to manage a multi-host environment to run your containerized applications. Drone is a continuous integration platform built on Docker.

Additionally, this toolkit provides a simple CLI to create and remove docker repositories using AWS ECR Container Service.

### Prerequisites
To get started with this toolkit, please make sure the following tools have been installed and setup on your local machine:

- Terraform 0.6.16 (or later)
- Node 6.3.0 (or later)
- NPM 3.10.3 (or later)

---

### Configuration

#### SSH Key
Create a new SSH key and save it in /certs.

```
ssh-keygen -f certs/devops
```

#### Variables

1. Copy/move the **terraform.tfvars.example** to **terraform.tfvars** and open it.
```
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```
2. Edit the file and fill in your AWS access key and secret.
3. Paste the public part of your ssh key into the **config.key-pair** variable.
4. Edit the variables to your needs (domain name, namespace, number of instances, instance types, ...)

You can see the defaults by opening the **variables.tf** file from the *infrastructure* folder.

```
cat infrastructure/variables.tf
```

##### Drone
To setup Drone, please refer to this documentation in order to setup your Github/Bitbucket credentials: http://readme.drone.io/setup/overview/#select-and-configure-a-remote-driver:68f80267fa3a50980dbb745a782b8dca

Then edit the **terraform.tfvars** and fill in the *config.drone-driver* and *condif.drone-remote-config* variables accordingly.


### Installation

#### NPM packages
To get started with the toolkit and the available cli, we need to install a few NPM packages:

```
npm install
```

This will install the required NPM packages into *node_modules*.

## CLI

The toolkit provides a simple CLI in order to manage the infrastructure and the container registries/repositories.

### Infrastructure

#### Build
Build the infrastructure on AWS. Also used to update the infrastructure after changes have been done to the configuration files.
```
npm run build
```
#### Plan
Verify the execution of the infrastructure. Especially helpful after changing configuration files to verify what **Terraform** will actually do.
```
npm run plan
```
#### Destroy
Destroy the entire infrastructure.
```
npm run destroy
```

### Registries

#### List
List all existing/setup registries.
```
npm run registry ls
```
#### Create
Create new registry on AWS ECR Container Service.
```
npm run registry create <registry-name>
```
#### Remove
Remove a registry from AWS ECR Container Service.
```
npm run registry rm <registry-name>
```
