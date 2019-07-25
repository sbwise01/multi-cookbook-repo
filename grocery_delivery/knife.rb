log_level               :info
log_location            STDOUT
node_name               'chef'
chef_server_url         'https://18.219.149.91'
node_name               'node1'
client_key              '/home/circleci/chef_private'
cookbook_path [
  '/home/circleci/cookbooks/',
]

ssl_verify_mode         :verify_none
