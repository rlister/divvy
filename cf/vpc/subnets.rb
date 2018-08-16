subnets = 2.times.map do |i|
  "subnet#{i}".tap do |subnet|

    resource subnet, 'AWS::EC2::Subnet', DependsOn: :vpc do
      vpc_id Fn::ref(:vpc)
      availability_zone Fn::select(i, Fn::get_azs)
      cidr_block Fn::select(i, Fn::cidr(Fn::get_att(:vpc, :CidrBlock), 256, 8))
      tag :Name, Fn::ref('AWS::StackName')
    end

    resource "rt#{subnet}", 'AWS::EC2::SubnetRouteTableAssociation', DependsOn: [subnet, :routetable] do
      subnet_id Fn::ref(subnet)
      route_table_id Fn::ref(:routetable)
    end

  end
end

output :SubnetIds,   Fn::join(',', subnets.map(&Fn.method(:ref))), export: Fn::sub('${AWS::StackName}-SubnetIds')
output :SubnetZones, Fn::join(',', subnets.map{ |s| Fn::get_att(s, :AvailabilityZone) }), export: Fn::sub('${AWS::StackName}-SubnetZones')