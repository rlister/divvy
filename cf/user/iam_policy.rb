resource :iampolicy, 'AWS::IAM::ManagedPolicy' do
  description 'Read-only permissions for DivvyCloud user'
  path '/divvy/'
  policy_document(
    {
      Version: '2012-10-17',
      Statement: [
        {
          Action: [
            'ec2:Describe*',
            'ec2:List*',
            'ec2:Get*',
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'elasticloadbalancing:Describe*',
            'elasticloadbalancing:List*',
            'elasticloadbalancing:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'autoscaling:Describe*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Effect: :Allow,
          Action: [
            'kms:List*',
            'kms:Get*',
            'kms:Describe*'
          ],
          Resource: '*'
        },
        {
          Action: [
            'cloudwatch:Describe*',
            'cloudwatch:List*',
            'cloudwatch:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'rds:Describe*',
            'rds:List*',
            'rds:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'redshift:Describe*',
            'redshift:List*',
            'redshift:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            's3:Describe*',
            's3:List*',
            's3:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'iam:Describe*',
            'iam:List*',
            'iam:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'route53:Describe*',
            'route53:List*',
            'route53:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'elasticache:Describe*',
            'elasticache:List*',
            'elasticache:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'cloudtrail:Describe*',
            'cloudtrail:List*',
            'cloudtrail:Get*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'elasticfilesystem:Describe*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'es:Describe*',
            'es:List*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'lambda:Get*',
            'lambda:List*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'config:Describe*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'organizations:List*'
          ],
          Effect: :Allow,
          Resource: '*'
        },
        {
          Action: [
            'sts:AssumeRole',
            'sts:GetCallerIdentity',
            'sts:GetFederationToken',
            'sts:GetSessionToken'
          ],
          Effect: :Allow,
          Resource: '*'
        }
      ]
    }
  )
end