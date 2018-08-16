resource :alb, 'AWS::ElasticLoadBalancingV2::LoadBalancer', DependsOn: [:sgweb, :sgalb] do
  subnets Fn::split(',', Fn::import_value(Fn::sub('${vpc}-SubnetIds')))
  security_groups [
    Fn::ref(:sgweb),
    Fn::ref(:sgalb),
  ]
  tag :Name, Fn::ref('AWS::StackName')
end

resource :albtg, 'AWS::ElasticLoadBalancingV2::TargetGroup' do
  port 8001
  protocol :HTTP
  health_check_path '/Status'
  health_check_port 'traffic-port'
  health_check_protocol :HTTP
  vpc_id Fn::import_value(Fn::sub('${vpc}-VpcId'))
  target_type :ip
  tag :Name, Fn::ref('AWS::StackName')
end

## listen on 443, terminate SSL, and forward to target
resource :alb443, 'AWS::ElasticLoadBalancingV2::Listener', DependsOn: [:alb, :albtg] do
  load_balancer_arn Fn::ref(:alb)
  port 443
  protocol :HTTPS
  certificates [
    { CertificateArn: Fn::ref(:cert) }
  ]
  ssl_policy 'ELBSecurityPolicy-TLS-1-2-2017-01'
  default_actions [ {Type: :forward, TargetGroupArn: Fn::ref(:albtg)} ]
end

output :AlbArn,     Fn::ref(:alb)
output :AlbName,    Fn::get_att(:alb, :LoadBalancerName)
output :AlbDnsName, Fn::get_att(:alb, :DNSName)