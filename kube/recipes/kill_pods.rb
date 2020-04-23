# frozen_string_literal: true

ruby_block 'kill running pods' do
  block do
    `kubectl get pods`.split.grep(/postgres|web-api/).tap do |running_pods|
      running_pods.each do |pod|
        system("kubectl delete pods #{pod}")
      end
    end
  end
  action :run
end
