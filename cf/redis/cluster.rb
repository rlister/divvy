resource :cluster, 'AWS::ElastiCache::CacheCluster', DependsOn: [:subnetgroup, :sg] do
  engine :redis
  engine_version '3.2.4'
  num_cache_nodes 1
  cache_node_type 'cache.t2.medium'
  cache_subnet_group_name Fn::ref(:subnetgroup)
  vpc_security_group_ids [Fn::ref(:sg)]
  preferred_availability_zone Fn::select(0, Fn::split(',', Fn::import_value(Fn::sub('${vpc}-SubnetZones'))))
  preferred_maintenance_window 'sun:08:00-sun:09:00'
  tag :Name, Fn::ref('AWS::StackName')
end

output :Cluster,        Fn::ref(:cluster),                              export: Fn::sub('${AWS::StackName}-Cluster')
output :ClusterAddress, Fn::get_att(:cluster, 'RedisEndpoint.Address'), export: Fn::sub('${AWS::StackName}-ClusterAddress')
output :ClusterPort,    Fn::get_att(:cluster, 'RedisEndpoint.Port'),    export: Fn::sub('${AWS::StackName}-ClusterPort')