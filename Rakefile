# frozen_string_literal: true

def ip(node)
  require 'json'

  JSON.parse(`terraform output -json`)["#{node}_public_ip"]['value']
end

def chef_run(node:, recipe:, cookbook: 'kube')
  puts ">> Performing chef-run/#{cookbook}/#{recipe} on #{node} node"
  sh("chef-run --identity ~/.ssh/id_rsa ssh://ubuntu@#{ip(node)} kube/recipes/#{recipe}.rb")
end

namespace :infrastructure do
  desc 'create infrastructure'
  task :create do
    puts '>> Performing terraform apply'
    sh('terraform init')
    sh('echo yes | terraform apply')
  end

  desc 'destroy infrastructure'
  task :destroy do
    puts '>> Performing terraform destroy'
    sh('echo yes | terraform destroy')
  end
end

namespace :notify do
  task :report do
    puts ">> open http://#{ip('worker_one')} in you favourite browser"
  end
end

namespace :chef do
  task :run_on_master_default do
    chef_run(node: 'master', recipe: 'default')
  end

  task :run_on_worker_one_default do
    chef_run(node: 'worker_one', recipe: 'default')
  end

  task :run_on_master_custom do
    chef_run(node: 'master', recipe: 'master')
  end

  task :run_on_worker_one_custom do
    chef_run(node: 'worker_one', recipe: 'worker')
  end

  task :cleanup_s3 do
    chef_run(node: 'master', recipe: 'cleanup')
  end

  task :deployment do
    chef_run(node: 'master', recipe: 'deployment')
  end

  desc 'converge all nodes'
  task :converge do
    puts '>> Performing chef-run'
    Rake::Task['chef:run_on_master_default'].execute
    Rake::Task['chef:run_on_master_custom'].execute
    Rake::Task['chef:run_on_worker_one_default'].execute
    Rake::Task['chef:run_on_worker_one_custom'].execute
    Rake::Task['chef:cleanup_s3'].execute
    Rake::Task['chef:deployment'].execute
    Rake::Task['notify:report'].execute
  end
end
