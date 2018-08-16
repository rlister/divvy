## security group for http from internet to ALB
resource :sgweb, 'AWS::EC2::SecurityGroup' do
  group_description 'HTTP internet to ALB'
  vpc_id Fn::import_value(Fn::sub('${vpc}-VpcId'))
  security_group_ingress [
    { CidrIp: '0.0.0.0/0', IpProtocol: :tcp, FromPort: 443, ToPort: 443 },
  ]
  security_group_egress [
    { CidrIp: '0.0.0.0/0', IpProtocol: '-1', FromPort: 0, ToPort: 0 }
  ]
  tag :Name, Fn::ref('AWS::StackName')
end

## security group for http between ALB and containers
resource :sgalb, 'AWS::EC2::SecurityGroup' do
  group_description 'HTTP between ALB and containers'
  vpc_id Fn::import_value(Fn::sub('${vpc}-VpcId'))
  security_group_egress [
    { CidrIp: '0.0.0.0/0', IpProtocol: '-1', FromPort: 0, ToPort: 0 }
  ]
  tag :Name, Fn::ref('AWS::StackName')
end

## separate resource so we can point sg to itself;
resource :sgalbin, 'AWS::EC2::SecurityGroupIngress', DependsOn: [:sgalb] do
  group_id Fn::ref(:sgalb)
  ip_protocol :tcp
  from_port 0
  to_port 65535
  source_security_group_id Fn::ref(:sgalb)
end