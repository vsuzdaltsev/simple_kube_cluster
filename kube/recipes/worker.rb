# frozen_string_literal: true

#
# Cookbook:: kube
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#

directory '/home/ubuntu/.kube' do
  owner 'ubuntu'
  group 'ubuntu'
  mode  '0755'
end

execute 'download join token' do
  command 'aws s3 cp s3://yaa-test/join.node.txt .'

  only_if { `aws s3 ls s3://yaa-test/join.node.txt` }
end

execute 'download kubeconfig' do
  command 'aws s3 cp s3://yaa-test/config /home/ubuntu/.kube/config; chown -R ubuntu:ubuntu /home/ubuntu/.kube'

  only_if { `aws s3 ls s3://yaa-test/config` }
  # not_if  { File.exist?('/home/ubuntu/.kube/config') }
end

execute 'join worker to cluster' do
  command 'grep "kubeadm join" -A 1 /join.node.txt > /tmp/join_command.sh; sudo bash /tmp/join_command.sh'

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
