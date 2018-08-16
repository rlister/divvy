description 'DivvyCloud Web Server'

## stacks
parameter :vpc,   type: :String
parameter :redis, type: :String
parameter :db,    type: :String

## TODO find a better solution for these creds
parameter :dbuser,   type: :String, default: :divvy
parameter :dbpasswd, type: :String, default: 's3cr3t123', no_echo: true

## docker image to run
parameter :image,   type: :String, default: 'divvycloud/divvycloud'
parameter :version, type: :String, default: 'v18.2.27'

## ACM SSL cert
parameter :cert, type: :String, default: 'arn:aws:acm:us-east-1:171596573904:certificate/0659e1a8-6257-47a0-8842-86e73b1edb5a'

## domain for ALB DNS alias
parameter :domain, type: :String, default: 'spree.fm.'

include_template(
  'web/log_group.rb',
  'web/iam_role_exec.rb',
  'web/iam_role_task.rb',
  'web/security_groups.rb',
  'web/alb.rb',
  'web/ecs_task.rb',
  'web/ecs_service.rb',
  'web/route53.rb',
)