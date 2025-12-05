


 [X] Improve the Terraform code to make it easy to add, update, and remove services.
 ## ⚙️ Approuche 1
     - I used two approaches in executing the task. The first involves the main.tf and providers.tf files.
      In this approach, I refactored the original code, trying to organize it into blocks by environment. 
      I also created the staging environment, using the production code as a template. 
      The credentials for authentication were treated as variables in the auto.tfvars prefix files.
       One file was created for each environment. 
       These files were hidden in the gitignore to avoid sharing them in the repository.
 ## ⚙️ Approuche 2
     - After organizing the code, I realized it could be done using `for_each` to reduce the amount of 
     code and reuse a good portion across the three environments and services. 
     This approach became somewhat complex because it required interpolating environments and services. 
     I tried to do it on my own, but I couldn't. I used an AI tool to help speed up the process. 
     This alternative approach is in the files: `main_for_each.tf`, `providers_for_each.tf` and `locals.tf`. 
     Technically, it was much more complex due to the service and environment interpolation. 
     I would need more time to try it on my own, doing tests, etc.

     

 [X] Add a new environment called `staging` that runs each microservice.
     -  Staging environmente created, ussing prod code as template for approuche 1.
      I only ajust the env names.


     [X] Add a README detailing:
     - Yes, I'm new to Terraform despite having a certification that expired a few months ago. 
     I don't work with Terraform on a daily basis. Currently, I'm more focused on CloudFormation, 
     but I have worked on some Terraform projects. 
     The Zeal Vora Udemy training was what I used for the certification exam, so I've already completed that training.


     [X] How your code would fit into a CI/CD pipeline.
     - This code fits well into the CI phase, with build, artifact creation, testing, and deployment steps. 
     I didn't go into the application details, but a compilation and code testing step could be done in this stage.
      An image is created and some security validations can be performed. Then a deployment is done.
      Some of these steps, mainly the security ones, are not done in this code.
       
- [X] Anything beyond the scope of this task that you would consider when running this code in a real production environment.

      

## Submission Guidance

### Shoulds
- Use only plain Terraform in your solution, i.e. anything supported by the Terraform CLI installed by
 the `run.sh` script, but not external tooling or libraries that wrap or extend Terraform, such as Terragrunt or tfenv
- Only modify files in the `tf/` directory, `run.sh`, and `docker-compose.yml`
- Keep the current versions of the services running in `development` and `production` environments
- Structure your code in a way that will segregate environments
- 🚨 All environments (including staging) should be created when you run `vagrant up` and the apps 
should print `service started` and the secret data in their logs 🚨
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



