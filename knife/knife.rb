log_level               :debug
log_location            STDOUT
ssl_verify_mode         :verify_none # SSL certs are invalid so we need to force them to ignore this
chef_server_url         'https://18.219.149.91/organizations/orchestration'
node_name               'circleci'
user                    'circleci'
client_key              '/home/circleci/chef_private'
cookbook_path [
  '/home/circleci/cookbooks/',
]