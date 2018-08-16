resource :ecstasksched, 'AWS::ECS::TaskDefinition', DependsOn: [:iamroleexec, :iamroletask, :loggroup] do
  cpu 512
  memory '2GB'
  requires_compatibilities [:FARGATE]
  execution_role_arn Fn::get_att(:iamroleexec, :Arn)
  task_role_arn Fn::get_att(:iamroletask, :Arn)
  network_mode :awsvpc
  container_definitions [
    {
      Name: :sched,
      MemoryReservation: 512,
      Image: Fn::sub('${image}:${version}'),
      Environment: @environment,
      Command: %w[divvycloudjobscheduler -n --do-db-upgrade],
      LogConfiguration: {
        LogDriver: :awslogs,
        Options: {
          'awslogs-region'        => Fn::ref('AWS::Region'),
          'awslogs-group'         => Fn::ref(:loggroup),
          'awslogs-stream-prefix' => :sched,
        }
      }
    }
  ]
end