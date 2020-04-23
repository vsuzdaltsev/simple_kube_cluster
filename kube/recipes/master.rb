# frozen_string_literal: true

#
# Cookbook:: kube
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#

init_log     = node['master']['init_log']
bucket       = node['s3_bucket']
kubectl_conf = node['kubectl']['config']['path']
pod_cidr     = node['kubernetes']['pod_cidr']

directory '/home/ubuntu/.kube'

execute 'kubeadm init' do
  command "kubeadm init --pod-network-cidr=#{pod_cidr} > #{init_log}"

  action :run

  not_if { File.exist?('/etc/kubernetes/manifests/kube-apiserver.yaml') }
end

execute 'create kubeconfig' do
  command "touch #{kubectl_conf} ; cat /etc/kubernetes/admin.conf > #{kubectl_conf}"

  action :run

  not_if { File.exist?(kubectl_conf) }
end

execute 'apply kube-flannel' do
  command 'kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml'
end

execute 'upload join token' do
  command "aws s3 cp /#{init_log} s3://#{bucket}/#{init_log}"

  not_if { system("aws s3 ls #{bucket}/#{init_log}") }
end

execute 'upload kubeconfig' do
  command "aws s3 cp #{kubectl_conf} s3://#{bucket}/config"

  not_if { system("aws s3 ls #{bucket}/config") }
end

execute 'install helm' do
  command 'sudo snap install helm --classic'

  not_if { system('command -v helm') }
end
