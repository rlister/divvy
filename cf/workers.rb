description 'DivvyCloud Workers'

parameter :vpc,   type: :String
parameter :redis, type: :String
parameter :db,    type: :String

## TODO use a better solution for these creds
parameter :dbuser,   type: :String, default: :divvy
parameter :dbpasswd, type: :String, default: 's3cr3t123', no_echo: true

## docker image to run
parameter :image,   type: :String, default: 'divvycloud/divvycloud'
parameter :version, type: :String, default: 'v18.2.27'

## DRY shared environment
@environment = [
  ## MySQL 5.7 Primary database
  { Name: :DIVVY_MYSQL_HOST,            Value: Fn::import_value(Fn::sub('${db}-DbAddress')) },
  { Name: :DIVVY_MYSQL_PORT,            Value: Fn::import_value(Fn::sub('${db}-DbPort')) },
  { Name: :DIVVY_MYSQL_USER,            Value: Fn::ref(:dbuser) },
  { Name: :DIVVY_MYSQL_PASSWORD,        Value: Fn::ref(:dbpasswd) },
  ## MySQL 5.7 Secure database
  { Name: :DIVVY_SECURE_MYSQL_HOST,     Value: Fn::import_value(Fn::sub('${db}-DbAddress')) },
  { Name: :DIVVY_SECURE_MYSQL_PORT,     Value: Fn::import_value(Fn::sub('${db}-DbPort')) },
  { Name: :DIVVY_SECURE_MYSQL_USER,     Value: Fn::ref(:dbuser) },
  { Name: :DIVVY_SECURE_MYSQL_PASSWORD, Value: Fn::ref(:dbpasswd) },
  ## Redis
  { Name: :DIVVY_REDIS_HOST,            Value: Fn::import_value(Fn::sub('${redis}-ClusterAddress')) },
  { Name: :DIVVY_REDIS_PORT,            Value: Fn::import_value(Fn::sub('${redis}-ClusterPort')) },
  ## Divvy Required - do not modify
  { Name: :VIRTUAL_ENV,                 Value: '/' },
  { Name: :DIVVY_MYSQL_DB_NAME,         Value: :divvy },
  { Name: :DIVVY_SECURE_MYSQL_DB_NAME,  Value: :divvykeys },
]

include_template(
  'workers/log_group.rb',
  'workers/iam_role_exec.rb',
  'workers/iam_role_task.rb',
  'workers/ecs_task_sched.rb',
  'workers/ecs_task_ondemand.rb',
  'workers/ecs_task_harvest.rb',
  'workers/ecs_task_longharvest.rb',
  'workers/ecs_task_processor.rb',
  'workers/ecs_service_sched.rb',
  'workers/ecs_service_ondemand.rb',
  'workers/ecs_service_harvest.rb',
  'workers/ecs_service_longharvest.rb',
  'workers/ecs_service_processor.rb',
)