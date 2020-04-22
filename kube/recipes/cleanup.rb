# frozen_string_literal: true

execute 'rm file from bucket' do
  command 'aws s3 rm s3://yaa-test/join.node.txt'

  only_if { system('aws s3 ls s3://yaa-test/join.node.txt') }
end

execute 'rm file from bucket' do
  command 'aws s3 rm s3://yaa-test/config'

  only_if { system('aws s3 ls s3://yaa-test/config') }
end
