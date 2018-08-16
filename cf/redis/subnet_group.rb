resource :subnetgroup, 'AWS::ElastiCache::SubnetGroup' do
  description Fn::ref('AWS::StackName')
  subnet_ids Fn::split(',', Fn::import_value(Fn::sub('${vpc}-SubnetIds')))
end