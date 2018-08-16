description 'DivvyCloud Database'

## import vpc stack name
parameter :vpc, type: :String

## CHANGE ME: do not embed real passwd in template
parameter :dbpasswd, type: :String, no_echo: true, default: 's3cr3t123'

include_template(
  'db/subnet_group.rb',
  'db/security_group.rb',
  'db/db.rb',
)