#!/bin/bash -xev


while getopts 'p:P:v:s:n:V:' c
do
  case $c in
    p) POLICY_GROUP=$OPTARG ;;
    P) POLICY_NAME=$OPTARG ;;
    v) VALIDATORKEY=$OPTARG ;;
    s) CHEFSERVERURL=$OPTARG ;;
    n) CHEFVALIDATIONCLIENTNAME=$OPTARG ;;
    V) CHEFCLIENTVERSION=$OPTARG ;;
  esac
done

# Do some chef pre-work
/bin/mkdir -p /etc/chef/trusted_certs
/bin/mkdir -p /var/lib/chef
/bin/mkdir -p /var/log/chef


cd /etc/chef/

# Install chef
#curl -L https://omnitruck.chef.io/install.sh | sudo bash -s $CHEFCLIENTVERSION -- -v  || error_exit 'could not install chef'

STRING_VAL_KEY=`echo -n "${VALIDATORKEY}"| base64 --decode`

# Create validator
cat > "/etc/chef/validator.pem" << EOF
${STRING_VAL_KEY}
EOF

NODE_NAME=`hostname -s`

# Create client.rb
cat > '/etc/chef/client.rb' << EOF
chef_license            'accept'
log_location            STDOUT
chef_server_url         "${CHEFSERVERURL}"
validation_client_name  "${CHEFVALIDATIONCLIENTNAME}"
validation_key          '/etc/chef/validator.pem'
node_name               "${NODE_NAME}"
policy_group            "${POLICY_GROUP}"
policy_name             "${POLICY_NAME}"
EOF

#/usr/bin/chef-client