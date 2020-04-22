# frozen_string_literal: true

ruby_block 'kill running pods' do
  block do
    running_pods = lambda {
      `kubectl get pods`.split.select do |pod|
        pod if pod.include?('postgres') || pod.include?('web-api')
      end
    }
    running_pods.call.each do |pod|
      `kubectl delete pods #{pod}`
    end
  end
  action :run
end
