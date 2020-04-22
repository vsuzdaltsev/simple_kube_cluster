# frozen_string_literal: true

#
# Cookbook:: kube
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#

apt_repository 'docker' do
  uri          'https://download.docker.com/linux/ubuntu'
  arch         'amd64'
  components   %w[stable]
  distribution 'eoan'
  key          'https://download.docker.com/linux/ubuntu/gpg'
end

apt_repository 'kubernetes' do
  uri          'http://apt.kubernetes.io/'
  components   %w[kubernetes-xenial main]
  distribution ''
  key          'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
end

%w[kubelet kubeadm kubectl].each do |pkg|
  apt_package 'name' do
    package_name pkg
  end
end

apt_package 'containerd.io' do
  version '1.2.13-1'
end

apt_package 'docker-ce' do
  version '5:19.03.8~3-0~ubuntu-eoan'
end

apt_package 'docker-ce-cli' do
  version '5:19.03.8~3-0~ubuntu-eoan'
end

template '/etc/docker/daemon.json' do
  source 'daemon.json.erb'
  owner  'root'
  group  'root'
  mode   '0755'
end

directory '/etc/systemd/system/docker.service.d' do
  owner  'root'
  group  'root'
  mode   '0755'

  notifies :run, 'execute[reload_docker]', :immediately
end

execute 'reload_docker' do
  command 'systemctl daemon-reload; systemctl restart docker'
  action :nothing
end

execute 'swapoff' do
  command 'swapoff -a'
  action :run
end
