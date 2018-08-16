resource :ecscluster, 'AWS::ECS::Cluster' do
  cluster_name Fn::ref(:cluster)
end

output :EcsCluster, Fn::ref(:ecscluster), export: Fn::sub('${AWS::StackName}-EcsCluster')