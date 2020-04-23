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

directory '/home/ubuntu/.kube' do
  owner 'ubuntu'
  group 'ubuntu'
  mode  '0755'
end

execute 'download join token' do
  command "aws s3 cp s3://#{bucket}/#{init_log} ."

  only_if { system("aws s3 ls s3://#{bucket}/#{init_log}") }
end

execute 'download kubeconfig' do
  command "aws s3 cp s3://#{bucket}/config #{kubectl_conf}; chown -R ubuntu:ubuntu /home/ubuntu/.kube"

  only_if { system("aws s3 ls s3://#{bucket}/config") }
end

execute 'join worker to cluster' do
  command "grep 'kubeadm join' -A 1 /#{init_log} > /tmp/join_command.sh; sudo bash /tmp/join_command.sh"

  not_if { File.exist?('/etc/kubernetes/kubelet.conf') }
end

directory '/mnt/data' do
  owner 'ubuntu'
  group 'ubuntu'
  mode  '0755'
end

execute 'chown db data directory' do
  command 'sudo chown -R 1001:1001 /mnt/data/'
end
