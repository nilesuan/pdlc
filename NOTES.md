I as the platform head, what would be the lean team composition. We use AWS deploy to ecs on ec2 with terraform
what guidelines will we need to have from the platform team to the developers when they consume the platform? Guidelines like naming schema, character limits on AWS resources, etc.. add it to platform-team/

continues delivery is working so a system is always in a releasable state
jobs that run on merge requests isn't continous integration as it has not integrated into the system

I want definitive and strict policy like TBD, TDD, SOLID, CLEAN Architecture etc that is industry standard and will prescribe how we develop productes.

TRUNK BASED DEVELOPMENT 
If our repositories are all in gitlab, how do I make sure that all our repos are secure and what configurations do I need to apply to all repositories? e.g. branch protection, etc...
Only run once, terraform plan should only be on the merge review, on merge to main, it just runs terraform apply
how do we lint and make sure that the terraform plan is valid? there are some caveats in terraform that aren't caught in terraform plan like a JSON IAM policy not being correct, pointing to resources that doesn't exist so it get's rejected on apply, resource names going over 32 characters, etc....
Automated code reviews are enough, code reviews are supposed to check for code quality. Unit tests are supposed to indicated if the code works or not.
we should have very specific rules on auto merge (as much as possible) and reject
main should auto deploy to development, then manual for preproduction and production
there should be absolute guidance on how to name container images before pushing them to ecr and how we should tag for deployment to development preproduction and production without having to rebuild the container image






based on the handbook/ what processes are on each stage? 