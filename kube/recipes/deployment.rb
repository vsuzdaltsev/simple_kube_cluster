# frozen_string_literal: true

helm_install_postgres = node['master']['helm_install_postgres']

template '/home/ubuntu/web-api.yml' do
  source 'web-api.yml.erb'
  owner  'ubuntu'
  group  'ubuntu'
  mode   '0755'
  action :create

  variables(
    worker_one: node['network']['interfaces']['eth0']['arp'].keys.sort[1]
  )
end

execute 'deployment' do
  command 'kubectl apply -f /home/ubuntu/web-api.yml'
  action :run
end

execute 'helm add repo' do
  command 'sudo -u ubuntu helm repo add bitnami https://charts.bitnami.com/bitnami'

  not_if { system('helm repo list | grep https://charts.bitnami.com/bitnami') }
end

execute 'helm repo update' do
  command 'sudo -u ubuntu helm repo update'
end

execute 'install db' do
  command "sudo -u ubuntu #{helm_install_postgres}"

  not_if { system('kubectl get pods | grep postgres | grep Running') }
end
