resource :sg, 'AWS::EC2::SecurityGroup' do
  group_description 'Redis access'
  vpc_id Fn::import_value(Fn::sub('${vpc}-VpcId'))
  security_group_egress [
    { CidrIp: '0.0.0.0/0', IpProtocol: '-1', FromPort: 0, ToPort: 0 }
  ]
  tag :Name, Fn::ref('AWS::StackName')
end

## separate resource so we can point sg to itself
resource :sgingress, 'AWS::EC2::SecurityGroupIngress', DependsOn: :sg do
  group_id Fn::ref(:sg)
  ip_protocol :tcp
  from_port 6379
  to_port 6379
  source_security_group_id Fn::ref(:sg)
end

output :SecurityGroup, Fn::ref(:sg), export: Fn::sub('${AWS::StackName}-SecurityGroup')