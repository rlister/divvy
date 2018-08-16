resource :ecstask, 'AWS::ECS::TaskDefinition', DependsOn: [:iamroleexec, :iamroletask, :loggroup] do
  cpu 512
  memory '2GB'
  requires_compatibilities [:FARGATE]
  execution_role_arn Fn::get_att(:iamroleexec, :Arn)
  task_role_arn Fn::get_att(:iamroletask, :Arn)
  network_mode :awsvpc
  container_definitions [
    {
      Name: :web,
      MemoryReservation: 512,
      Image: Fn::sub('${image}:${version}'),
      Environment: [
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
      ],
      PortMappings: [
        { ContainerPort: 8001 }
      ],
      Command: %w[divvyinterfaceserver -n],
      LogConfiguration: {
        LogDriver: :awslogs,
        Options: {
          'awslogs-region'        => Fn::ref('AWS::Region'),
          'awslogs-group'         => Fn::ref(:loggroup),
          'awslogs-stream-prefix' => :web,
        }
      }
    }
  ]
end