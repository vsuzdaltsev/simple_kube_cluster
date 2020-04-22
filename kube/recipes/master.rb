# frozen_string_literal: true

#
# Cookbook:: kube
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#

init_log = 'join.node.txt'

directory '/home/ubuntu/.kube'

execute 'kubeadm init' do
  command "kubeadm init --pod-network-cidr=10.244.0.0/16 > #{init_log}"
  action :run

  not_if { File.exist?('/etc/kubernetes/manifests/kube-apiserver.yaml') }
end

execute 'create kubeconfig' do
  command 'touch /home/ubuntu/.kube/config ; cat /etc/kubernetes/admin.conf > /home/ubuntu/.kube/config'
  action :run

  not_if { File.exist?('/home/ubuntu/.kube/config') }
end

execute 'apply kube-flannel' do
  command 'kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml'
end

execute 'upload join token' do
  command 'aws s3 cp /join.node.txt s3://yaa-test/join.node.txt'

  not_if { system('aws s3 ls yaa-test/join.node.txt') }
end

execute 'upload kubeconfig' do
  command 'aws s3 cp /home/ubuntu/.kube/config s3://yaa-test/config'

  not_if { system('aws s3 ls yaa-test/config') }
end

execute 'install helm' do
  command 'sudo snap install helm --classic'

  not_if { system('command -v helm') }
end

execute 'install helm' do
  command 'sudo snap install helm --classic'

  not_if { system('command -v helm') }
end

# helm install mongodb stable/mongodb --set persistence.size=512M --set persistence.storageClass=manual
