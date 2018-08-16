resource :iamuser, 'AWS::IAM::User', DependsOn: [:iampolicy] do
  path '/divvy/'
  managed_policy_arns [Fn::ref(:iampolicy)]
end

output :IamUser, Fn::ref(:iamuser)