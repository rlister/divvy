description 'DivvyCloud VPC'

parameter :cluster, type: :String, description: 'name of ECS cluster'

include_template(
  'vpc/vpc.rb',
  'vpc/subnets.rb',
  'vpc/ecs_cluster.rb',
)