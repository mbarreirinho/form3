# Form3 Platform Interview

Platform engineers at Form3 build highly available distributed systems using infrastructure as code. Our take-home test is designed to evaluate real-world activities involved in this role. We recognise that this may not be as mentally challenging, and may take longer to implement, than some algorithmic tests often used in interview exercises. Our approach, however, helps ensure that you will be working with a team of engineers who have the practical skills required for the role (as well as a diverse range of technical wizardry).


## 🧪 Sample application
The sample application consists of four services:

```
┌─────────────┐     ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│             │     │              │    │              │    │              │
│   payment   │     │   account    │    │   gateway    │    │   frontend   │
│             │     │              │    │              │    │              │
└─────────┬───┘     └──────┬───────┘    └──────┬───────┘    └──────────────┘
          │                │                   │
          │                │                   │
          │                ▼                   │
          │         ┌──────────────┐           │
          │         │              │           │
          └────────►│    vault     │◄──────────┘
                    │              │
                    └──────────────┘
```                    

Three of those services connect to [vault](https://www.vaultproject.io/) to retrieve database credentials. The frontend container serves a static file.

The project structure is as follows:

```
.
├── docker-compose.yml
├── form3.crt
├── README.md
├── run.sh
├── Vagrantfile
├── services
│   ├── account
│   ├── gateway
│   └── payment
└── tf
    └── main.tf
```
1. Refactoring the Terraform code found in the [tf](./tf) directory is the primary focus of this test.
1. `Vagrantfile`, `run.sh` and `docker-compose.yml` are used to bootstrap this sample application; refactoring these files is not part of the test, but these files may be modified if your solution requires it.
1. `form3.crt` is used to ease sandboxed running of the submission by Form3 staff and can be ignored.
1. The `services` code is used to simulate a microservices architecture that connects to vault to retrieve database credentials. The code and method of connecting to vault can be ignored for the purposes of this test.

## Using an M1 Mac?
If you are using an M1 Mac then you need to install some additional tools:
- [Multipass](https://github.com/canonical/multipass/releases) install the latest release for your operating system
- [Multipass provider for vagrant](https://github.com/Fred78290/vagrant-multipass)
    - [Install the plugin](https://github.com/Fred78290/vagrant-multipass#plugin-installation)
    - [Create the multipass vagrant box](https://github.com/Fred78290/vagrant-multipass#create-multipass-fake-box)

## 👟 Running the sample application
- Make sure you have installed the [vagrant prerequisites](https://learn.hashicorp.com/tutorials/vagrant/getting-started-index#prerequisites)
- In a terminal execute `vagrant up`
- Once the Vagrant VM has started, you should see a successful `terraform apply`:
```
default: vault_audit.audit_dev: Creation complete after 0s [id=file]
    default: vault_generic_endpoint.account_production: Creation complete after 0s [id=auth/userpass/users/account-production]
    default: vault_generic_secret.gateway_development: Creation complete after 0s [id=secret/development/gateway]
    default: vault_generic_endpoint.gateway_production: Creation complete after 0s [id=auth/userpass/users/gateway-production]
    default: vault_generic_endpoint.payment_production: Creation complete after 0s [id=auth/userpass/users/payment-production]
    default: vault_generic_endpoint.gateway_development: Creation complete after 0s [id=auth/userpass/users/gateway-development]
    default: vault_generic_endpoint.account_development: Creation complete after 0s [id=auth/userpass/users/account-development]
    default: vault_generic_endpoint.payment_development: Creation complete after 1s [id=auth/userpass/users/payment-development]
    default: 
    default: Apply complete! Resources: 30 added, 0 changed, 0 destroyed.
    default: 
    default: ~
```
*Verify the services are running*

- `vagrant ssh`
- `docker ps` should show all containers running:

```
CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                                       NAMES
6662939321b3   nginx:latest                         "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds    0.0.0.0:4080->80/tcp                        frontend_development
b7e1a54799b0   nginx:1.22.0-alpine                  "/docker-entrypoint.…"   5 seconds ago    Up 4 seconds    0.0.0.0:4081->80/tcp                        frontend_production
4a636fcd2380   form3tech-oss/platformtest-payment   "/go/bin/payment"        16 seconds ago   Up 9 seconds                                                payment_development
3f609757e28e   form3tech-oss/platformtest-account   "/go/bin/account"        16 seconds ago   Up 12 seconds                                               account_production
cc7f27197275   form3tech-oss/platformtest-account   "/go/bin/account"        16 seconds ago   Up 10 seconds                                               account_development
caffcaf61970   form3tech-oss/platformtest-payment   "/go/bin/payment"        16 seconds ago   Up 8 seconds                                                payment_production
c4b7132104ff   form3tech-oss/platformtest-gateway   "/go/bin/gateway"        16 seconds ago   Up 13 seconds                                               gateway_development
2766640654f3   form3tech-oss/platformtest-gateway   "/go/bin/gateway"        16 seconds ago   Up 11 seconds                                               gateway_production
96e629f21d56   vault:1.8.3                          "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:8301->8200/tcp, :::8301->8200/tcp   vagrant-vault-production-1
a7c0b089b10c   vault:1.8.3                          "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    0.0.0.0:8201->8200/tcp, :::8201->8200/tcp   vagrant-vault-development-1
```

## ⚙️ Task
Imagine the following scenario: your company is growing quickly 🚀 and the number of services being deployed and configured is increasing.
It has been noticed that the code in `tf/main.tf` is not very easy to maintain 😢.

We would like you to complete the following tasks:

- [ ] Improve the Terraform code to make it easy to add, update, and remove services.
- [ ] Add a new environment called `staging` that runs each microservice.
- [ ] Add a README detailing:
  - [ ] Your design decisions; if you are new to Terraform, let us know.
  - [ ] How your code would fit into a CI/CD pipeline.
  - [ ] Anything beyond the scope of this task that you would consider when running this code in a real production environment.


## Submission Guidance

### Shoulds
- Use only plain Terraform in your solution, i.e. anything supported by the Terraform CLI installed by the `run.sh` script, but not external tooling or libraries that wrap or extend Terraform, such as Terragrunt or tfenv
- Only modify files in the `tf/` directory, `run.sh`, and `docker-compose.yml`
- Keep the current versions of the services running in `development` and `production` environments
- Structure your code in a way that will segregate environments
- 🚨 All environments (including staging) should be created when you run `vagrant up` and the apps should print `service started` and the secret data in their logs 🚨
- Structure your code in a way that allows engineers to run different versions of services in different environments

### Should-nots
- Do not use external tools that extend Terraform, such as Terragrunt.



## Evaluation

We understand that in a take-home exercise there is often a desire to demonstrate the full scope of your Terraform knowledge and experience. However, we will be evaluating whether your design, abstractions, and overall solution are appropriate for the requirements of this exercise, the context in which it will be used, and the limited time investment expected.

Your submission will be evaluated based on the following criteria:

1. **Correctness**
- The Terraform code runs successfully (`vagrant up` completes without errors).
- All environments — development, staging, and production — are correctly created and functional.
- Each service successfully retrieves its credentials from Vault, and all containers start as expected.
- The new staging environment is included and works as described in the instructions.

2. **Code quality**
- The Terraform code is well structured.
- Modules are designed with clear, appropriate abstractions.
- The solution avoids unnecessary complexity while making it easy to add, remove, or modify services or environments.

3. **README and documentation**
- The README clearly explains your design decisions and rationale.
- It outlines how your Terraform setup would integrate into a CI/CD pipeline.
- The writing is clear, concise, and grammatically correct, reflecting the standard of communication expected of engineers at Form3.

4. **Simplicity and focus**
- The solution focuses on the core requirements and demonstrates an understanding of appropriate abstraction without over-engineering.
- Additional features or improvements are welcome if they are well justified and do not obscure the core goals of the exercise.
- The code demonstrates sound engineering judgment — balancing maintainability, clarity, and practicality.

### What a successful submission looks like

- The code is modular, easy to extend, and maintains a clear separation between environments.
- The Terraform implementation is functional and self-contained — `vagrant up` provisions all environments without manual intervention.
- The README demonstrates thoughtful reasoning behind design choices, not just a description of what was changed.
- The approach reflects real-world pragmatism — appropriate abstractions, correct use of Terraform constructs, and an awareness of how this would scale in production.


## 📝 Candidate Instructions
1. Create a private [GitHub](https://help.github.com/en/articles/create-a-repo) repository containing the content of this repository.
2. Complete the [Task](#task) :tada:
3. [Invite](https://help.github.com/en/articles/inviting-collaborators-to-a-personal-repository) [@form3tech-interviewer-1](https://github.com/form3tech-interviewer-1) to your private repo.
4. Let us know you've completed the exercise using the link provided at the bottom of the email from our recruitment team.



