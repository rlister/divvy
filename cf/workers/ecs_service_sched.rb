resource :ecssvcsched, 'AWS::ECS::Service', DependsOn: [:ecstasksched] do
  cluster Fn::import_value(Fn::sub('${vpc}-EcsCluster'))
  deployment_configuration do
    minimum_healthy_percent 100
    maximum_percent 200
  end
  desired_count 0
  launch_type :FARGATE
  network_configuration do
    awsvpc_configuration do
      subnets Fn::split(',', Fn::import_value(Fn::sub('${vpc}-SubnetIds')))
      assign_public_ip :ENABLED
      security_groups [
        Fn::import_value(Fn::sub('${db}-SecurityGroup')),
        Fn::import_value(Fn::sub('${redis}-SecurityGroup')),
      ]
    end
  end
  task_definition Fn::ref(:ecstasksched)
end