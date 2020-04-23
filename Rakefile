# frozen_string_literal: true

require 'json'

def private_key
  '~/.ssh/id_rsa'
end

def ip(node)
  JSON.parse(`terraform output -json`)["#{node}_public_ip"]['value']
end

def chef_run(node:, recipe:, cookbook: 'kube')
  puts ">> Performing chef-run/#{cookbook}/#{recipe} on #{node} node"
  sh("chef-run --identity #{private_key} ssh://ubuntu@#{ip(node)} kube/recipes/#{recipe}.rb")
end

def run_concurrently(tasks:)
  puts '>> Performing chef-run concurrently'
  tasks.each_with_object([]) do |task, threads|
    threads << Thread.new(task) do
      task.execute
    end
  end.each(&:join)
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
  task :where_app_endpoint do
    puts ">> open http://#{ip('worker_one')} in you favourite browser"
  end
end

namespace :running_pods do
  desc 'kill running pods within cluster'
  task :kill do
    chef_run(node: 'master', recipe: 'kill_pods')
    puts '>> Wait a bit while kubernetes restores the killed pods. Usually it takes up to 10 seconds'
    Rake::Task['notify:where_app_endpoint'].execute
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
    default_recipe_tasks = [
      Rake::Task['chef:run_on_master_default'],
      Rake::Task['chef:run_on_worker_one_default']
    ]

    run_concurrently(tasks: default_recipe_tasks)

    Rake::Task['chef:run_on_master_custom'].execute
    Rake::Task['chef:run_on_worker_one_custom'].execute

    Rake::Task['chef:cleanup_s3'].execute
    Rake::Task['chef:deployment'].execute

    Rake::Task['notify:where_app_endpoint'].execute
  end
end
