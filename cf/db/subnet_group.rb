resource :subnetgroup, 'AWS::RDS::DBSubnetGroup' do
  d_b_subnet_group_description Fn::ref('AWS::StackName')
  subnet_ids Fn::split(',', Fn::import_value(Fn::sub('${vpc}-SubnetIds')))
end