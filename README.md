# Example deployment of DivvyCloud

This example uses idiomatic [stax](https://github.com/rlister/stax)
configuration to create a deployment of
[DivvyCloud](https://divvycloud.com/) using several Cloudformation
stacks.

Web and worker tasks are run in ECS Fargate.

## To do

- fix credentials for db
- switch db from mysql to Aurora
- improve IAM role for user
- cloudwatch metrics and alerts