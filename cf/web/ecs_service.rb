resource :ecssvc, 'AWS::ECS::Service', DependsOn: [:ecstask, :sgalb, :albtg, :alb443] do
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
        Fn::ref(:sgalb),
        Fn::import_value(Fn::sub('${db}-SecurityGroup')),
        Fn::import_value(Fn::sub('${redis}-SecurityGroup')),
      ]
    end
  end
  task_definition Fn::ref(:ecstask)
  load_balancers [
    {
      ContainerName: :web,
      ContainerPort: 8001,
      TargetGroupArn: Fn::ref(:albtg),
    }
  ]
end