
ruby_block 'kill running pods' do
  block do
    running_pods = -> { `kubectl get pods`.split.select { |pod| pod if pod.include? 'postgres' or pod.include? 'web-api' } }
    running_pods.call.each do |pod|
      `kubectl delete pods #{pod}`
    end
  end
  action :run
end