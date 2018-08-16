description 'DivvyCloud Redis'

## vpc stack
parameter :vpc, type: :String

include_template(
  'redis/subnet_group.rb',
  'redis/security_group.rb',
  'redis/cluster.rb',
)