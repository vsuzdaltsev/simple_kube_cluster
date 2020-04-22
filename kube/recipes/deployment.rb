# frozen_string_literal: true

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
  # command 'sudo -u ubuntu helm install postgres stable/ --set persistence.size=512M,persistence.storageClass=manual,persistence.mountPath=/mnt/data, > db_install.log'
  command 'sudo -u ubuntu helm install postgres bitnami/postgresql --set image.repository=postgres --set image.tag=10.6 --set persistence.size=512M,persistence.storageClass=manual,persistence.mountPath=/mnt/data --set postgresqlPassword=yaa,postgresqlDatabase=yaa,postgresqlDataDir=/mnt/data > db_install.log'

  not_if { system('kubectl get pods | grep postgres | grep Running') }
end
