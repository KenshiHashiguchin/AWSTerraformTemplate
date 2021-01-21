# frozen_string_literal: true

### Install ###
package 'https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm' do
  not_if 'rpm -q amazon-cloudwatch-agent'
end

package 'amazon-cloudwatch-agent'

### Configuration Files ###
remote_file '/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json' do
  mode '0644'
  owner 'root'
  group 'root'
end

### Service ###
service 'amazon-cloudwatch-agent' do
  action %i[enable start]
end
