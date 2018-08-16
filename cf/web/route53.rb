resource :r53, 'AWS::Route53::RecordSetGroup' do
  hosted_zone_name Fn::ref(:domain)
  comment Fn::ref('AWS::StackName')
  record_sets [
    {
      Name: Fn::sub('${AWS::StackName}.${domain}'),
      Type: :A,
      AliasTarget: {
        HostedZoneId: Fn::get_att(:alb, :CanonicalHostedZoneID),
        DNSName:      Fn::get_att(:alb, :DNSName),
      }
    }
  ]
end