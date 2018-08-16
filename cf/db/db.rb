resource :db, 'AWS::RDS::DBInstance', DependsOn: [:subnetgroup, :sg] do
  allocated_storage 100
  allow_major_version_upgrade false
  backup_retention_period 7
  d_b_instance_class 'db.t2.large'
  d_b_name :divvy
  d_b_subnet_group_name Fn::ref(:subnetgroup)
  engine :mysql
  engine_version '5.7.17'
  license_model 'general-public-license'
  master_username 'divvy'
  master_user_password Fn::ref(:dbpasswd)
  port 3306
  preferred_backup_window '05:52-06:22'
  preferred_maintenance_window 'wed:04:37-wed:05:07'
  storage_encrypted true
  storage_type :gp2
  v_p_c_security_groups [Fn::ref(:sg)]
  tag :Name, Fn::ref('AWS::StackName')
end

output :DbId,      Fn::ref(:db),                         export: Fn::sub('${AWS::StackName}-DbId')
output :DbAddress, Fn::get_att(:db, 'Endpoint.Address'), export: Fn::sub('${AWS::StackName}-DbAddress')
output :DbPort,    Fn::get_att(:db, 'Endpoint.Port'),    export: Fn::sub('${AWS::StackName}-DbPort')